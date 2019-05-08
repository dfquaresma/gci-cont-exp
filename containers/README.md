# Useful commands

* Compilar e rodar: docker build -t openfaas-node-gci . && docker run --rm --name openfaas-node-gci openfaas-node-gci
* Descobrir IP: docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' openfaas-node-gci
* Matar o container: docker kill openfaas-node-gci
* Entrar no container rodando: docker exec -it  openfaas-node-gci  ash