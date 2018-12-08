### Deploy a web application:
We will create a Linux EC2 instance with Apache , we will also use a simple CI/CD stack with OpsWorks and CodePipeline.
Developers have to upload their code to an S3 bucket , if there are any changes those will trigger CodePipeline and deploy them
to the instance.

### Resources:

I have used this walkthrough , it creates a simple pipeline that includes one Source and one Deploy stage:
https://docs.aws.amazon.com/opsworks/latest/userguide/other-services-cp-chef12.html
other resources:

https://docs.aws.amazon.com/opsworks/latest/userguide/gettingstarted-intro.html
https://docs.aws.amazon.com/opsworks/latest/userguide/best-deploy.html
https://docs.aws.amazon.com/opsworks/latest/userguide/data-bag-json-app.html


### Design and Implementation:

I have decided to use AWS OpsWorks with Chef 12 and AWS CodePipeline.
The OpSWorks stack , deployed with CloudFormation , will create a Linux EC2 instance with AutoHealing enabled.
AWS CodePipeline lets you create continuous delivery pipelines that track code changes from sources such as AWS CodeCommit, Amazon Simple Storage Service (Amazon S3), or GitHub.
I have created new recipes to adapt them to the given code. As I have also commented out in the apache recipe I have decided to utilize
this web server that will serve the static html page , ( I have modified the httpd.conf in order to use CSS and Javascripts)
I will use the static code provided as a "blueprint" , so every time we spin up a new instance in OpsWorks ,the starting point will be that code.
I have also included the binary files example-webapp-linux and example-webapp-osx hardcoded in our cookbook , assuming that it will never change.
Besides I have decided to separate and use an S3 bucket where the developers can upload their new code and use this GitHub repository to deploy our recipes and Cloudformation JSON template.

### Alternatives

I thought for a demo and a simple application like this an EC2 instance would be enough instead of creating a Kubernete cluster ,besides with Opsworks and CodePipeline
we create a CI/CD stack.

### Deployment Plan

Please refer to this page for exhaustive instructions:
https://docs.aws.amazon.com/opsworks/latest/userguide/other-services-cp-chef12.html

How to deploy the whole stack:

```
Step 1: Create a stack, layer, and an instance in AWS OpsWorks Stacks:
Note: Clone this repository locally and upload the cloudformation script when we create the OpSWorks stack
Step 2: Configure your stack and layer to use custom cookbooks:
Note : For clarity use this git repository instead of an S3 archive , besides use apache_setup.rb and monit_setup.rb recipes for setup , instead deploy.rb for deployment.
Run the setup recipes in OpsWorks , Deployment -->Run Command --> Command select setup recipies: use apache_setup.rb and monit_setup.rb
Step 3: Upload app code to an Amazon S3 bucket
Note : you must create a bucket first
Step 4: Add your app to AWS OpsWorks Stacks
Note : use the bucket created previously
Step 5: Create a pipeline in AWS CodePipeline
Note : use the bucket created previously
Step 6: Verifying the app deployment in AWS OpsWorks Stacks
Step 7: Update the app code to see AWS CodePipeline redeploy your app automatically

```


### Monitoring/Reporting/Alert

In OpSWorks there is a monitoring section where we can check: CPU,Memory,Load and processes for Layers.
It is also possible to integrate Cloudwatch to check logs instance: we can check ,for instance , Apache error log ,access log etc.
I have also used monit for autohealing : this tool checks if Apache pid exists , if not it will restart it.
When there is a restart of Apache we will receive a Slack notification in a channel of our choice.
Note: Remember to configure the appropriate webhook URL in the slack.conf.erb template.

## Configuration:

In order to create this stack you must be an Administrator or being part of an administrator group.
So we can create an administrator group in IAM , then create a specific user in order to deploy the whole stack.

## Testing:

In order to not deploy a buggy code in production we should create a production and a test instance in  OpsWorks ,
we also need to create a test CodePipeline. We should also create a bucket for testing purpose and use it in Test environment.
If everything works fine in the test environment we can then apply our code in production.

### 1. Structure of the Cookbook and Cloudformation script

```
Webapp OpsWorks repository
│
│   readme.MD
│   cloudformation.json     Cloudformation deployment template for EC2 instance with Apache and OpsWorks
│
└---Webapp                  Chef Cookbook for provisioning Webapp stack
    └---recipes             Chef Recipes for provisiong an EC2 instance with Apache ,the blueprint of every instance created
    │                       
    └---templates           Templates for provisiong Apache    
    |
    └---files               Hardcoded binary files


```
## Prerequisites
1. IMPORTANT: The AWS CloudFormation template must be stored and run in the same region as the Amazon S3 bucket to which you later upload your code and the same region in which you later create your pipeline in AWS CodePipeline. At this time, AWS CodePipeline supports the AWS OpsWorks Stacks provider in the US East (N. Virginia) Region (us-east-1) only. All resources in this walkthrough should be created in the US East (N. Virginia) Region , in our example we use a t2.small instance.
1. Create EC2 key pair in the same region to access the instance.
1. Default root device type modified and use EBS backed instead of an ephemeral device.
