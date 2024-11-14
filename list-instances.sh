#!/bin/bash

# Specify the regions you want to check
regions=("us-east-1" "us-east-2" "us-west-2" "ap-south-1")

# Loop through each specified region
for region in "${regions[@]}"; do
  echo "Region: $region"

  echo "Running Instances:"
  aws ec2 describe-instances --region $region \
    --filters "Name=instance-state-name,Values=running" \
    --query "Reservations[*].Instances[*].{InstanceID:InstanceId,Name:Tags[?Key=='Name']|[0].Value,InstanceType:InstanceType,State:State.Name,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,LaunchTime:LaunchTime}" \
    --output table

  echo "Stopped Instances:"
  aws ec2 describe-instances --region $region \
    --filters "Name=instance-state-name,Values=stopped" \
    --query "Reservations[*].Instances[*].{InstanceID:InstanceId,Name:Tags[?Key=='Name']|[0].Value,InstanceType:InstanceType,State:State.Name,PublicIP:PublicIpAddress,PrivateIP:PrivateIpAddress,LaunchTime:LaunchTime}" \
    --output table

  echo "----------------------------"
done
