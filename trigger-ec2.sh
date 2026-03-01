#!/bin/bash
# trigger.sh - loads secrets and triggers Makefile

ENV_PATH=".env"

# Load .env file
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# Default action is 'start', can override with first argument
ACTION=${1:-start}

# Call Makefile
make $ACTION