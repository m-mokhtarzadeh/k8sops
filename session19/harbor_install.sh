#1:
openssl genrsa -out ca.key 4096

#2:
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=IR/ST=Tehran/L=Tehran/O=K8sinstitue/OU=IT/CN=mmokhtar.ir" \
 -key ca.key \
 -out ca.crt

#3:
openssl genrsa -out registry.mmokhtar.ir.key 4096

#4:
openssl req -sha512 -new \
    -subj "/C=IR/ST=Tehran/L=Tehran/O=K8sinstitue/OU=IT/CN=registry.mmokhtar.ir" \
    -key registry.mmokhtar.ir.key \
    -out registry.mmokhtar.ir.csr


#5:
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=registry.mmokhtar.ir
EOF


#6: 
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in registry.mmokhtar.ir.csr \
    -out registry.mmokhtar.ir.crt

#7:
wget https://github.com/goharbor/harbor/releases/download/v2.7.2/harbor-offline-installer-v2.7.2.tgz

#8: 
tar xvf harbor-offline-installer-v2.7.2.tgz -C /opt

#9:
cp /opt/harbor/harbor.yml.tmpl /opt/harbor/harbor.yml
configure: /opt/harbor/harbor.yml

#10:
docker load < harbor.v2.7.2.tar.gz

#11:
./prepare

#12:
./install.sh --with-trivy --with-chartmuseum