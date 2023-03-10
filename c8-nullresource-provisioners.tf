resource "null_resource" "name" {
  depends_on = [module.ec2_public_bastion_host]
  count = length(module.ec2_public_bastion_host[*].public_ip)
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type     = "ssh"
    host     = module.ec2_public_bastion_host[count.index].public_ip
    user     = "ec2-user"
    password = ""
    private_key = file("private-key/ec2-key.pem")
  }

  ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/ec2-key.pem"
    destination = "/tmp/ec2-key.pem"
  }

  provisioner "file" {
    content     = templatefile("nginx/template.conf.tftpl", {ip_addrs = toset(module.ec2_public_bastion_host[*].public_ip)})
    destination = "/tmp/default.conf"
  }

}
