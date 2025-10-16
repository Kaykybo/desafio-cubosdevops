# Desafio Técnico – Cubos DevOps

Este projeto consiste em um ambiente Docker orquestrado via Terraform, com 6 containers, cada um com uma função específica.

---

## Containers

| Container               | Função                                                                     | Acesso           |
| ----------------------- | -------------------------------------------------------------------------- | ---------------- |
| **cubos-frontend**      | Serve o arquivo `index.html` e realiza proxy para a API no contexto `/api` | http://<IP>      |
| **cubos-backend**       | Serve a API na porta 8080. Acesso apenas via proxy                         | http://<IP>/api  |
| **cubos-db**            | Banco de dados PostgreSQL. Acesso restrito ao backend e exporter           | Restrito         |
| **postgresql-exporter** | Coleta métricas do banco de dados. Não acessível externamente              | -                |
| **cubos-prometheus**    | Armazena e analisa métricas coletadas pelo exporter                        | http://<IP>:9090 |
| **cubos-grafana**       | Facilita a visualização e análise das métricas do Prometheus               | http://<IP>:3000 |

---

## Credenciais de Acesso

**Grafana**

* Usuário: `admin`
* Senha: `admin`

---

## Dependências

* **Docker**: [Instalação](https://docs.docker.com/engine/install/)
* **Terraform**: [Instalação](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

As imagens necessárias serão criadas localmente via Docker. O Terraform faz pull automático apenas do `prometheuscommunity/postgres-exporter`.

---

## Build das Imagens Docker

Na raiz do projeto, execute os comandos abaixo:

```bash
docker build -t cubos-frontend:latest frontend/
docker build -t cubos-backend:latest backend/
docker build -t cubos-db:latest banco/
docker build -t cubos-prometheus:latest monitoramento/prometheus/
docker build -t cubos-grafana:latest monitoramento/grafana/
```

---

## Deploy do Ambiente (Terraform)

Após o build das imagens, entre na pasta `terraform` e execute:

```bash
terraform init
terraform apply -var-file="secrets.tfvars"
```

> Observação: É recomendado adicionar o arquivo `secrets.tfvars` ao `.gitignore`, pois contém informações sensíveis. Porém, neste projeto local, é permitido commitar o arquivo.

---

## Endpoints do Ambiente

* **Frontend**: http://<IP>
* **Backend (via proxy)**: http://<IP>/api
* **Prometheus**: http://<IP>:9090
* **Grafana**: http://<IP>:3000

---

## Observações

* Todos os containers são interligados via Docker Network definida no Terraform.
* O backend só é acessível via proxy do frontend.
* Métricas do PostgreSQL são coletadas pelo `postgresql-exporter` e enviadas para o Prometheus.
