# check-pd-change
Dynamic IPv6 delegated prefix change detector

The container is very simple: it checks every minute for a change of IPv6 prefix by comparing the prefix the one when the container started. The container also exposes a single metric, 'ipv6_prefix_changed'. The value is 1 when it detects a prefix change, and 0 otherwise. Prometheus alerting should do the rest.
