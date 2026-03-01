# Makefile

.PHONY: start stop

start:
	@echo "Triggering GitHub Actions workflow with action: start"
	@curl -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/EC2-Control.yml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\", \"inputs\": {\"action\": \"start\"}}"

stop:
	@echo "Triggering GitHub Actions workflow with action: stop"
	@curl -X POST \
	  -H "Accept: application/vnd.github+json" \
	  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
	  https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/workflows/EC2-Control.yml/dispatches \
	  -d "{\"ref\":\"${GITHUB_BRANCH}\", \"inputs\": {\"action\": \"stop\"}}"