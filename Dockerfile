# Use an official lightweight base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /opt/web-exploitation-tools

# Update and install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    nikto \
    wget \
    curl \
    git \
    nvim \
    nmap \
    python3 \
    python3-pip \
    build-essential \
    default-jre \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a directory for documentation
RUN mkdir -p /opt/web-exploitation-tools/docs

# Copy documentation into the container
COPY ./docs /opt/web-exploitation-tools/docs/
COPY ./juice-shop-docs /opt/web-exploitation-tools/juice-shop-docs/

# Default command to run when the container starts
CMD ["/bin/bash", "-c"]


