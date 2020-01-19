# KIND INSTALLATION 
### PROXY INFO: Configure kind/docker to use a proxy

If you are running kind in an environment that uses a proxy, you may need to configure kind to use it.

You can configure kind to use a proxy using one or more of the following environment variables (uppercase takes precedence):

HTTP_PROXY or http_proxy
HTTPS_PROXY or https_proxy
NO_PROXY or no_proxy


#### Note:
If you set a proxy it would be used for all the connection requests. It’s important that you define what addresses doesn’t need to be proxied with the NO_PROXY variable, typically you should avoid to proxy your docker network range NO_PROXY=172.17.0.0/16 & VM Subnets


Once configured - start your nexus cluster

# NEXUS Installation
Note that Nexus is installed insecured without SSL.
In folder ./k8s/nexus run:
~~~
docker-compose up -d 
~~~

Validate everything works:
~~~
docker-compose logs -f 
~~~


### Please set the following on Nexus UI
*** For testing we are using domain name "registry.emei" but any other domain can be used - just make sure to create one that points the host where nexus is installed

You should be able to browse:
http://registry.emei/nexus

1. Create new registry 
2. Set HTTP Connetctor to 5000
3. Check "allow anonymos docker pull"
4. Save


Set your local host file and all of your kind NODES
~~~
export REGISTRY_IP=192.168.86.73 # Change to the IP where NEXUS is installed
export REGISTRY_HOSTNAME=registry.emei # change to the name of the host name
export CLUSTER_NAME=toga # change to the name of your cluster

for node in $(kind get nodes --name ${CLUSTER_NAME}); do
  docker exec "${node}" sh -c "echo ${REGISTRY_IP} ${REGISTRY_HOSTNAME} >> /etc/hosts"
done
~~~

Now Docker login using your admin user / pass should work:
~~~
docker login registry.emei
~~~

Testing:
~~~
docker pull alpine:latest
docker tag alpine:latest registry.emei/alpine:1
docker push registry.emei/alpine:1
~~~

Test K8S
~~~
kubectl create deployment testing --image=registry.emei/alpine:1

kubectl get pods
~~~

