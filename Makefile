# Variables
DOCKER_RUN = docker run --rm -v $(PWD):/csv-parser -w /csv-parser

# Development Commands
bash:
	$(DOCKER_RUN) -it ruby:3.3 bash && bundle

test:
	$(DOCKER_RUN) -it ruby:3.3 bundle install
	$(DOCKER_RUN) -it ruby:3.3 bundle exec rspec

.PHONY: bash test
