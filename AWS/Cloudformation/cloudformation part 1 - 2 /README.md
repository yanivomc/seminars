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

---
Our Template start with declaring the version for the template
~~~
AWSTemplateFormatVersion: '2010-09-09'
Description: JB sample instllation
~~~
NOTE: The AWSTemplateFormatVersion section (optional) identifies the capabilities of the template. The latest template format version is 2010-09-09 and is currently the only valid value.

---
# Parameters

Paramters will be shown in the AWS console for the operator to choose/type when he launch our Template

Paramter screen shoot of our sample template example:

![alt text](https://github.com/yanivomc/seminars/blob/master/AWS/Cloudformation/cloudformation%20part%201%20-%202%20/images/stack%20details.png?raw=true "CLOUDFORMATION Paramters")


### We start to define the Template paramters with:
###### KEYPAIRS
Keypairs will allow us to select an SSH KEY to use when we wish to connect to our created EC2 INSTANCES

Here we allow the operator to select an already created KEYPAIR
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

---
# MAPPING

### Setting KV Mapping
here we will define KV to be used later in our Stack configuration for helping autodetect the region we are working on and the AMI required by the instance type on that region. 


The first Mapping declare Key as instance type and Value as it's Virtualization types (Paravirtualiztion / Hardware VM)
~~~
Mappings:
  AWSInstanceType2Arch:
    t1.micro:
      Arch: PV64
    t2.nano:
      Arch: HVM64
    t2.micro:
      Arch: HVM64
~~~~

Next we configure the avilable regions where we wish to work on and thier related AMI ID (each region in AWS has it's own AMI storage and dedicated ID's)

~~~
AWSRegionArch2AMI:
    eu-west-1:
      PV64: ami-4cdd453f
      HVM64: ami-f9dd458a
    eu-west-2:
      PV64: NOT_SUPPORTED
      HVM64: ami-886369ec
    eu-west-3:
      PV64: NOT_SUPPORTED
      HVM64: NOT_SUPPORTED
~~~

---

# Resources
### Setting Resources

Read the [refrence for CloudFormation Resource and Property Types](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html) to see all the resources we can control, define and deploy.

In Our example we are only going to build one EC2 Instance and a Security group.

Inside our resource we can and will reference a VALUE from our mapping KV as part of the resource configuration.

###### First we define a Security Group (SG)
~~~
WebServerSecurityGroup: # SG Name
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable HTTP access via port 80 locked down to the load balancer
        + SSH access
      SecurityGroupIngress: # Incoming traffic allowness
      - IpProtocol: tcp
        FromPort: '80'
        ToPort: '80'
        CidrIp: 0.0.0.0/0
      - IpProtocol: tcp
        FromPort: '22'
        ToPort: '22'
        CidrIp: # Define CIDR IP using a reference to our SSHLocation Parameter we defined above as an input from the operator.
          Ref: SSHLocation
~~~

###### Now we set the Ec2 Instance
in the EC2 Instance resources we will use built-in function to return the value of the corresponding key in our Map definitions above. The built in function called "FindMap" allows it.

Read [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html) for more built in function

We call a function as followed: "Fn::FindInMap:"

~~~
WebServerInstance: # Instance Name
    Type: AWS::EC2::Instance
    Properties:
      ImageId: # Define the image ID using 
        Fn::FindInMap:
        - AWSRegionArch2AMI
        - Ref: AWS::Region
        - Fn::FindInMap:
          - AWSInstanceType2Arch
          - Ref: InstanceType
          - Arch
      InstanceType:
        Ref: InstanceType
      SecurityGroups:
      - Ref: WebServerSecurityGroup
      KeyName:
        Ref: KeyName
~~~

In our EC2 instance resource definition we can also implment something called "UserData"

UserData gives us the option of passing custom user data to the instance that can be used to perform common automated configuration tasks and even run scripts after the instance starts such as installing a webserver, Configuring the EC2 instance etc...

###### In our example we will use the UserData to run a few commands in bash.

~~~
      UserData:
        Fn::Base64:
          Fn::Join:
          - ''
          - - "#!/bin/bash\n"
            - 'yum update -y

'
            - 'mkdir /tmp

'
            - 'mkdir /tmp/amol

'
~~~

---

# OUTPUTS
Lastly we will define our outputs that allows us to extract information from our created stack (Such as an IP of a machine) and use it in other Templates that we build/use

~~~
Outputs:
  InstanceDNSName:
    Value:
      Fn::GetAtt: # Here we call up a function called GetAttribute of our  - 
      - WebServerInstance # EC2 Resource name
      - PublicDnsName # The EC2 Resource Public DNS NAME
    Description: Instance DNS Name
  InstanceIP:
    Value:
      Fn::GetAtt: # Same for the instance IP
      - WebServerInstance
      - PublicIp
    Description: Instance IP
~~~


