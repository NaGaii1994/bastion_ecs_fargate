#!/bin/bash

set -e

# 引数チェック
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <SUBNET_ID> <SECURITY_GROUP_ID>"
  exit 1
fi

SUBNET_ID="$1"
SECURITY_GROUP_ID="$2"

CLUSTER_NAME=$(terraform output -raw bastion_cluster_name)
TASK_DEFINITION=$(terraform output -raw bastion_task_family)
CONTAINER_NAME="bastion"

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
aws ecs execute-command \
  --cluster ${CLUSTER_NAME} \
  --task ${TASK_ARN} \
  --container ${CONTAINER_NAME} \
  --interactive \
  --command "/bin/bash"