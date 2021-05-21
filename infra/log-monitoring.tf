
variable "ELK_AMI" {}
variable "ELK_INSTANCE_TYPE" {}


resource "aws_security_group" "logs_sg" {
    depends_on = [
      aws_vpc.devops_vpc
    ]
    name = "logs_sg"
    vpc_id = aws_vpc.devops_vpc.id
    ingress  {
        cidr_blocks = [ aws_vpc.devops_vpc.cidr_block ]
        description = "ELK Ingress"
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    
    ingress  {
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description = "Elatic Search Ingress WebUI"
        from_port = 9200
        protocol = "tcp"
        to_port = 9200
    }
    
    ingress  {
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description = "Kibbana Ingress WebUI"
        from_port = 5601
        protocol = "tcp"
        to_port = 5601
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      "Name" = "Logs-SG"
    }
}

resource "aws_instance" "elk_stack" {
    depends_on = [
      aws_subnet.devops_subnet,
      aws_security_group.logs_sg,
      aws_key_pair.generated_key
    ]
    ami = var.ELK_AMI 
    instance_type = var.ELK_INSTANCE_TYPE
    subnet_id = aws_subnet.devops_subnet.id
    vpc_security_group_ids = [ aws_security_group.logs_sg.id ]
    key_name = aws_key_pair.generated_key.key_name

    tags = {
      "Name" = "LogsMonitoring"
    }
}
