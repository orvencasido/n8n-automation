# Makefile

.PHONY: start stop test

start:
	gh workflow run start-ec2.yaml \
		--ref ${GITHUB_BRANCH} \
		--field action=start; \
	RUN_ID=$$(gh run list --workflow start-ec2.yaml --limit 1 --json databaseId -q '.[0].databaseId'); \
	gh run watch $$RUN_ID --exit-status; \
	gh run view $$RUN_ID --log | grep -E "Public IPv4: .*"

stop:
	gh workflow run start-ec2.yaml \
		--ref ${GITHUB_BRANCH} \
		--field action=stop \
	echo "EC2 Instance Stopped"


	
