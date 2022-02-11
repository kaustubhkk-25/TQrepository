#! /bin/sh

sudo yum update -y

sudo amazon-linux-extras install docker

sudo yum install docker -y

sudo systemctl enable docker.service

sudo systemctl start docker.service

sudo systemctl status docker.service

sudo docker run hello-world
