/* Use these for training purposes
   Ami = ami-0aeeebd8d2ab47354
   Instance type = t2.micro
*/
# ///////////////////////
# Locals
# ///////////////////////

# ///////////////////////
# Provider
# ///////////////////////
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}

# ///////////////////////
# Resource
# ///////////////////////
resource "aws_instance" "aws_course_instance" {
  ami = "ami-0ab4d1e9cf9a1215a"
  instance_type = "t2.micro"

  user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
      echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
      EOF
   key_name = "EC2-KEY-PAIR"
   iam_instance_profile = aws_iam_instance_profile.iam_read_only_profile.name
   tags = {
     Name = "My First Instance"
     Department = "Finance"
   }
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    ipv6_cidr_blocks = ["::/0"]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# resource "aws_key_pair" "loginkey" {
#   key_name = "login-key"
#   public_key = file("${path.module}/EC2-KEY-PAIR.pem")
# }

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id = aws_security_group.allow_web.id
  network_interface_id = aws_instance.aws_course_instance.primary_network_interface_id
}

resource "aws_iam_instance_profile" "iam_read_only_profile" {
  name = "iam_read_only"
  role = "${aws_iam_role.iam_read_only_role.name}"
}

resource "aws_eip" "aws_caa_eip" {
  instance = aws_instance.aws_course_instance.id
}



# ///////////////////////
# Data
# ///////////////////////

# ///////////////////////
# Output
# ///////////////////////

output "ip" {
  value = aws_instance.aws_course_instance.public_ip
}
output "eip" {
   value = aws_eip.aws_caa_eip.public_ip
}
  
