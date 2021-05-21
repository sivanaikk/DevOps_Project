# ec2-keypair.tf variables

KEY_NAME  = "devops_project"

#   vpc.tf variables

VPC_CIDR = "10.0.0.0/16"
SUBNET_CIDR = "10.0.0.0/16"
SUBNET_AZ = "ap-south-1a" # Mumbai

#  jenkins-master.tf variables 

JENKINS_MASTER_INSTANCE_TYPE = "t2.micro"
JENKINS_MASTER_AMI = "ami-0a9d27a9f4f5c0efc" # RedHat Image in ap-south 


# jenkins-agent.tf variables

JENKINS_AGENT_INSTANCE_TYPE = "t2.micro"
JENKINS_AGENT_AMI = "ami-0a9d27a9f4f5c0efc" # RedHat Image in ap-south 
JENKINS_AGENTS = 1

# kube-master.tf variables

K8S_MASTER_INSTANCE_TYPE = "t2.micro"
K8S_MASTER_AMI = "ami-0a9d27a9f4f5c0efc" # RedHat Image in ap-south 

# kube-node.tf variables

K8S_NODE_INSTANCE_TYPE = "t2.micro"
K8S_NODE_AMI = "ami-0a9d27a9f4f5c0efc" # RedHat Image in ap-south 
K8S_NODES = 3
# metrics-monitoring.tf variables 

METRICS_INSTANCE_TYPE = "t2.micro"
METRICS_AMI = "ami-0a9d27a9f4f5c0efc" # RedHat Image in ap-south 

# grafana.tf variables 

ELK_INSTANCE_TYPE = "t2.micro"
ELK_AMI = "ami-0a9d27a9f4f5c0efc" # RedHat Image in ap-south 

 

