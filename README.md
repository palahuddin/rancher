##INSTALL RANCHER Kubernetes Engine

- prepare infrastucure vm
1. nginx-proxy
2. rke master
3. rke nodes (recomendation 3 nodes)

- makesure ssh connetion already authentication from rke master to all nodes vm

## INSTALL NGINX
###NGINX PROXY SERVER
- ssh to nginx-proxy server
apt install nginx -y

- install snap & certbot
apt install snap -y
snap install core; sudo snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

- generate free ssl certificate
certbot --nginx -d rke.example.com -d rke.example.com


- add config nginx stream and proxy pass to conf.d
cat lb-rancher.conf > /etc/nginx/conf.d/lb-rancher.conf
cat rke.example.com.conf > /etc/nginx/conf.d/rke.example.com.conf
systemctl start nginx

## INSTALL RKE
###RKE MASTER SERVER + NODES SERVER
- install docker, rke, kubectl, helm to RKE Master Server and others cluster nodes
./install-rke.sh

###RKE MASTER SERVER
- create cluster.yml file on rke master
rke config --name cluster.yml
#setup as requirement minimal 3 node

- running rke script
rke up

- export configuration rke config, 
export KUBECONFIG=kube_config_cluster.yml


##INSTALL RANCHER 2.x
###RKE MASTER SERVER
- deploy cert-manager to rke cluster
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.0.4/cert-manager.crds.yaml
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.4
kubectl get pods --namespace cert-manager


- deploy rancher UI
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl create namespace cattle-system
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rke.example.com
kubectl -n cattle-system rollout status deploy/rancher

- Done




