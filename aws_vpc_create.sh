#!/bin/bash

#########################################
# Description: Manage AWS VPC and Subnet
# Usage:
#   ./aws_vpc_create.sh create
#   ./aws_vpc_create.sh deleteVPC <vpc-id>
#   ./aws_vpc_create.sh deleteSubnet <subnet-id>
#   ./aws_vpc_create.sh --help
#########################################

# Variables
REGION="us-east-1"
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.3.0/24"
SUBNET_AZ="us-east-1a"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI could not be found. Please install AWS CLI before running this script."
    exit 1
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS CLI is not configured. Please configure AWS CLI with your credentials before running this script."
    exit 1
fi

# Functions
createVPC() {
    echo "Creating VPC..."
    VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text --region $REGION)
    echo "VPC created with ID: $VPC_ID"

    echo "Creating public subnet..."
    SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR --availability-zone $SUBNET_AZ --query 'Subnet.SubnetId' --output text --region $REGION)
    echo "Public subnet created with ID: $SUBNET_ID"
}

deleteVPC() {
    VPC_TO_DELETE=$1
    if [ -z "$VPC_TO_DELETE" ]; then
        echo "Please provide a VPC ID to delete."
        exit 1
    fi
    echo "Deleting VPC with ID: $VPC_TO_DELETE"
    aws ec2 delete-vpc --vpc-id "$VPC_TO_DELETE" --region $REGION
    echo "VPC deleted."
}

deleteSubnet() {
    SUBNET_TO_DELETE=$1
    if [ -z "$SUBNET_TO_DELETE" ]; then
        echo "Please provide a Subnet ID to delete."
        exit 1
    fi
    echo "Deleting subnet with ID: $SUBNET_TO_DELETE"
    aws ec2 delete-subnet --subnet-id "$SUBNET_TO_DELETE" --region $REGION
    echo "Subnet deleted."
}

help() {
    echo "Usage: ./aws_vpc_create.sh [options]"
    echo "Options:"
    echo "  create        Create VPC and subnet"
    echo "  deleteVPC <vpc-id>     Delete the specified VPC"
    echo "  deleteSubnet <subnet-id>  Delete the specified subnet"
    echo "  --help        Display this help message"
}

# Main logic
case "$1" in
    create)
        createVPC
        ;;
    deleteVPC)
        deleteVPC $2
        ;;
    deleteSubnet)
        deleteSubnet $2
        ;;
    --help)
        help
        ;;
    *)
        echo "Invalid option. Use --help for usage."
        ;;
esac