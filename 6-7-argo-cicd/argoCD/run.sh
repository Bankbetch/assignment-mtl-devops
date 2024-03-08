k create secret docker-registry dockerhub-secret \
    --docker-server=\$DOCKER_REGISTRY_SERVER \
    --docker-username=\$DOCKER_USER \
    --docker-password=\$DOCKER_PASSWOR \
    --docker-email=\$DOCKER_EMAIL \
    -n=api

k apply -f api-dev.yaml