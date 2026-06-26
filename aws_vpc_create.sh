#!/bin/bash

#########################################
# Description: Create VPC in AWS
# - Create VPC
# - Create a public subnet
# 
# - Verify if user has AWS installed, User might be using windows, linux or mac.
# - verify if AWS CLI is configured
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

# Tag the VPC
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME --region $REGION
echo "VPC tagged with name: $VPC_NAME"

# Create a public subnet
echo "Creating public subnet..."  
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --availability-zone $SUBNET_AZ --query '
Subnet.SubnetId' --output text --region $REGION)
echo "Public subnet created with ID: $SUBNET_ID"

# Tag the subnet
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=$SUBNET_NAME --region $REGION
echo "Subnet tagged with name: $SUBNET_NAME"

# End of script