# Makefile

.PHONY: start stop

start:
	@echo "EC2 Instance is Starting..."
	@curl -s -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\",\"inputs\":{\"action\":\"start\"}}"
	
	@echo "Fetching Public IP"
	@sleep 30

	@export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}; \
	export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}; \
	export AWS_REGION=${AWS_REGION}; \
	PUBLIC_IP=$$(aws ec2 describe-instances \
	  --instance-ids ${EC2_INSTANCE_ID} \
	  --query "Reservations[0].Instances[0].PublicIpAddress" \
	  --output text \
	  --region $${AWS_REGION}); \
	echo "Public IPv4: $$PUBLIC_IP"

stop:
	@echo "EC2 Instance is Stopping..."
	@curl -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\", \"inputs\": {\"action\": \"stop\"}}"
	@echo "EC2 Instance Stopped"