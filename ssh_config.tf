data "template_file" "ssh_key" {
  template = <<-EOT
${tls_private_key.ssh.private_key_pem}
EOT
}

data "template_file" "ssh_config" {
  template = <<-EOT
    Host jumphost
      Hostname ${aws_instance.jumphost.public_ip}
      User ubuntu
      IdentityFile ~/.ssh/aws_private_key.rsa
    
    Host dvr
      Hostname ${aws_instance.dvr.private_ip}
      User ubuntu
      IdentityFile ~/.ssh/aws_private_key.rsa
      ProxyJump jumphost
  EOT
}

resource "local_file" "ssh_config" {
  content  = data.template_file.ssh_config.rendered
  filename = pathexpand("~/.ssh/aws_config")
}

resource "local_file" "ssh_key" {
  content          = data.template_file.ssh_key.rendered
  filename         = pathexpand("~/.ssh/aws_private_key.rsa")
  file_permissions = "0600"
}

