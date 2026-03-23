# GCP + Terraform 最小サンプル

Cloud Storage バケットを 1 つ作るだけの最小例です。

## 前提

- [Terraform](https://developer.hashicorp.com/terraform/install) が入っている
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)（`gcloud`）が入っている
- 対象プロジェクトで **課金が有効** であること
- あなたのアカウントに **プロジェクト編集者** 相当の権限があること（最小権限に絞る場合は別途 IAM 設計が必要）

## 認証（ローカルで試すとき）

```bash
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

Terraform はデフォルトで **Application Default Credentials (ADC)** を使います。

## 使い方

```bash
cd gcp-terraform-minimal
copy terraform.tfvars.example terraform.tfvars   # Windows
# または: cp terraform.tfvars.example terraform.tfvars

# terraform.tfvars を編集して project_id を設定

terraform init
terraform plan
terraform apply
```

削除:

```bash
terraform destroy
```

## CI（GitHub Actions）で回す場合のメモ

ローカルは ADC、CI では **Workload Identity Federation（推奨）** またはサービスアカウントキー（非推奨）で `GOOGLE_APPLICATION_CREDENTIALS` 等を設定します。OIDC の具体手順は [Google の公式ドキュメント](https://cloud.google.com/iam/docs/workload-identity-federation-with-deployment-pipelines) を参照してください。
