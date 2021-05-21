
variable "JENKINS_MASTER_AMI" {}
variable "JENKINS_MASTER_INSTANCE_TYPE" {}


resource "aws_security_group" "jenkins_master_sg" {
    depends_on = [
      aws_vpc.devops_vpc
    ]
    name = "jenkins_master_sg"
    vpc_id = aws_vpc.devops_vpc.id
    ingress  {
        cidr_blocks = [ aws_vpc.devops_vpc.cidr_block ]
        description = "Jenkins Ingress"
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
      "Name" = "Jenkins-Master-SG"
    }
}

resource "aws_instance" "jenkins_master" {
    depends_on = [
      aws_subnet.devops_subnet,
      aws_security_group.jenkins_master_sg,
      aws_key_pair.generated_key
    ]
    ami = var.JENKINS_MASTER_AMI 
    instance_type = var.JENKINS_MASTER_INSTANCE_TYPE
    subnet_id = aws_subnet.devops_subnet.id
    vpc_security_group_ids = [ aws_security_group.jenkins_master_sg.id ]
    key_name = aws_key_pair.generated_key.key_name

    tags = {
      "Name" = "JenkinsMaster"
    }
}
