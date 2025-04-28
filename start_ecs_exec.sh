#!/bin/bash

# 引数チェック
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <SUBNET_ID> <SECURITY_GROUP_ID>"
  exit 1
fi

SUBNET_ID="$1"
SECURITY_GROUP_ID="$2"

AWS_ACCOUNT_ID=$(terraform output -raw aws_account_id)
AWS_REGION=$(terraform output -raw aws_region)

CLUSTER_NAME=$(terraform output -raw bastion_cluster_name)
TASK_DEFINITION=$(terraform output -raw bastion_task_family)
ECR=$(terraform output -raw bastion_ecr)
CONTAINER_NAME="bastion"

# ECRログイン
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# イメージpush
if [ "$(uname -m)" = "arm64" ]; then
  docker buildx build --platform linux/amd64 -t bastion-ecr .
else
  docker build -t bastion-ecr .
fi

docker tag bastion-ecr:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/bastion-ecr:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/bastion-ecr:latest

# run-taskでFargateタスク起動
TASK_ARN=$(aws ecs run-task \
  --cluster "${CLUSTER_NAME}" \
  --task-definition "${TASK_DEFINITION}" \
  --launch-type FARGATE \
  --enable-execute-command \
  --network-configuration "awsvpcConfiguration={subnets=[${SUBNET_ID}],securityGroups=[${SECURITY_GROUP_ID}],assignPublicIp=ENABLED}" \
  --query "tasks[0].taskArn" \
  --output text)

echo "Started Task: ${TASK_ARN}"

# タスクのステータスがRUNNINGになるまで待機
echo "Waiting for task to reach RUNNING status..."
aws ecs wait tasks-running --cluster ${CLUSTER_NAME} --tasks ${TASK_ARN}
echo "Task is now running."

# ecs execute-commandで接続
MAX_RETRIES=10
RETRY_DELAY=5
for ((i=1; i<=MAX_RETRIES; i++)); do
  echo "[$i/$MAX_RETRIES] Trying to connect..."
  
  aws ecs execute-command \
    --cluster ${CLUSTER_NAME} \
    --task ${TASK_ARN} \
    --container ${CONTAINER_NAME} \
    --interactive \
    --command "/bin/bash"

  STATUS=$?
  if [ $STATUS -eq 0 ]; then
    echo "Connected successfully!"
    exit 0
  else
    echo "Connection failed. Retrying in ${RETRY_DELAY}s..."
    sleep $RETRY_DELAY
  fi
done

echo "Failed to connect after $MAX_RETRIES attempts."
exit 1