# create instance
resource "aws_instance" "dvr" {
  ami           = "ami-095413544ce52437d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  #security_groups         = [aws_security_group.security_group.id]
  key_name                = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized           = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "dvr"
  }
  user_data = <<EOF
#!/usr/bin/bash
echo "Changing hostname"
sudo hostname dvr
sudo echo dvr > /etc/hostname
EOF
}


output "instance_private_ip" {
  value = aws_instance.dvr.private_ip
}

# Jumphost
resource "aws_instance" "jumphost" {
  instance_type = "t2.micro"
  ami           = "ami-095413544ce52437d" # https://cloud-images.ubuntu.com/locator/ec2/ (Ubuntu)
  subnet_id     = aws_subnet.nat_gateway.id
  #security_groups         = [aws_security_group.security_group.id]
  key_name                = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized           = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "jumphost"
  }
  user_data = <<EOF
#!/usr/bin/bash
echo "Changing hostname"
sudo hostname jumphost
sudo echo jumphost > /etc/hostname
EOF
}

output "jumphost_ip" {
  value = aws_eip.jumphost.public_ip
}

# attach the security group to the instance primary interface
resource "aws_network_interface_sg_attachment" "security_group_attach" {
  security_group_id    = aws_security_group.security_group.id
  network_interface_id = aws_instance.jumphost.primary_network_interface_id
}

