# Craftech test

## Agregar DNS
- windows: editar c:\windows\system32\drivers\etc\hosts.file

Agregar:
`127.0.0.1 craft_test.prueba` para desarrollo local
`[Ip aws] craft_test.prueba` para despliegue en aws

## Docker:

docker build -t bondiolino/craf_test:{servicio} ./{servicio}
docker push bondiolino/craf_test:{servicio}

## Local deploy:
docker compose up -d

