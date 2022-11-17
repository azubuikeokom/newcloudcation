resource "aws_instance" "server" {
  ami           = "ami-0b0dcb5067f052a63" 
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids  = [aws_security_group.allow_web.id]
  subnet_id = aws_subnet.public_subnet.id
  user_data =<<-EOF
    #! /bin/bash
    sudo yum update
    sudo yum install httpd -y
    sudo systemctl start httpd
    sudo systemctl enable httpd

  EOF

}