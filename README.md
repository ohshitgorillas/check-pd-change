# check-pd-change
Dynamic IPv6 delegated prefix change detector

The container is very simple: it checks every minute for a change of IPv6 prefix by comparing the prefix the one when the container started. The container also exposes a single metric, 'ipv6_prefix_changed'. The value is 1 when it detects a prefix change, and 0 otherwise. Prometheus alerting should do the rest.

Instructions:

1. Clone the repo to your machine.
2. Change the interface in check_prefix.sh to your LAN interface.
3. Change the address and port (optional) in serve_metrics.py.
4. Run the container with host networking.
5. Configure Prometheus to scrape the metric and send an alert when it turns to 1.

Example alertmanager and prometheus configurations:

alertmanager/alertmanager.yml
```
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  group_wait: 1s
  group_interval: 2m
  repeat_interval: 5m
  receiver: 'slack'

receivers:
- name: 'slack'
  slack_configs:
  - api_url: 'https://hooks.slack.com/services/yourwebhookurlhere'
```
prometheus/alerts.yml
```
groups:
- name: prefix-change
  rules:
  - alert: IPv6PrefixChange
    expr: ipv6_prefix_changed == 1
    labels:
      severity: critical
    annotations:
      summary: "IPv6 Prefix has changed"
      description: "IPv6 prefix change detected"
```
prometheus/prometheus.yml
```
global:
  scrape_interval: 10s  # Scrape targets every 10 seconds
  scrape_timeout: 5s
  evaluation_interval: 1m

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']

...

  - job_name: 'checkpd'
    static_configs:
      - targets: ['10.0.0.1:9101']

rule_files:
  - '/etc/prometheus/alerts.yml'

alerting:
  alertmanagers:
    - static_configs:
      - targets: ['alertmanager:9093']

```
