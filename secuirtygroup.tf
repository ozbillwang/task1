#Create SG TCP/22 from your IP
resource "aws_security_group" "jumpbox-sg" {

  name        = "jumpbox-sg"
  description = "Allow TCP/22"
  vpc_id      = aws_vpc.MyFirstVPC.id
  ingress {
    description = "Allow 22 from our public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "app-sg" {

  name        = "app-sg"
  description = "Allow TCP/22"
  vpc_id      = aws_vpc.MyFirstVPC.id
  ingress {
    description     = "Allow 22 from our Jumpbox"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jumpbox-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

