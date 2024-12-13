# Craftech test

## Agregar DNS
- windows: editar c:\windows\system32\drivers\etc\hosts.file

Agregar:
`127.0.0.1 craft_test.prueba` para desarrollo local
`[Ip aws] craft_test.prueba` para despliegue en aws, el mismo se ve en el output del ultimo paso del actions 

## Docker:
```bash
#Build nginx
docker build -t bondiolino/craf_test:nginx ./nginx
#Build backend
docker build -t bondiolino/craf_test:backend ./backend
#Build frontend
docker build -t bondiolino/craf_test:frontend ./frontend
```

## Local deploy:
```bash
#Deploy front, api y DB
docker compose up -d 
#Deploy nginx
docker run -dp 80:80 bondiolino/craf_test:nginx
```

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


## Actividad 3:
Actualizacion de index de nginx mediante pipeline.
### Validacion Cloud:
Al actualizar el `nginx/index.html` y pushear, se corre `.github/workflows/build-push-nginx.yml` y arma nuevamente la imagen en github.

Podemos actualizar de 3 formas el index:
1) Correr action `Deploy to AWS EC2 with Terraform and Compose` y que se despliegue nuevamente
2) Conectarse mediante SSH al servidor y correr el script `/home/ubuntu/deploy_ngx.sh` que se crea mediante `deploy.sh`.
3) Correr action `Update nginx via ssh`