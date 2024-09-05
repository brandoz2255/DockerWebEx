# Use an official lightweight base image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /opt/web-exploitation-tools

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    nikto \
    wget \
    curl \
    git \
    python3-pip \
    build-essential \
    # Install ffuf
    && apt-get install -y ffuf \
    # Clean up package lists
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install ffuf from its GitHub release 
RUN wget https://github.com/ffuf/ffuf/releases/download/v1.5.0/ffuf_1.5.0_linux_amd64.tar.gz \
    && tar xvfz ffuf_1.5.0_linux-amd64.tar.gz \
    && mv ffuf /usr/local/bin/ffuf

# Install OWASP ZAP
RUN wget https://github.com/zaproxy/zaproxy/releases/download/v2.13.0/ZAP_2_13_0_unix.sh \
    && chmod +x ZAP_2_13_0_unix.sh \
    && ./ZAP_2_13_0_unix.sh -q

# Install Burp Suite (Community Edition)
RUN wget https://portswigger.net/burp/releases/download?product=community&version=2023.7.1&type=Linux \
    -O burpsuite.sh \
    && chmod +x burpsuite.sh \
    && ./burpsuite.sh

# Create a directory for documentation
RUN mkdir -p /opt/web-exploitation-tools/docs

# Copy documentation into the container
COPY ./docs /opt/web-exploitation-tools/docs/

# Default command to run when the container starts
CMD ["/bin/bash"]

