resource "aws_ebs_volume" "my_vol" {
  availability_zone = var.AZ
  size              = var.disk_size

  tags = {
    Name = "${var.maintainer}-ebs"
  }
}