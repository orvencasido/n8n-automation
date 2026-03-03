# Makefile

.PHONY: start stop test

start:
	gh workflow run start-ec2.yaml \
		--ref ${GITHUB_BRANCH} \
		--field action=start

stop:
	gh workflow run start-ec2.yaml \
		--ref ${GITHUB_BRANCH} \
		--field action=stop

test:
	gh workflow run start-ec2.yaml \
		--ref ${GITHUB_BRANCH} \
		--field action=test