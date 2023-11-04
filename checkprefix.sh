#!/bin/bash
# checkprefix.sh

INTERFACE="br0"
METRICS_FILE="/tmp/metrics.txt"
PREFIX_FILE="/tmp/prefix.txt"

if [ ! -s "$PREFIX_FILE" ]; then
    CURRENT_IPV6_ADDRESS=$(ip -6 addr show dev $INTERFACE scope global | awk '/inet6/{print $2}')
    CURRENT_PREFIX=$(echo $CURRENT_IPV6_ADDRESS | awk -F':' '{print $1 ":" $2 ":" $3 ":" $4}')
    echo "$CURRENT_PREFIX" > "$PREFIX_FILE"
    echo "ipv6_prefix_changed 0" > "$METRICS_FILE"
    echo "IPv6 Prefix Set: $CURRENT_PREFIX"
else
    PREVIOUS_PREFIX=$(cat "$PREFIX_FILE")
    CURRENT_IPV6_ADDRESS=$(ip -6 addr show dev $INTERFACE scope global | awk '/inet6/{print $2}')
    CURRENT_PREFIX=$(echo $CURRENT_IPV6_ADDRESS | awk -F':' '{print $1 ":" $2 ":" $3 ":" $4}')
    if [ "$CURRENT_PREFIX" != "$PREVIOUS_PREFIX" ]; then
        echo "$CURRENT_PREFIX" > "$PREFIX_FILE"
        echo "ipv6_prefix_changed 1" > "$METRICS_FILE"
        echo "IPv6 Prefix Changed: $CURRENT_PREFIX"
    else
        echo "ipv6_prefix_changed 0" > "$METRICS_FILE"
    fi
fi
