FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3-pip \
    build-essential \
    default-jre \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Java
RUN wget --no-check-certificate -O jdk-8u211-linux-x64.tar.gz https://download.oracle.com/tech-network/java/javase/8u211-later/jdk-8u211-linux-x64.tar.gz \
    && tar xzvf jdk-8u211-linux-x64.tar.gz -C /usr/local \
    && mv /usr/local/jdk1.8.0_211 /usr/local/jdk \
    && rm jdk-8u211-linux-x64.tar.gz

# Install ZAP
RUN wget -O zap.sh https://raw.githubusercontent.com/zaproxy/zaproxy-community/master/docker/zap.sh \
    && chmod +x zap.sh \
    && /usr/local/jdk/bin/java -jar /zap.sh -install

# Set the working directory
WORKDIR /opt/zap

# Copy ZAP configuration
COPY zap.conf /opt/zap/conf/zap.conf

# Default command to run when the container starts
CMD ["/usr/local/jdk/bin/java", "-jar", "/zap.sh", "-daemon", "-host", "0.0.0.0", "-port", "8080", "-config", "api.addrs.addr.name=.*", "-config", "api.addrs.addr.regex=true"]

