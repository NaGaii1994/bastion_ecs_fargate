# Bastion ECS Fargate
ECS Fargateを使用したサーバーレスな踏み台サーバーをTerraformで作成します。

## 従来型のBastionホスト(EC2)と比較したメリット
- 運用負荷の軽減(OSパッチ適用、ログ管理、インスタンス管理)
- 再現性向上(どこでも「同じ環境」を必ず作れる。)
- セキュリティ向上(インストールするパッケージやバージョンを明示的に固定できるので、意図しないアップデートや脆弱性混入を防げる。)

## 作成されるAWSリソース一覧

| モジュール | リソースタイプ                         | リソース名                                 | 説明                                               |
|:-----------|:---------------------------------------|:-------------------------------------------|:---------------------------------------------------|
| bastion    | aws_ecr_repository                     | this                                       | ECRリポジトリ (bastion用)                          |
| bastion    | aws_ecs_cluster                        | this                                       | ECSクラスター (bastion-cluster)                    |
| bastion    | aws_ecs_task_definition                | this                                       | ECSタスク定義 (bastion-task)                       |
| bastion    | aws_iam_role                           | this                                       | ECSタスク実行用IAMロール (bastion-task-exec-role)   |
| bastion    | aws_iam_role_policy_attachment         | ecs_task_execution_role_ssm_policy         | SSM管理ポリシーをIAMロールにアタッチ               |
| bastion    | aws_iam_role_policy_attachment         | task_execution_attach                     | ECSタスク実行ロールポリシーをIAMロールにアタッチ    |

## 出力される情報（Outputs）

| 出力名                | 説明                                    |
|:----------------------|:----------------------------------------|
| aws_account_id         | AWSアカウントID                         |
| aws_region             | 使用リージョン                         |
| bastion_cluster_name   | 作成されるECSクラスター名               |
| bastion_ecr            | 作成されるECRリポジトリのURL             |
| bastion_task_family    | 作成されるタスクファミリー名             |


## 使い方

### デプロイ

```
terraform init
terraform plan
terraform apply
```
### ECS Exec接続
```
./start_ecs_exec.sh <SUBNET_ID> <SECURITY_GROUP_ID>
```
起動したタスクは忘れずに終了してください。

### 後片付け

```
terraform destroy
```