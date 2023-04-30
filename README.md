# jenkins-eks-springboot-app
This repo is to deploy springboot application onto EKS using Jenkins

Please refer to the blog for reference :  https://myselfehtesham.hashnode.dev/deploying-application-using-jenkins-on-eks-elastic-kubernetes-service

1. First, Configure the Jenkins Server by creating an ec2-instance with the below details:

**Instance_type** : t2.medium

**OS image (AMI)** : Ubuntu 18    ( its your choice regarding version ) 

Add the script from script inside this repo (jenkins-install.sh) to configure Jenkins Server in user data section:

Once the server is up, Connect to the server and fetch the Jenkins password from /var/lib/jenkins/secrets/initialAdminPassword.

Connect to the Jenkins URL at http://SERVER-URL:8080 and provide the password fetched.

**Note** : If the URL is not loading on the browser, check the inbound rules for the jenkins server instance and allow the port 8080, and try it.

Once the password is provided, Install the suggested plugins, and Create an user for jenkins and save. Relogin with the user again.

We also need the below installations on Jenkins Server.

a. Install awscli  

Steps for reference from AWS Documentation : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html  or execute the below steps 

=====

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

unzip awscliv2.zip  ( Install unzip first, using command "apt install unzip -y" ) 

sudo ./aws/install

sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update


======


b. Install docker on Jenkins (it would be useful to build docker images and push to docker registry) .. Reference : https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository



During EKS Cluster creation, if kubectl is not installed, Use this link to install kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

Once kubectl is installed, verify using simple command - kubectl version 

If you are seeing the below error while listing nodes or pods with kubectl , it is due to executable aws-iam-authenticator not installed.

======
 
E0429 06:37:59.903564   10517 memcache.go:265] couldn't get current server API group list: Get "https://59A06120BB5AB9F51B0C41CB03097099.gr7.us-west-2.eks.amazonaws.com/api?timeout=32s": getting credentials: exec: executable aws-iam-authenticator not found
 
======

 follow the below steps to install the aws-iam-authenticator binary.

Steps: 
===============
 
curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64

chmod +x ./aws-iam-authenticator

mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$PATH:$HOME/bin

echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
 
=================


Run the kubectl get nodes / kubectl get pods commands to verify if it is working now !!!!

## CREATE EKS CLUSTER 

**Pre-requisite** : We need eksctl to be installed for cluster provision using command line tool.

Use this link https://github.com/weaveworks/eksctl/blob/main/README.md#for-unix to install eksctl on Linux Servers ( In our case, we are using Ubuntu server ) 

2. Create eks cluster with the below command from Jenkins server as we have installed aws cli earlier. 

========

eksctl create cluster --name my-eks-cluster --version 1.22 --region us-west-2 --nodegroup-name linux-group --node-type t3.small --managed  --nodes 2

### [Ensure the version is valid one, as newer versions come, older gets deprecated]

=========

Note : If the kubectl is not getting installed during cluster creation, follow the steps for kubectl creation as mentioned in path - https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/

 In releases older than Debian 12 and Ubuntu 22.04, **/etc/apt/keyrings** does not exist by default. You can create this directory if you need to, making it world-readable but writeable only by admins.  Link --> https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management

==========

3. Next, we will go back to Jenkins setup to complete the authentication to EKS Cluster. 

Copy the contents of the /root/.kube/config to /var/lib/jenkins/.kube/config  

4. To authenticate through jenkins build jobs, upload the same file as secret credentials in manage credentials

Steps: 

Manage Jenkins > Credentials > System > Global Credentials > Add Credentials 

Next, Use the credentials added to the Job configured below, and other configuration details as below.

Build Environment > Configure Kubernetes CLI > Credentials (add file)

Add the Server endpoint of the cluster  [ Fetch the cluster endpoint from cluster overview section ] 
name of the cluster [ provide the name of cluster provided during cluster creation ]

===========

Finally test if we are able to communicate with kubernetes cluster from Jenkins by adding a simple command similar as below in "Execute script" option under Build Environment. 

We should see a Build Success Output !!! 



