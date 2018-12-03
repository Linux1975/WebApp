### Deploy a web application
I have used AWS CodePipeline with AWS OpsWorks Stacks and Chef 11 Stacks , this will create one EC2 instance with AutoHealing enabled.
AWS CodePipeline lets you create continuous delivery pipelines that track code changes from sources such as AWS CodeCommit, Amazon Simple Storage Service (Amazon S3), or GitHub.
###Resources
I have used this walkthrough :
https://docs.aws.amazon.com/opsworks/latest/userguide/other-services-cp-chef12.html
The walkthrough creates a simple pipeline that includes one Source and one Deploy stage.
I have modified the recipes also I have used an S3 bucket where the developers can upload their code.
###Design and Implementation


###Alternatives

###Deployment Plan
#### 2. OpsWork instance
Navigate to the created [OpsWorks](https://console.aws.amazon.com/opsworks/) stack, under tab _Instances_ click `Add an instance.`. Select one of private subnets and proceed creating instance with pre-filled settings.
Under tab _Layers_ should display healthy status for Elastic Loadbalancer, as well clicking ELB url should show default Webapp index page.

=======


###Monitoring/Reporting/Alert





### 1. Structure of the Cookbook and Cloudformation

```
Webapp OpsWorks repository
│
│   readme.MD
│   cloudformation.json     Cloudformation deployment template for EC2 instance with Apache Webapp, OpsWorks + VPC resources
│
└---Webapp                  Chef Cookbook for provisioning Webapp stack
    └---recipes             Chef Recipes for provisiong an EC2 instance with Apache ,the blueprint of every instance created
    │                       
    └---templates           Templates for provisiong Apache    
    |
    └---files               Harcoded binary files


```
## Prerequisites
1. We use US
1. Required permission are attached to IAM role [aws-opsworks-ec2-role](https://console.aws.amazon.com/iam/home?region=eu-west-1#/roles/aws-opsworks-ec2-role) (SSM read access policy).  
1. EC2 key par is available
1. Both the SSH key to retrieve the Chef Cookbooks from Git, and the license key used for Unified are retrieved from EC2 parameter store, need to be present in EC2 parameter store (SSM):
```bash
aws ssm put-parameter --name "/opsworks/unified/license" --type String --region eu-west-1 --value "<unified-license>"
aws ssm put-parameter --name "/opsworks/access/key/git" --type String  --region eu-west-1 --value "<ssh PRIVATE key>"
```


### Deployment
