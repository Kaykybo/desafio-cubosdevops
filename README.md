DESAFIO TÉCNICO – CUBOS DEVOPS

O ambiente é composto por 6 containers, cada um com uma função específica.

cubos-frontend
Serve o arquivo index.html
Realiza o proxy para a API no contexto /api
Acesso: http://<IP>

cubos-backend
Responsável por servir a API na porta 8080
Acesso apenas via proxy
Acesso: http://<IP>/api

cubos-db
Banco de dados PostgreSQL
Acesso restrito ao backend e ao PostgreSQL Exporter

postgresql-exporter
Coleta métricas do banco de dados
Não é acessível externamente

cubos-prometheus
Armazena e analisa as métricas coletadas pelo exporter
Pode ser acessado externamente
Acesso: http://<IP>:9090

cubos-grafana
Facilita a visualização e análise das métricas do Prometheus
Pode ser acessado externamente
Acesso: http://<IP>:3000

CREDENCIAIS DE ACESSO

Grafana
Usuário: admin
Senha: admin

*********DEPENDÊNCIAS**********

Docker
https://docs.docker.com/engine/install/

Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

Imagens necessárias para executar o terraform
cubos-frontend -- Tutorial abaixo
cubos-backend -- Tutorial abaixo
cubos-db -- Tutorial abaixo
cubos-prometheus -- Tutorial abaixo
cubos-grafana -- Tutorial abaixo
prometheuscommunity/postgres-exporter -- Terraform faz o pull automaticamente

*********BUILD DE IMAGENS **************

BUILD DAS IMAGENS DOCKER

Na raiz do projeto, execute os comandos abaixo para buildar as imagens necessárias:

docker build -t cubos-frontend:latest frontend/.
docker build -t cubos-backend:latest backend/.
docker build -t cubos-db:latest banco/.
docker build -t cubos-prometheus:latest monitoramento/prometheus/.
docker build -t cubos-grafana:latest monitoramento/grafana/.

***********DEPLOY DO AMBIENTE***********

PROVISIONAMENTO COM TERRAFORM

Após o build das imagens, entre na pasta "terraform" e execute:

terraform init
terraform apply -var-file="secrets.tfvars"

Observação:
É boa prática adicionar o arquivo secrets.tfvars ao .gitignore, pois contém informações sensíveis.
No entanto, como este é um projeto local e com limitações, é permitido commitar o arquivo junto.

ENDPOINTS DO AMBIENTE

Frontend: http://<IP>
Backend (via proxy): http://<IP>/api
Prometheus: http://<IP>:9090
Grafana: http://<IP>:3000