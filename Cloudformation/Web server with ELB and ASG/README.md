# Cloudformation template - creating a web server with auto scaling and load balancing on AWS

This is part of my initial learning on how to use Cloudformation with AWS and specifically, how it compares with Terraform in similar tasks.

## The goal

The goal of this template was to be able to create in the Paris region all of the resources necessary to be able to create a highly available web server using one of my pre-configured AMI's set as part of an auto scaling group behind an application load balancer to operate as a basic start page to my most commonly used web pages.

## JSON vs YAML

In this template I used YAML as my coding language of choice mainly down to its readability. I've had experience with JSON in the past when it comes to permissions in AWS such as IAM and S3 Bucket Policies but I've always found it a bit too hard to read and fiddly with all of the brackets flying around everywhere.

This is actually my first experience with YAML (having seen it 2 or 3 times in the past) and have actually found using it very straightforward, and never ran into any breaking syntax issues, apart from minor things such as entering items as a string when it should have been entered as a list even with only one item etc.

One of my tests in the near future is to replicate this file in JSON so I can get better acquainted with how that works especially as it has a much wider use case and would be the prominent solution in automating these sorts of templates even further.

## Working with declarative code

An interesting part of this challenge was understanding just how much needed to be included in the code that, when following through these methods via the AWS console, you tend to walk through without thinking too much.

A good example here is the Security Groups. When creating a security group if I wanted to allow HTTP traffic I would add an option, choose HTTP from the list and choose all IPv4 traffic from the sources. On cloudformation you have to explicitly show the port that you're allowing, i.e. port 80 as opposed to choosing HTTP, as well as choosing between TCP or UDP, and again entering in the CIDR IP range instead of just choosing all IP traffic. 

This did force me to be more focused on the code that I was creating and making sure it fit exactly what I was asking of it, so I was more thoughtful on my actions as opposed to potentially opening up ports that were unnecessary or potentially making changes that do not impact the end result but could cause issues later on down the line on the console.

## Working through the AWS resources

I found the AWS documentation really clear and concise and was a massive help in making sure everything that was necessary to create the resources was included. There were some odd items such as the VPC details being included in the EC2 section as opposed to having it's own heading but once I found the resources the only minor issues I ran into were forgetting to add the subnet routes to the route table and then making sure I was using the right syntax i.e. lists as opposed to strings etc.

## The take home

I have found using YAML to create the Cloudformation template a really helpful first step into Cloudformation and how it works, and has really helped me understand how Cloudformation works in practice and where it can be useful when it comes to automating infrastructure. 