### Flow :

### Git --> Git-Hub --> Maven build --> copy Jar to S3 bucket --> Build Docker Image --> Push that image to AWS-ECR --> Pull that Image from ECR using Ansible Playbook and deploy to Staging K8S Cluster--> Send Slack Notification about Build-Status

### Tools Used : Git,Git-Hub,Maven ,Docker,Ansible, Slack . AWS Servives - EC2, IAM Roles, AWS ECR , AWS S3, K8S

1) Install Java, unzip , maven , docker, ansible, aws-cli, jenkins nad setup all tools
#!/bin/bash
sudo apt update
sudo apt install -y unzip openjdk-11-jdk
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
sed -i 's/;host_key_checking=True/host_key_checking=False/g' /etc/ansible/ansible.cfg
curl https://get.docker.com | bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
cd /opt
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar xzvf apache-maven-3.8.6-bin.tar.gz
usermod -aG docker jenkins
sudo systemctl daemon-reload
sudo systemctl restart docker
service jenkins restart

java --version && ansible --version && docker version && aws --version && maven --version

# Plugins to Install
---> Global tool Configuration--> Maven --> /opt/apache-maven-3.8.6
1) Ansible
2) Docker Pipeline
3) AWS Steps
4) Slack Notifications
Configure System --> Slack--> Workspace (JavaProjects)-->Add Creds as secret text(token)-->Channel(#java-projects) --> Enable Custom slack app bot user


1) Take Java code and try to build with maven code . It will build jar file
2) Copy Jar file to S3 bucket
3) Write Docker file to start a container and run jar file
4) push docker image to AWS ECR
5) Create another server (with docker and aws-cli installed on it and role assigned) and establish connection between two servers with ansible
#!/bin/bash
sudo useradd -m ansible --shell /bin/bash
sudo mkdir -p /home/ansible/.ssh
sudo chown -R ansible /home/ansible/
sudo touch /home/ansible/.ssh/authorized_keys
sudo usermod -aG root ansible
echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo '<Pub-Key>' | sudo tee /home/ansible/.ssh/authorized_keys
sudo apt update
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
curl https://get.docker.com | bash

6) pull docker image from ECR and deploy on new server with help of ansible (create ansible user and keep private key in jenkins as ansible credential ID to login)

Note : Refer-Jenkins file and Playbook for reference
ansiblePlaybook become: true, credentialsId: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'
## access app with below URL :

http://44.197.226.91:8080/webapp/

## K8S Cluster Installation:

Before this Install AWS-CLI and setup ansible connection with master server where we install kubectl and eksctl and attach IAM Role 

1) Install Kubectl

curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin 
kubectl version --short --client


2) Install eksctl

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

3) Create Cluster with below :

eksctl create cluster --name k8scs \
   --region us-east-1 \
--node-type t2.small

4) Validate your cluster using by creating by checking nodes and by creating a pod

kubectl get nodes
kubectl run nginx --image=nginx

## Deploying Nginx pods on Kubernetes

kubectl create deployment  demo-nginx --image=nginx --replicas=2 --port=80
kubectl get all
kubectl get pod

## Expose the deployment as service. This will create an ELB in front of those 2 containers and allow us to publicly access them.

kubectl expose deployment demo-nginx --port=80 --type=LoadBalancer
kubectl get services -o wide

# Delete the clusuer after all work done

eksctl delete cluster k8scs --region us-east-1