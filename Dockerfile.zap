# Use an official OWASP ZAP base image
FROM owasp/zap2docker-stable

# Set environment variables for ZAP
ENV ZAP_PORT=8080

# Expose the ZAP port
EXPOSE ${ZAP_PORT}

# Set the default command to run ZAP in daemon mode
CMD ["zap.sh", "-daemon", "-port", "8080", "-host", "0.0.0.0"]
