#!/bin/sh

export PATH=$PATH:/opt/icloudpd/bin/

# Just to confirm it's working
echo "icloudpd path: $(which icloudpd)"
icloudpd --version

# Replace this with your real sync command
exec icloudpd \
  --username "$APPLE_ID" \
  --directory "/icloud" \
  --cookie-directory "/config" \
  --recent 100 \
  --log-level info
