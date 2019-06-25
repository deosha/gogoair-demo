# README
[![Build Status](https://travis-ci.org/deosha/gogoair-demo.svg?branch=master)](https://travis-ci.org/deosha/gogoair-demo)

* Solution Design: Services Used: Internet facing ALB, ECS, Autoscaling Groups. EC2 instances are in private subnet.
Application is dockerized. S3 for storing Terraform state files. Logs are sent to Cloudwatch. Automation is done in Terraform v 0.11.7

* Node version: 10.x

* Infrastructure automation tool with version: Terraform 0.11.7 (Not tested with terraform 0.12 because changes in 0.12 are huge. Best runs with Terraform 0.11)

* Instruction to install correct version of Terraform: <br><br>
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip <br>
unzip terraform_0.11.7_linux_amd64.zip <br>
sudo mv terraform /usr/bin <br>
Check for user permissions and PATH env variable

* System dependencies: The deployment can be done from Windows/Linux/macos or by using any deployment tool like Jenkins but infrastructure is created on AWS

* Configuration: You need to configure AWS access keys and secret keys for terraform to read. you should have a key named "demo" in your key pair. If you want to change it, you can do so by changing the value of key_pair_name variable in demo.tfvars

* How to run the test suite: NA

* Deployment instructions:
you should have a key named "demo" in your key pair. If you want to change it, you can do so by changing the value of key_pair_name variable in demo.tfvars <br><br>
export AWS_ACCESS_KEY_ID="" <br>
export AWS_SECRET_ACCESS_KEY="" <br>
cd infrastructure_automation <br>
terraform init -backend-config="bucket=state-files-gogoair" -backend-config="key=demo/infra.tfstate" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input=false <br><br>
terraform apply -input=false --var env=stage --var tag=latest -var-file=demo.tfvars -auto-approve && sleep 120

sleep is added to make sure that target groups are healthy. If they are not healthy, wait for them to be healthy. Deregistration delay is 5 mins.

You can create your own bucket and change configurations accoridngly in main.tf and terraform init commands. Region is us-west-2 which you can change,


Notice the --var env=stage and --var tag=latest flags in terraform apply command. Any docker tag can be deployed on any environment hence making it really flexible to deploy and rollback on any environment.
The docker tag can be decided during CI process in .travis.yml file. For now it is ${TRAVIS_BUILD_NUMBER}. To test, you can start with latest tag as it is already pushed.
Docker Tags are generally decided during branching and release strategy so CI code can be changed accordingly. you can change value of env to deploy any docker tag on any env.

Then you can hit <ALB_DNS> on browser to open hello world nodejs app.

* Logging and Monitoring: Logs can be viewed in Cloudwatch logs after deployment.

* CI: .travis.yml is in repository. Jenkinsfile can also be used.

* Security: The instance(s) running the app is in private subnet. Only ALB has access to it via security groups on required ports.

* High Availaibility, Scalability and Fault Tolerance: Internet facing ALB is attached to AWS ECS service. The instances are in autoscaling group.

* Automation Level: Almost everything is automated. This code sets up Network which includes VPC, gateways(Internet and NAT), subnets,
route tables, route tables associates. The code automates everything related to ECS, Autoscaling Groups, Instances, Loadbalancers, Security Groups, IAM roles and policies etc.

* Maintainance Required: Not much. Obviously patching of the servers needs to be done and updates are required but system is highly avalaible and scalable.

To DO:
1. Failed Deployment notification can be implemeented in Jenkins as post build step.
2. Cloudwatch Monitoring, SNS notifications to be implemented.


