## Setup

If this is your first time setting up the project, you should do the following after cloning the repository:

### Setup docker
Install docker in your machine if not installed before (https://docs.docker.com/install/)

To setup project do following command to setup docker project:
```bash
docker-compose up --build
```

### Setup DB and run migrations

```bash
docker-compose run app rake db:create
docker-compose run app rake db:migrate
docker-compose run app rails db:migrate RAILS_ENV=test
```

## Run application

To run the application:

```bash
docker-compose up
```

The app server should be running on (http://127.0.0.1:7001)

## Rails Console

To enter Rails console, run the following:

```bash
docker ps
```
Get Container ID and replace it with containerID in the following command
```
docker exec -it containerID bash
rails c
```
To run rspec, run the following command in bash opened using the docker exec command mentioned above.
```
rspec
```
