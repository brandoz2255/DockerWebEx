#!/bin/bash

# Start ZAP
docker-compose up -d zap

# Wait for ZAP to be ready
sleep 30

# Start Juice Shop
docker-compose up -d juiceshop

# Start FFUF
docker-compose up -d ffuf

# Start web tools
docker-compose up -d web-tools

echo "ZAP, Juice Shop, FFUF, and web exploitation tools are running!"

