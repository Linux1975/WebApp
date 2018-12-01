### Webapp - Webapp template
Cloudformation template to provision OpsWorks stack and VPC resources for Webapp.

### 1. Structure

```
Webapp OpsWorks repository
│
│   readme.MD
│   cloudformation.json     Cloudformation deployment template for Webapp, OpsWorks + VPC resources
│
└---Webapp                  Chef Cookbook for provisioning Webapp stack
    └---recipes             Chef Recipes for provisiong an EC2 instance Apache
    │                       
    └---templates           Templates for provisiong Apache    



```



### Deployment

#### 2. OpsWork instance
Navigate to the created [OpsWorks](https://console.aws.amazon.com/opsworks/) stack, under tab _Instances_ click `Add an instance.`. Select one of private subnets and proceed creating instance with pre-filled settings.
Under tab _Layers_ should display healthy status for Elastic Loadbalancer, as well clicking ELB url should show default Webapp index page.
<<<<<<< HEAD
=======

>>>>>>> 75daed240277ddea63bdd86e2e7a5d29298c31eb
