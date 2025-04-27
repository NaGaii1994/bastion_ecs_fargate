# Bastion ECS Fargate
ECS Fargateを使用したサーバーレスな踏み台サーバーをTerraformで作成します。

## 従来型のBastionホスト(EC2)と比較したメリット
- 運用負荷の軽減(OSパッチ適用、ログ管理、インスタンス管理)
- 再現性向上(どこでも「同じ環境」を必ず作れる。)
- セキュリティ向上(インストールするパッケージやバージョンを明示的に固定できるので、意図しないアップデートや脆弱性混入を防げる。)

## 使い方

### デプロイ

```
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