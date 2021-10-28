# Terraform template - creating a web server with auto scaling and load balancing on AWS

This is part of my initial learning on how to use Terraform with AWS and specifically, how it compares with Cloudformation in similar tasks.

## The goal

The goal of this template was to be able to create in the Paris region all of the resources necessary to be able to create a highly available web server using one of my pre-configured AMI's set as part of an auto scaling group behind an application load balancer to operate as a basic start page to my most commonly used web pages.

## Resources vs Modules

This template uses a mixture of resources and modules. When doing my initial research of the resources on Terraform I wound up on the Terraform registry, which I noted allowed for a much more compact and easier running of resources like the basic networking infrastructure in terms of creating the VPC, along with the basic subnets, IGW, route tables etc. 

For items such as the load balancer and the Autoscaling group I kept with using the basic resources as opposed to the modules as it felt similar to how the modules worked but felt easier to build on and learn from the documentation.

## Security Groups

The security group actually proved a bit of an unknown challenge. In my first running of the template I initially did not include any egress rules, just ingress. This was due to my experience with the AWS console where the default position with the outbound rules is to automatically allow outbound traffic, however with Terraform this is not the case. This led to a fault once the Terraform stack was created that the instances would be created under the ASG and you could connect to the web servers under the individual instances' public IP address, however it would fail all of the ELB health checks due to a time out.

Initially I played around with the health check settings to increase the interval etc. but to no aveil. I then realised that if I could connect to the instance directly, but the target group was not receiving any updates from said instances, then it must be due to something happening in the middle. I then checked the security group to make sure that the EC2 instances were allowed to send a response and found that the egress rules were empty. Upon adding the egress rule on the security group template the target group sprung into life and everything worked from that point onwards!

## Getting to grips with the syntax

Coming from no experience with Terraform and only basic experience with JSON and YAML, after following the initial tutorials available on the Terraform webpage, I feel like I understood the basic syntax pretty quickly.

Where I struggled initially was with the VPC module that I used, in that it isn't immediately clear with no experience what exactly was created as we're not explicitly declaring it in the code. This caused a bit of a learning curve due to my issues above where my research took me to the registry perhaps earlier than expected in my Terraform journey.

On the whole though the resource syntax was very easy to understand and the guides online were very useful in helping me understand what needs to be included and why.

## Variables

My usage of variables in this task has been quite minimal, mainly applying to tags that I want to keep consistent throughout all of the instances, along with some variables on the VPC as a learning experience to see how they work in practice.

## Outputs

This is a simple file that I've created to output the public DNS name of the load balancer, as this is the main indicators that the template has been created succesfully, as the end goal is to gain a DNS name from the load balancer that will successfully connect to my EC2 instance.

## Comparing to Cloudformation

In my Cloudformation template (can also be found on this repo) I used YAML to create the template and found that Terraform felt like a cross between the ease-of-use of YAML and the security of JSON in terms of it being more difficult to get away with bad syntax. Having access to the modules did make some of the more basic elements of the templates easier compared to Cloudformation and certainly having easy access to the variables made common items much easier to replicate as opposed to my Cloudformation template where common items such as the tags are duplicated across the various resources.

Access to items such as Validate also helped clear myself of any syntax errors in the code before I uploaded to AWS, whereas with Cloudformation my way of solving this would be to upload the template, and see what would fail and cause a rollback, so Terraform felt like a much safer environment from that point of view.

## Learning for the future

This initial template has served as a good testing ground for me, especially as, using t2.micro instances with an ALB I was able to get everything to fit under my free tier so I was able to develop, iterate and destroy quickly whilst not incurring any cost.