# Terraform Final Exam
The following exam should start at class and continue at home due to it's length.

Solution should be uploaded to a your private git repo and sent to you instructure for review.
Please add you instructure as a contributer to you Repo so comments can be added.

### AGENDA
1. To complete this exam you will have to research and read additonal terraform and AWS documentation.
2. Open an account in AWS (You'll need it for your own future training and learning)

### Exam objective
- Build a multi server (cluster) 
- Connect the servers to a LoadBalancer
- Expose the LB to the world (create a custom Security group to expose port 80 to 0.0.0.0)


# Exam Details 
1. EC2 Instances
Create two t2.small instances (dont forget AMI image)
1.1 Configure new security policy to both instances using terraform aws_security_group_rule
1.1.1 allow port 80 to recive traffic from the 0.0.0.0 (everywhere)
1.2 Use Remote exec to run the following (Install nginx) on both instances (Dont forget about the SSH Key...)
~~~
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
~~~

2. Create a loadbalancer using terraform aws_elb resource
2.1 Connect the loadbalancer to the instances you started 
2.2 Attache security policy to the loadBalancer to expose port 80 to 0.0.0.0 (the world)
2.3 Configure OUTPUT to print to the console the ELB public DNS


# Expected results
Browsing http://[ELB-DNS-OUTPUT] Will show the NGINX Hello page.



Solution to the exam will be provided in two weeks.


Good luck!
Please send questions!

