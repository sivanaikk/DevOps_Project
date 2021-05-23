
variable "JENKINS_AGENT_AMI" {}
variable "JENKINS_AGENT_INSTANCE_TYPE" {}
variable "JENKINS_AGENTS" {}


resource "aws_security_group" "jenkins_agent_sg" {
    depends_on = [
      aws_vpc.devops_vpc
    ]

    name = "jenkins_agent_sg"
    vpc_id = aws_vpc.devops_vpc.id
    ingress  {
        #cidr_blocks = [ aws_vpc.devops_vpc.cidr_block ]
        security_groups = [ aws_security_group.jenkins_master_sg.id ]
        description = "Jenkins Agent Ingress"
        from_port = 0
        protocol = "-1"
        to_port = 0
    }

    ingress {
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description = "Kuberntes Master Ingress from API Server"
        from_port = 22
        protocol = "tcp"
        to_port = 22
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    }
    
    tags = {
      "Name" = "Jenkins-Agent-SG"
    }
}

resource "aws_instance" "jenkins_agent" {
    depends_on = [
      aws_subnet.devops_subnet,
      aws_security_group.jenkins_agent_sg,
      aws_key_pair.generated_key
    ]
    ami = var.JENKINS_AGENT_AMI 
    instance_type = var.JENKINS_AGENT_INSTANCE_TYPE
    subnet_id = aws_subnet.devops_subnet.id
    vpc_security_group_ids = [ aws_security_group.jenkins_agent_sg.id ]
    key_name = aws_key_pair.generated_key.key_name
    count = var.JENKINS_AGENTS

    tags = {
      "Name" = "JenkinsAgent"
    }
}
