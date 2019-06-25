# README
[![Build Status](https://travis-ci.org/deosha/gogoair-demo.svg?branch=master)](https://travis-ci.org/deosha/gogoair-demo)

Solution Design:


* Node version: 10.x

* Infrastructure automation tool with version: Terraform 0.11.7 (Not tested with terraform 0.12 because changes in 0.12 are huge. Best runs with Terraform 0.11)

* Instruction to install correct version of Terraform:
wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
unzip terraform_0.11.7_linux_amd64.zip
sudo mv terraform /usr/bin
Check for user permissions and PATH env variable

* System dependencies: The deployment can be done from Windows/Linux/macos or by using any deployment tool like Jenkins but infrastructure is created on AWS

* Configuration: You need to configure AWS access keys and secret keys for terraform to read.

* How to run the test suite: NA

* Deployment instructions:
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
cd infrastructure_automation
terraform init -backend-config="bucket=state-files-gogoair" -backend-config="key=demo/infra.tfstate" -backend-config="region=us-west-2" -backend=true -force-copy -get=true -input=false
terraform apply -input=false --var env=${env} --var tag=${tag} -var-file=demo.tfvars -auto-approve
sleep 300

Notice the --var env=${env} and --var tag=${tag} flags in terraform apply command. Any docker tag can be deployed on any environment hence making it really flexible to deploy and rollback on any environment.
The docker tag can be decided during CI process in .travis.yml file. For now it is ${TRAVIS_BUILD_NUMBER}. To test, you can start with latest tag as it is already pushed.
Docker Tags are generally decided during branching and release strategy so CI code can be changed accordingly.

Then you can hit <ALB_DNS> on browser to open hello world nodejs app.

* Logging and Monitoring: Logs can be viewed in Cloudwatch logs after deployment.

* CI: .travis.yml is in repository. Jenkinsfile can also be used.

* Security: The instance(s) running the app is in private subnet. Only ALB has access to it via security groups on required ports.

* High Availaibility, Scalability and Fault Tolerance: Internet facing ALB is attached to AWS ECS service. The instances are in autoscaling group.

* Automation Level: Almost everything is automated. This code sets up Network which includes VPC, gateways(Internet and NAT), subnets,
route tables, route tables associates. The code automates everything related to ECS, Autoscaling Groups, Instances, Loadbalancers, Security Groups, IAM roles and policies etc.

* Maintainance Required: Not much. Obviously patching of the servers needs to be done and updates are required but system is highly avalaible and scalable.




