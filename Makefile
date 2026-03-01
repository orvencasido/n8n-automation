# Makefile

.PHONY: start stop

start:
	@echo "Triggering GitHub Actions workflow with action: start"
	@curl -s -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\",\"inputs\":{\"action\":\"start\"}}"

	@echo "EC2 Instance is Starting..."
	@sleep 45

	@RUN_ID=$$(curl -s \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/runs \
	  | jq -r '.workflow_runs[0].id'); \
	echo "Run ID: $$RUN_ID"; \
	PUBLIC_IP=$$(curl -s \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runs/$$RUN_ID/jobs \
	  | jq -r '.jobs[0].steps[] | select(.id=="start_ec2") | .outputs.PUBLIC_IP'); \
	echo "Public IP: $$PUBLIC_IP"

stop:
	@echo "Triggering GitHub Actions workflow with action: stop"
	@curl -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/start-ec2.yaml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\", \"inputs\": {\"action\": \"stop\"}}"
	@echo "EC2 Instance Stopped"