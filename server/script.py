import os
import subprocess
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.backends import default_backend
import OpenSSL

def generate_ssl_cert():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )

    cert = OpenSSL.crypto.X509()
    cert.get_subject().countryName = "US"
    cert.get_subject().stateOrProvinceName = "California"
    cert.get_subject().localityName = "San Francisco"
    cert.get_subject().organizationName = "Example Corp"
    cert.get_subject().commonName = "example.com"
    cert.set_serial_number(int(time.time()))
    cert.gencrl()
    cert.not_valid_after = datetime.utcnow() + timedelta(days=365)
    cert.not_valid_before = datetime.utcnow()

    cert.add_extensions([
        OpenSSL.crypto.X509Extension(b"subjectAltName", b"@alt_names"),
    ])
    cert.add_extension(OpenSSL.crypto.X509Extension(b"authorityKeyIdentifier", b"@authority_key_id"))

    cert.sign(private_key, "sha256")

    pem = OpenSSL.crypto.dump_certificate(OpenSSL.crypto.FILETYPE_PEM, cert)
    pem += "\n" + OpenSSL.crypto.dump_privatekey(OpenSSL.crypto.FILETYPE_PEM, private_key)

    return pem

# Generate SSL certificate
cert_pem = generate_ssl_cert()
with open("cert.pem", "w") as f:
    f.write(cert_pem)


def create_nginx_config():
    config = """
server {
    listen 443 ssl http2;
    server_name example.com www.example.com;

    ssl_certificate /etc/nginx/cert.pem;
    ssl_certificate_key /etc/nginx/key.pem;

    root /var/www/html;
    index index.html index.htm index.php;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
    add_header Referrer-Policy "strict-origin-nowrap";
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';";

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=one:10m rate=1r/m;

    location = /login {
        limit_req zone=one burst=5;
    }

    location / {
        try_files $uri $uri/ =404;
    }
}

server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$server_name$request_uri;
}
"""
    with open("nginx.conf", "w") as f:
        f.write(config)

create_nginx_config()

def create_dockerfile():
    dockerfile_content = """
FROM nginx:alpine

RUN apk add --no-cache ca-certificates

COPY cert.pem /etc/nginx/cert.pem
COPY key.pem /etc/nginx/key.pem
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 443 80

CMD ["nginx", "-g", "daemon off;"]
"""
    with open("Dockerfile", "w") as f:
        f.write(dockerfile_content)

create_dockerfile()



def build_and_run_container():
    print("Building Docker image...")
    subprocess.run(["docker", "build", "-t", "my-nginx-server", "."], check=True)

    print("Running Docker container...")
    subprocess.run(["docker", "run", "--name", "my-nginx-server-container", "-p", "443:443", "-p", "80:80", "my-nginx-server"], check=True)

    print("Container started successfully!")

build_and_run_container()



# Main execution
generate_ssl_cert()
create_nginx_config()
create_dockerfile()

print("Setup completed!")
print("To run the server:")
print("1. Build the Docker image:")
print("   docker build -t my-nginx-server .")
print("2. Run the container:")
print("   docker run --name my-nginx-server-container -p 443:443 -p 80:80 my-nginx-server")


