#!/bin/bash

# Threshold and configuration
CPU_THRESHOLD=75
INSTANCE_COUNT=$(aws ec2 describe-instances --filters "Name=tag:AutoScalingGroupName,Values=devops-scaling-group"     --query "Reservations[*].Instances[*].[InstanceId]" --output text | wc -l)
SNS_TOPIC_ARN="arn:aws:sns:ap-south-1:909569945631:devops-scaling-alerts"

# Function to get average CPU utilization
CPU_UTILIZATION=$(aws cloudwatch get-metric-statistics   --metric-name CPUUtilization   --start-time $(date -u -d '-5 minutes' +%Y-%m-%dT%H:%M:%SZ)   --end-time $(date -u +%Y-%m-%dT%H:%M:%SZ)   --period 300   --namespace AWS/EC2   --statistics Average   --dimensions Name=AutoScalingGroupName,Value=devops-scaling-group   --query "Datapoints[0].Average" --output text)

CPU_UTILIZATION_INT=${CPU_UTILIZATION%.*}

# Scaling decision
if [ "$CPU_UTILIZATION_INT" -ge "$CPU_THRESHOLD" ]; then
    aws autoscaling set-desired-capacity --auto-scaling-group-name devops-scaling-group --desired-capacity $((INSTANCE_COUNT+1))
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --subject "High CPU Usage Alert" --message "CPU usage is $CPU_UTILIZATION% - scaling up instance."
else
    aws sns publish --topic-arn "$SNS_TOPIC_ARN" --subject "CPU Normal" --message "CPU usage is normal ($CPU_UTILIZATION%)."
fi
