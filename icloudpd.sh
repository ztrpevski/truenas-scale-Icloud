#!/bin/sh


# Start icloudpd sync (example, add your actual user/params)
icloudpd \
    --directory "/home/user/iCloud" 

# Block so container doesn't exit immediately
tail -f /dev/null
