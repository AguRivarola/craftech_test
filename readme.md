# Craftech test

## Agregar DNS
- windows: editar c:\windows\system32\drivers\etc\hosts.file

Agregar:
`127.0.0.1 craft_test.prueba` para desarrollo local
`[Ip aws] craft_test.prueba` para despliegue en aws, el mismo se ve en el output del ultimo paso del actions 

## Docker:

docker build -t bondiolino/craf_test:{servicio} ./{servicio}
docker push bondiolino/craf_test:{servicio}

## Local deploy:
docker compose up -d

## Aws deploy:

1) Correr action `Deploy to AWS EC2 with Terraform and Compose` y esperar a que llegue al paso `Get EC2 instance IP`.
2) Mientras se levanta la infra, agrega en el archivo host la ip del paso anterior y guarda los cambios.
3) Deberiamos esperar unos minutos y ya podriamos validar.

## Validacion 
- Front:
http://crafttest.prueba:3000/
- Back:
http://crafttest.prueba:8000/
- Nginx: 
http://crafttest.prueba

