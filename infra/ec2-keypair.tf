variable "KEY_NAME" {}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  depends_on = [
    tls_private_key.private_key
  ]
  key_name   = var.KEY_NAME
  public_key = tls_private_key.private_key.public_key_openssh
}


resource "null_resource" "save_private_key" {
  depends_on = [
    aws_key_pair.generated_key
  ]
  provisioner "local-exec" {
    command = "echo '${tls_private_key.private_key.private_key_pem}' >  ./'${aws_key_pair.generated_key.key_name}'.pem "
  }
}


