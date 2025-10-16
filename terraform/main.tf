terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "rede_externa" {
  name = "rede_externa"
}

resource "docker_network" "rede_interna" {
  name = "rede_interna"
}

resource "docker_network" "rede_db" {
  name = "rede_db"
}

resource "docker_network" "rede_monitoramento" {
  name = "rede_monitoramento"

}
resource "docker_volume" "db_data" {
  name = "db_data"
}

resource "docker_container" "db" {
  image = "cubos-db:latest"
  name  = "db"
  networks_advanced { 
    name = docker_network.rede_db.name
}
  env = [
    "POSTGRES_PASSWORD=${var.db_password}"
  ]
  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.db_data.name
    type   = "volume"
  }
  restart = "always"
}


resource "docker_container" "backend" {
  image = "cubos-backend:latest"
  name  = "backend"
  networks_advanced { 
    name = docker_network.rede_interna.name
}
  networks_advanced { 
    name = docker_network.rede_db.name
}
  env = [
    "user=postgres",
    "pass=${var.db_password}",
    "host=db",
    "db_port=5432",
    "port=8080"
  ]
  depends_on = [
    docker_container.db
  ]
  restart = "always"
}

resource "docker_container" "frontend" {
  image = "cubos-frontend:latest"
  name  = "frontend"
  networks_advanced { 
    name = docker_network.rede_interna.name
}
  networks_advanced { 
    name = docker_network.rede_externa.name
}
  ports {
    internal = "80"
    external = "80"
  }
  depends_on = [
    docker_container.backend
  ]
  restart = "always"
}


resource "docker_container" "prometheus" {
  image = "cubos-prometheus:latest"
  name  = "prometheus"
  networks_advanced { 
    name = docker_network.rede_monitoramento.name
}
  networks_advanced { 
    name = docker_network.rede_externa.name
}
  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus"
  ]
  ports {
    internal = "9090"
    external = "9090"
  }
  restart = "always"
}

resource "docker_container" "postgresql-exporter" {
  image = "prometheuscommunity/postgres-exporter"
  name  = "postgresql-exporter"
  networks_advanced { 
    name = docker_network.rede_monitoramento.name
}
  networks_advanced { 
    name = docker_network.rede_db.name
}
  env = [
    "DATA_SOURCE_NAME=postgresql://postgres:${var.db_password}@db:5432/postgres?sslmode=disable"
  ]
    depends_on = [
    docker_container.db
  ]
  restart = "always"
}

resource "docker_container" "grafana" {
  image = "cubos-grafana:latest"
  name  = "grafana"
  networks_advanced { 
    name = docker_network.rede_monitoramento.name
}
  networks_advanced { 
    name = docker_network.rede_externa.name
}
  ports {
    internal = "3000"
    external = "3000"
  }
  restart = "always"
  }