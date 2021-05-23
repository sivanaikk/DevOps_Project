
variable "K8S_NODE_AMI" {}
variable "K8S_NODE_INSTANCE_TYPE" {}
variable "K8S_NODES" {}


resource "aws_security_group" "k8s_node_sg" {
    depends_on = [
      aws_vpc.devops_vpc
    ]
    name = "k8s_node_sg"
    vpc_id = aws_vpc.devops_vpc.id
    ingress  {
        #cidr_blocks = [ aws_vpc.devops_vpc.cidr_block ]
        security_groups = [ aws_security_group.k8s_master_sg.id ]
        description = "Kuberntes Node Ingress"
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
      "Name" = "K8S-Node-SG"
    }
}

resource "aws_instance" "k8s_node" {
    depends_on = [
      aws_subnet.devops_subnet,
      aws_security_group.k8s_node_sg,
      aws_key_pair.generated_key
    ]
    ami = var.K8S_NODE_AMI 
    instance_type = var.K8S_NODE_INSTANCE_TYPE
    subnet_id = aws_subnet.devops_subnet.id
    vpc_security_group_ids = [ aws_security_group.k8s_node_sg.id ]
    key_name = aws_key_pair.generated_key.key_name
    count = var.K8S_NODES
    tags = {
      "Name" = "K8SNode"
    }
}
