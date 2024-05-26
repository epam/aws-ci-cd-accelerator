#======================= The image for Atlantis ===========================#
resource "null_resource" "image_create" {
  provisioner "local-exec" {
    command = "./atlantis-image/script.sh"
    environment = {
      aws_account_id = var.aws_account_id
      region         = var.region
    }
  }
  depends_on = [aws_ecr_repository.atlantis]
}
