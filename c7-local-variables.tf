# Define Local Values in Terraform
locals {
  user_data = <<-EOT
  #!/bin/bash
  whoami
  cd /home/ubuntu
  sudo -u ubuntu gunicorn -b 0.0.0.0:5000 --workers=1 app:app
  EOT
}