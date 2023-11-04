# check-pd-change
Dynamic IPv6 delegated prefix change detector

The container is very simple: it checks every minute for a change of IPv6 prefix by comparing the prefix the one when the container started. The container also exposes a single metric, 'ipv6_prefix_changed'. The value is 1 when it detects a prefix change, and 0 otherwise. Prometheus alerting should do the rest.

Instructions:

1. Clone the repo to your machine.
2. Change the interface in check_prefix.sh to your LAN interface.
3. Change the address at the end of serve_metrics.py to the LAN address of the machine.
4. Run the container with host networking.
5. Configure Prometheus to scrape the metric and send an alert when it turns to 1.
