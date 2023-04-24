# Ubuntu EC2 Public IP
output "ubuntu_ec2_public_ip" {
  value = aws_instance.ec2-ubuntu[*].public_ip
}

# RedHat EC2 Public IP
output "redhat_ec2_public_ip" {
  value = aws_instance.ec2-redhat[*].public_ip
}