
data "aws_ssm_parameter" "linuxAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


resource "aws_key_pair" "master-key" {

  key_name   = "Demo"
  public_key = file("public.txt")

}


resource "aws_instance" "myec2" {
  ami           = "ami-0b3d7a5ecc2daba4c"
  instance_type = "t2.micro"

}





#Create EC2
resource "aws_instance" "jumpbox" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jumpbox-sg.id]
  subnet_id                   = aws_subnet.subnet_public.id

  tags = {
    Name = "JumpBox"
  }

}

#Create EC2
resource "aws_instance" "app" {
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app-sg.id]
  subnet_id                   = aws_subnet.subnet_private.id

  tags = {
    Name = "App"
  }

}








resource "aws_eip" "jumphost" {
  instance = aws_instance.jumpbox.id
  vpc      = true
}

output "jumphost_ip" {
  value = aws_eip.jumphost.public_ip
}

output "app_ip" {
  value = aws_instance.app.private_ip
}





