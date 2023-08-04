output "output_ec2_id" {
  value = aws_instance.mini-projet-ec2.id
}

output "output_ec2_AZ" {
  value = aws_instance.mini-projet-ec2.availability_zone
}
