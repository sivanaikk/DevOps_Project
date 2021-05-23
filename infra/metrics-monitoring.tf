
variable "METRICS_AMI" {}
variable "METRICS_INSTANCE_TYPE" {}


resource "aws_security_group" "metrics_sg" {
    depends_on = [
      aws_vpc.devops_vpc
    ]
    name = "metrics_sg"
    vpc_id = aws_vpc.devops_vpc.id
    ingress  {
        cidr_blocks = [ aws_vpc.devops_vpc.cidr_block ]
        description = "Metrics Server Ingress"
        from_port = 0
        protocol = "-1"
        to_port = 0
    }
    
    ingress  {
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description = "Prometheus Ingress WebUI"
        from_port = 9090
        protocol = "tcp"
        to_port = 9090
    }
    
    ingress  {
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        description = "Grafana Ingress WebUI"
        from_port = 3000
        protocol = "tcp"
        to_port = 3000
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
      "Name" = "Metrics-SG"
    }
}

resource "aws_instance" "metrics_monitoring" {
    depends_on = [
      aws_subnet.devops_subnet,
      aws_security_group.metrics_sg,
      aws_key_pair.generated_key
    ]
    ami = var.METRICS_AMI 
    instance_type = var.METRICS_INSTANCE_TYPE
    subnet_id = aws_subnet.devops_subnet.id
    vpc_security_group_ids = [ aws_security_group.metrics_sg.id ]
    key_name = aws_key_pair.generated_key.key_name

    tags = {
      "Name" = "MetricsMonitoring"
    }
}
