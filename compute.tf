resource "aws_instance" "web" {
  ami                         = "ami-06cc84810ae60c3ac"
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  root_block_device {
    delete_on_termination = true #this is not required, this is used to delete the root block device(root EBS volume) upon ec2 termination.
    volume_size           = 10
    volume_type           = "gp3"
  }
  count = 1 # use this to shutdown only ec2 when required
  tags = merge(local.common_tags, {
    Name = "Nginx-Project-EC2"
  })
  lifecycle {
    create_before_destroy = true #this will 1st create the new EC2 and next delete the old EC2 if we change AMI ID for EC2

  }
}
resource "aws_security_group" "web" {
  description = "allow http & https traffic"
  name        = "public-http-https"
  vpc_id      = aws_vpc.main.id
}
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.web.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}


