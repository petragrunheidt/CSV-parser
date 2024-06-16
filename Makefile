DOCKER_RUN = docker run --rm \
-v $(PWD):/csv-parser \
-v rubygems:/usr/local/bundle \
-v gemconfig:/root/.local/share/gem \
-w /csv-parser

bash:
	$(DOCKER_RUN) -it ruby:3.3 bash

test:
	$(DOCKER_RUN) -it ruby:3.3 bundle install
	$(DOCKER_RUN) -it ruby:3.3 bundle exec rspec

.PHONY: bash test
