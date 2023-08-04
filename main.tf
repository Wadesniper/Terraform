provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["C:/Users/Utilisateur/OneDrive/Bureau/aws_credentials.txt"]
}


# Création du sg
module "sg" {
  source = "C:/Users/Utilisateur/OneDrive/Bureau/DEVOPS E.T/mini projet terraform/modules/sg"
}

# Création du volume
module "ebs" {
  source    = "C:/Users/Utilisateur/OneDrive/Bureau/DEVOPS E.T/mini projet terraform/modules/ebs"
  disk_size = 5
}

# Création de l'EIP
module "eip" {
  source = "C:/Users/Utilisateur/OneDrive/Bureau/DEVOPS E.T/mini projet terraform/modules/eip"
}

# Création de l'EC2 en surchargeant avec un type, l'output de l'EIP et l'output de la SG
module "ec2" {
  source        = "C:/Users/Utilisateur/OneDrive/Bureau/DEVOPS E.T/mini projet terraform/modules/ec2"
  instance_type = "t2.micro"
  public_ip     = module.eip.output_eip
  sg_name       = module.sg.output_sg_name

}

#Creation des associations nécessaires
resource "aws_eip_association" "eip_assoc" {
  instance_id   = module.ec2.output_ec2_id
  allocation_id = module.eip.output_eip_id
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs.output_id_volume
  instance_id = module.ec2.output_ec2_id
}
