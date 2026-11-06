provider aws {
     region = "ap-south-1"
 }

 resource "aws_vpc" "my_vpc" {
     cidr_block = "10.0.0.0/16"
     enable_dns_support   = true
     enable_dns_hostnames = true

     tags = {
         Name = "MyVPC"
     }

 }

 resource "aws_subnet" "my_subnet" {
     vpc_id            = aws_vpc.my_vpc.id
     cidr_block        = "10.0.1.0/24"
     map_public_ip_on_launch = true
     tags = {
         Name = "MySubnet"
     }
 }

 resource "aws_internet_gateway" "my_igw" {
     vpc_id = aws_vpc.my_vpc.id

     tags = {
         Name = "MyInternetGateway"
     }
 }

 resource "aws_route_table" "my_route_table" {
     vpc_id = aws_vpc.my_vpc.id
     route {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.my_igw.id
     }

     tags = {
         Name = "MyRouteTable"
     }
 }

 resource "aws_route_table_association" "my_route_table_association" {
     subnet_id      = aws_subnet.my_subnet.id
     route_table_id = aws_route_table.my_route_table.id
 }

 resource "aws_security_group" "my_security_group" {
     name        = "my_security_group"
     description = "Allow SSH and HTTP"
     vpc_id      = aws_vpc.my_vpc.id

     tags = {
         Name = "MySecurityGroup"
     }

     ingress {
         from_port   = 22
         to_port     = 22
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
         from_port   = 80
         to_port     = 80
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
         from_port   = 9090
         to_port     = 9090
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }

     ingress {
         from_port   = 3000
         to_port     = 3000
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }


     ingress {
         from_port   = 9100
         to_port     = 9100
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
     }

        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }

 }

resource "tls_private_key" "my_key" {
    algorithm = "RSA"
    rsa_bits  = 4096

}

resource "aws_key_pair" "my_key_pair" {
    key_name   = "my_key_pair"
    public_key = tls_private_key.my_key.public_key_openssh
}
resource "local_file" "private_key" {
    content  = tls_private_key.my_key.private_key_pem
    filename = "${path.module}/my_key.pem"
    file_permission = 0400
}

resource "aws_instance" "my_instance" {
     ami           = "ami-0c7632fb77f35db43" 
     instance_type = "t2.micro"
     vpc_security_group_ids = [aws_security_group.my_security_group.id]
     subnet_id     = aws_subnet.my_subnet.id
     key_name     = aws_key_pair.my_key_pair.key_name
     associate_public_ip_address = true
     user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install -y nginx
                sudo systemctl start nginx
                sudo apt install -y docker.io
                sudo systemctl start docker
                sudo systemctl enable docker
                sudo usermod -aG docker ubuntu
             EOF

     tags = {
         Name = "MyInstance"
     }

     provisioner "remote-exec" {
        inline = [
            "cloud-init status --wait",
            "sudo apt install fontconfig openjdk-21-jre -y",
            "sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key",
            "echo 'deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/' | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
            "sudo apt-get update -y",
            "sudo apt-get install jenkins -y",
            "sudo systemctl start jenkins",
            "sudo systemctl enable jenkins",    
            "sudo usermod -aG docker jenkins",
            "sudo systemctl restart jenkins",


        ]

        connection {
            type        = "ssh"
            user        = "ubuntu"
            private_key = tls_private_key.my_key.private_key_pem
            host        = self.public_ip
        }
       
     }
 }
