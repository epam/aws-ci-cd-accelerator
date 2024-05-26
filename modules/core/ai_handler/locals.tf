locals {
  storage_bucket = "${var.storage_bucket_prefix}-${var.project}-${var.region}"
  layer_path     = "${path.module}/functions"
}
