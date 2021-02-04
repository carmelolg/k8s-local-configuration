#!/bin/bash

# build docker image
docker build -t springboot .;
docker run -it -d --restart=always -p 8082:8080 springboot;

# registry init
docker run -d -p 5000:5000 --restart=always --name registry registry:2;
docker tag springboot localhost:5000/springboot;
docker push localhost:5000/springboot;

# deployments
kubectl apply -f ./k8s-deployment.yaml;

# service
kubectl apply -f ./k8s-service.yaml;

# port-forward
kubectl port-forward deployment/springboot 8090:8080 &
