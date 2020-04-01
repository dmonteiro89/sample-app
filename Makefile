ifndef PROJECT_NAME
	PROJECT_NAME=application 
endif

ifndef PROJECT_LOCATION
	PROJECT_LOCATION=.
endif

ifndef ECR_REPO
	ECR_REPO=${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT_NAME}
endif

ifndef DOCKER_IMAGE_TAG
	DOCKER_IMAGE_TAG=latest
endif

DOCKER_COMPOSE=docker-compose -p $(PROJECT_NAME)
DOCKER_COMPOSE_RUN=$(DOCKER_COMPOSE) run --rm

.PHONY: docker-build
docker-build: ## build the docker image
	$(DOCKER_COMPOSE) build application

docker-verify:
	aws ecr describe-image-scan-findings --repository-name $(ECR_REPO) --image-id imageTag=$(DOCKER_IMAGE_TAG) --region $(AWS_REGION)

docker-push:
	aws ecr get-login --region us-east-1 --registry-ids $(AWS_ACCOUNT_ID) --no-include-email | bash
	docker push $(ECR_REPO):$(DOCKER_IMAGE_TAG)

docker-clean:
	$(DOCKER_COMPOSE) down -v

## example of how to use docker-compose as an interface
unit-tests:
	$(DOCKER_COMPOSE_RUN) application go test .