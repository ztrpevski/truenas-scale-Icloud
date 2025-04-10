# Use the official icloudpd image as base
FROM boredazfcuk/icloudpd:latest

# Optionally copy custom entrypoint or scripts
COPY icloudpd.sh /icloudpd.sh
RUN chmod +x /icloudpd.sh

# Optional: Set environment variables (or override via TrueNAS GUI)
ENV TZ="UTC"

# Expose ports if needed (icloudpd usually doesn't need any)
# EXPOSE 8080

# Define entrypoint
ENTRYPOINT ["/icloudpd.sh"]
