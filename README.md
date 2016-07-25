Dockerize Apache 2.4.7 and PHP 5.6

1. To create a volume
docker create -v /var/www/site:/var/www/site --name app_data ubuntu:14.04.4
2. To run application container with volume and mysql container (change port 80 to 8080 if you already have something running.docker run -p 80:80 --name app_container --link mysql_container:mysql -d ymnoor21/ap:v2

