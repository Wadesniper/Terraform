# Terraform + Nginx Server: Create AWS ressources and installing nginx server
![nginx_icon-100](https://github.com/Wadesniper/Terraform/assets/57738842/5d80a15b-62fb-4a58-9ff4-c273f061be6a)


The purposes of this project is to deploys an ec2 instances with a fixed public Ip, security groups and one additional EBS to store our personnal data. After deploying the AWS ec2 instance with its right others link objects, we run automatically on this ec2 instance the installation of nginx server

Find below a light description of this project source code.

## Terraform modules
### Requirements
This terraform project uses 04 modules to create one aws ec2 instance with the right objects association. The specifics needs for this project is the terraform aws provider libray and aws account credentials

### Attributes definition
Available variables are listed below, along with default values (see `modules/<module_name>/variable.tf`):

we have to use 04 modules (ec2, eip, sg and ebs) to create our ec2 instance, public IP, SG and additionnal EBS. In order to link these modules to each other, wue used output files that we well describe below as well
<br>
<br>
<br>
### *** For EC2 module ***

#### Variables
Used for tag all aws resources in this project
```hcl
variable "maintainer" {
  type    = string
  default = "SBWADE"
}
```
Used to customizise the instance type of our ec2
```hcl
variable "instance_type" {
  type    = string
  default = "t2.nano"
}
```
Used to specify which key pair will be use by our ec2 to enable the ssh connection
```hcl
variable "ssh_key" {
  type    = string
  default = "DevOps"
}
```
Used to retrieve the sg_name of our sg module's output which contains the name of the security group; this variabe permit use to make the link between our ec2 an his sg.
```hcl
variable "sg_name" {
  type    = string
  default = "NULL"
}
```
Used to retrieve the public_ip of our eip module's output which contains the PUBLIC IP we'll use to create the ec2_file_infos in ec2 module
```hcl
variable "public_ip" {
  type    = string
  default = "NULL"
}
```
use to specify the availability zone we'll use
```hcl
variable "AZ" {
  type    = string
  default = "us-east-1b"
}
```
User name we'll use to etablish the remote connexion with our ec2 instance
```hcl
variable "user" {
  type    = string
  default = "ubuntu"
}
```
<br>

#### Output file
Output to expose the id of our instance to other module
```hcl
output "output_ec2_id" {
  value = aws_instance.mini-projet-ec2.id
}
```
Output to expose the az of our instance to other module
```hcl
output "output_ec2_AZ" {
  value = aws_instance.mini-projet-ec2.availability_zone
}
```

<br>
<br>
<br>

### *** For SG module ***

#### Variables
this module just have the variable to tag all its resources
```hcl
variable "maintainer" {
  type    = string
  default = "SBWADE"
}
```
<br>

#### Output file
Expose the security group name to other modules
```hcl
output "output_sg_name" {
  value = aws_security_group.my_sg.name
}
```


<br>
<br>
<br>


### *** For EIP module ***

#### Variables
Any variable for this module

<br>

#### Output file
Expose his public IP to other modules
```hcl
output "output_eip" {
  value = aws_eip.my_eip.public_ip
}
```
Expose eip-id to tne other module (use to make association with ec2)
```hcl
output "output_eip_id" {
  value = aws_eip.my_eip.id
}
```

<br>
<br>
<br>


### *** For EBS module ***

#### Variables
Used for tag all our aws resources or objects
```hcl
variable "maintainer" {
  type    = string
  default = "SBWADE"
}
```

Use to customize the size of ow new EBS
```hcl
variable "disk_size" {
  type    = number
  default = 2
}
```

use to specify the availability zone we'll use
```hcl
variable "AZ" {
  type    = string
  default = "us-east-1b"
}
```
<br>

#### Output file
Expose the Ebs_id to other modules (use to attach this vol to our ec2)
```hcl
output "output_id_volume" {
  value = aws_ebs_volume.my_vol.id
}
```

<br>
<br>
<br>

## Dependencies
* Make sure to have the correct variable value before run this app.

  ### Example of use
```hcl
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
```
