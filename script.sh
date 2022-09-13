#!/bin/bash
sudo useradd -m ansible --shell /bin/bash
sudo mkdir -p /home/ansible/.ssh
sudo chown -R ansible /home/ansible/
sudo touch /home/ansible/.ssh/authorized_keys
sudo usermod -aG root ansible
echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDFlDzbbFJXwYds+QkOTFpD8kPhol5sufmB4EYyk5Ag/ZUB5Vc/1PlCUuRI1hB3vNNlBlD22iQJ0FCMMnvWk4rqV/YHeV+7dDVWe9FbN1efY5jSlFo3YwRevyNFtNZeg/uWyfdFICfUr1xRORS1syqOIbp7lfng7fEHlRyKgvbOh8dLSrnrLlynfqkeA9YRnUgpfQhcFtvZ6RACpPnpxqNCa+XNYF6AFsEtyMxEBKHxEaW4icaCZ3x968L0NFKBJMXvfhOUp68tQtYubOVDukiYy4Y/BSxkLbxIpb3GSSnSdSYwTjdOwcp8K3S029/CNZ8GICoSymfUkuMbH5th5YGxWzAPgkA+UVKqX40lHNNp0PBjhoCkReGkgejP/cR44fAHeeRxOzw62+q6Z0kDFwuzlCBffqXNZzemcSyq3U+aXQ1Ws6zrqlSk9mlMF07gjkMoEbRABqXJivzC0UIZ8ssLW7rkZ3S2RqfXhwgb72YnLXtD6s4TYFbwoGknJTRC+4k=' | sudo tee /home/ansible/.ssh/authorized_keys
sudo apt update
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
curl https://get.docker.com | bash
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin 
kubectl version --short --client
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
eksctl create cluster --name k8scs \
   --region us-east-1 \
--node-type t2.small