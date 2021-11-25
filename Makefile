start:
	docker-compose up -d

restart:
	docker restart nz-covidpass-poc

stop:
	docker-compose down

lint:
	docker exec -t nz-covidpass-poc yarn lint

build:
	docker exec -t nz-covidpass-poc yarn build

exec:
	docker exec -it nz-covidpass-poc sh

logs:
	docker logs -f nz-covidpass-poc
