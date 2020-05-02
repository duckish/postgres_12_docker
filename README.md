# postgres_12_docker

git clone https://github.com/duckish/postgres_12_docker.git

cd postgres_12_docker

docker-compose up --build

docker exec -it $ID /bin/bash

python3 /code/insert_first_data.py
