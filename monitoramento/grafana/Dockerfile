FROM grafana/grafana
COPY prometheus.yml /etc/grafana/provisioning/datasources/
COPY dashboards.yml /etc/grafana/provisioning/dashboards/
COPY grafana-prometheus.json /var/lib/grafana/dashboards/
EXPOSE 3000