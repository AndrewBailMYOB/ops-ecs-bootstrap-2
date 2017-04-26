create:
	docker-compose run stackup account-vpc-template up -t template.yml -p params.json

delete:
	docker-compose run stackup account-vpc-template down
