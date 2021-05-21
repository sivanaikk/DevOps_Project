#!/bin/bash

# you can change to latest version to install
TERRAFORM_PACKAGE=terraform_0.15.3_linux_amd64.zip

python3 --version

if [[ $? -ne 0 ]]
then 
	echo "Installing Python3..."
	yum install python3-pip -y 
	echo "Installing Ansible..."
	pip3 install ansible
fi
echo "Requirement Done..."

git --version 

if [[ $? -ne 0 ]]
then 
	echo "Installing Git..."
	yum install git -y 
fi 
echo "Requirement Done..."

terraform --version 
if [[ $? -ne 0 ]]
then 
	echo "Installing Terraform..."
        wget https://releases.hashicorp.com/terraform/0.15.3/$TERRAFORM_PACKAGE
	unzip TERRAFORM_PACKAGE
	mkdir /terraform 
	mv terraform /terraform 
	PATH=$PATH:/terrform 
	echo "PATH=$PATH:/terrform" >> ~/.bashrc
	touch ~/.bashrc
	terraform -install-autocomplete
fi 
echo "Requirement Done..."

pip3 install python-jenkins
pip3 install boto3

cd ./infra << EOF
	terraform plan
EOF


	













