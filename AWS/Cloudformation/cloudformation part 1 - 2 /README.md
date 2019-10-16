# CLOUDFORMATION EXAMPLE EXPLAINED
### Template made easy
Recap - we wish to build a simple EC2 instance with A security group attached to it.

Follow this to understand what each part in the [Simple template](https://raw.githubusercontent.com/yanivomc/seminars/master/AWS/Cloudformation/cloudformation%20part%201%20-%202%20/cloudformation-basic-example.template.yml)
do.

----
#####Template base layout:
A template always start as followed
~~~
AWSTemplateFormatVersion: 2010-09-09
Description: ---
Metadata: 

Parameters: 

Mappings: 

Conditions: 

Resources: 

Outputs:

~~~
We start with declaring the version for the template
~~~
AWSTemplateFormatVersion: '2010-09-09'
Description: JB sample instllation
~~~
The AWSTemplateFormatVersion section (optional) identifies the capabilities of the template. The latest template format version is 2010-09-09 and is currently the only valid value.

---
### Next continue to define the Template paramters
Paramters will be shown in the AWS console for the operator to choose/type

Paramter screen shoot of our sample example:

![alt text](https://github.com/yanivomc/seminars/blob/master/AWS/Cloudformation/cloudformation%20part%201%20-%202%20/images/stack%20details.png?raw=true "CLOUDFORMATION Paramters")



###### KEYPAIRS
~~~
paramName: # Type in a Param name you choose
  Description: 
  Type: AWS::EC2::KeyPair::KeyName
  Default: #  Default value we choose
  ConstraintDescription: must be the name of an existing EC2 KeyPair.
~~~

###### Defining Custom parameters
Here we define a custom Parameter called "InstanceType" where we allow an operator to choose a specifc value that will be used later
~~~
InstanceType:
    Description: WebServer EC2 instance type
    Type: String
    Default: t2.micro
    AllowedValues:
    - t1.micro
    - t2.nano
    - t2.micro
    ConstraintDescription: must be a valid EC2 instance type.
~~~

Second custom paramter for defining a rule in our SG.
~~~
SSHLocation:
    Description: The IP address range that can be used to SSH to the EC2 instances
    Type: String
    MinLength: '9'
    MaxLength: '18'
    Default: 0.0.0.0/0
    AllowedPattern: "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})"
    ConstraintDescription: must be a valid IP CIDR range of the form x.x.x.x/x.
~~~

### Setting Mapping
here we can define KV to be used later in our Stack configuration

TODO: Add default role in JB Account for testing