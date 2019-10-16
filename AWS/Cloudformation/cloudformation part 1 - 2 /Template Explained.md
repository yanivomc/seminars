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
###Next continue to define the Template paramters
Paramters will be shown in the AWS console for the operator to choose/type

Paramter screen shoot of our sample example:

![alt text](https://github.com/yanivomc/seminars/blob/master/AWS/Cloudformation/cloudformation%20part%201%20-%202%20/images/stack%20details.png?raw=true "CLOUDFORMATION Paramters")



###### KEYPAIRS
~~~
paramName: # Type in a name you choose
  Description: 
  Type: AWS::EC2::KeyPair::KeyName
  Default:
~~~
