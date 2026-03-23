# Google Cloud 最小構成サンプル
# - Cloud Storage バケットを 1 つ作成
# - バケット名はグローバル一意のためランダム接尾辞を付与

terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "GCP プロジェクト ID（コンソールの「プロジェクトの設定」で確認）"
  type        = string
}

variable "region" {
  description = "リージョン（東京なら asia-northeast1）"
  type        = string
  default     = "asia-northeast1"
}

# Cloud Storage API を有効化（初回 apply で API 未使用だと失敗しがちなので明示）
resource "google_project_service" "storage" {
  project            = var.project_id
  service            = "storage.googleapis.com"
  disable_on_destroy = false
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "demo" {
  name                        = "${var.project_id}-tf-demo-${random_id.suffix.hex}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true # 学習用: terraform destroy で中身ごと削除

  depends_on = [google_project_service.storage]
}

output "bucket_name" {
  description = "作成されたバケット名"
  value       = google_storage_bucket.demo.name
}

output "bucket_url" {
  description = "gsutil 用 URL"
  value       = google_storage_bucket.demo.url
}
