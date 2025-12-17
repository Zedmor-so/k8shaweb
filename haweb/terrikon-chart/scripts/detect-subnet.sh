#!/bin/bash
NETWORK=$(ip -4 addr show | grep -oP 'inet \K[\d.]+/[0-9]+' | grep -v 127.0.0.1 | grep -v 10.244 | head -1 | cut -d/ -f1 | cut -d. -f1-3)
SUBNET="${NETWORK}.245-${NETWORK}.250"
echo "$SUBNET"