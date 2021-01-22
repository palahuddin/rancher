
#!/bin/bash

apt-get remove docker docker-engine docker.io docker-ce docker-ce-cli containerd runc -y
apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y

wget https://download.docker.com/linux/ubuntu/gpg
apt-key add gpg


add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" -y


apt-get update -y
apt-get install -y docker-ce=5:19.03.14~3-0~ubuntu-bionic docker-ce-cli=5:19.03.14~3-0~ubuntu-bionic containerd.io

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && mv kubectl /usr/bin/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh && ./get_helm.sh
wget https://github.com/rancher/rke/releases/download/v1.2.4/rke_linux-amd64 && chmod +x rke_linux-amd64 && mv rke_linux-amd64 /usr/bin/rke
