# Installation process

~~~
1. curl -L https://istio.io/downloadIstio | sh -
2. cd istio-1.4.0
3. export PATH=$PWD/bin:$PATH
4. istioctl manifest apply --set profile=demo
5. kubectl get svc -n istio-system
6. kubectl edit -n istio-system svc istio-ingressgateway * change to nodeport  and host port 30080 as configured in our KIND Exposed ports
~~~~

# Enabled ISTIO side car
~~~~
On default or any other Namespaces that we need to use
kubectl label namespace default istio-injection=enabled
~~~~


# Follow Ingress DEMO
https://istio.io/docs/tasks/traffic-management/ingress/ingress-control/
