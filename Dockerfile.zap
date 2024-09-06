FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3-pip \
    build-essential \
    openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ZAP (Zed Attack Proxy)
RUN wget -O zap.sh https://raw.githubusercontent.com/zaproxy/zaproxy-community/master/docker/zap.sh \
    && chmod +x zap.sh \
    && ./zap.sh -install

# Set the working directory
WORKDIR /opt/zap

# Copy ZAP configuration
COPY zap.conf /opt/zap/conf/zap.conf

# Default command to run ZAP
CMD ["sh", "/zap.sh", "-daemon", "-host", "0.0.0.0", "-port", "8080", "-config", "api.addrs.addr.name=.*", "-config", "api.addrs.addr.regex=true"]

