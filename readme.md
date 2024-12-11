# Craftech test

## Docker:

docker build -t bondiolino/craf_test:{servicio} ./{servicio}
docker push bondiolino/craf_test:{servicio}

## Local deploy:
docker compose up -d