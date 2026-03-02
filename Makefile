# Makefile

.PHONY: start stop

start:
	@echo "EC2 Instance is Starting..."
	@curl -s -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\",\"inputs\":{\"action\":\"start\"}}" 
	@echo "Please wait, fetching the EC2 IPv4... In 2 minutes"
	@sleep 120
	@(RUN_ID=$$(curl -s -H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer ${GITHUB_TOKEN}" \
		"https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/runs?branch=${GITHUB_BRANCH}&event=workflow_dispatch" \
		| jq -r '.workflow_runs[0].id'); \
	 PUBLIC_IP=$$(curl -s -H "Accept: application/vnd.github+json" \
		-H "Authorization: Bearer ${GITHUB_TOKEN}" \
		"https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runs/$$RUN_ID/jobs" \
		| jq -r '.jobs[0].steps[] | select(.name=="Start EC2") | .outputs.PUBLIC_IP'); \
	 echo "Run ID: $$RUN_ID"; \
	 echo "EC2 Public IP: $$PUBLIC_IP")
	
stop:
	@echo "EC2 Instance is Stopping..."
	@curl -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\", \"inputs\": {\"action\": \"stop\"}}"
	@echo "EC2 Instance Stopped"