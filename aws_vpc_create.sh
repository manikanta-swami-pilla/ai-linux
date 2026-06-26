#!/bin/bash

#########################################
# Description: Create VPC in AWS
# - Create VPC
# - Create a public subnet
# 
# - Verify if user has AWS installed, User might be using windows, linux or mac.
# - verify if AWS CLI is configured
# - Usage: ./aws_vpc_create.sh
# - options: deleteVPC - delete the VPC created by this script,
#            deleteSubnet - delete the subnet created by this script
#            --help - display this help message
# 
#
#########################################

# Variables
VPC_NAME="vpc-demo"
SUBNET_NAME="subnet-demo"
REGION="us-east-1"
VPC_CIDR="10.0.0.0/16"
SUBNET_NAME="10.0.3.0/24"
SUBNET_AZ="us-east-1a"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found. Please install AWS CLI before running this script."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null
then
    echo "AWS CLI is not configured. Please configure AWS CLI with your credentials before running this script."
    exit 1
fi

# Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text --region $REGION)
echo "VPC created with ID: $VPC_ID" 

# Create a public subnet
echo "Creating public subnet..."  
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --availability-zone $SUBNET_AZ --query '
Subnet.SubnetId' --output text --region $REGION)
echo "Public subnet created with ID: $SUBNET_ID"

deleteVPC() {
    echo "Deleting VPC with ID: $VPC_ID"
    aws ec2 delete-vpc --vpc-id $VPC_ID --region $REGION
    echo "VPC deleted."
}

deleteSubnet() {
    echo "Deleting subnet with ID: $SUBNET_ID"
    aws ec2 delete-subnet --subnet-id $SUBNET_ID --region $REGION
    echo "Subnet deleted."
}

help() {
    echo "Usage: ./aws_vpc_create.sh [options]"
    echo "Options:"
    echo "  deleteVPC     Delete the VPC created by this script"
    echo "  deleteSubnet  Delete the subnet created by this script"
    echo "  --help        Display this help message"
}

# End of script