# Observability With Istio, Kiali, and Grafana in Kubernetes and Spring Boot


Install ISTIO 
1. curl -L https://istio.io/downloadIstio | sh -
2. Move ISTIOCTL binary to BIN folder: 
2.1 cp istio-1.??.?/bin/istioctl /bin/ 
3. Set K8S Context to ISTIO
3.1 chmod ug+wr  /home/ubuntu/.kube/config
3.2 kubectl config set-context --current --namespace=istio-system
3.3 Install ISTIO : istioctl install --set profile=demo
the demo profile which will include  we need.
4. Validate ISTIO and install ADDONS
4.1 istioctl x precheck
4.2 kubectl apply -f istio-1.13.?/samples/addons/grafana.yaml
4.3 kubectl apply -f istio-1.13.?/samples/addons/jaeger.yaml
4.4 kubectl apply -f istio-1.13.?/samples/addons/kiali.yaml
4.5 kubectl apply -f istio-1.13.?/samples/addons/prometheus.yaml

-------
Enable SIDE CAR
Set the side car proxies to be automatically created for any pods in the "spring" namespace.
kubectl create namespace spring
kubectl label namespace spring istio-injection=enabled

kubectl apply -f examples/00-spring-deployment.yaml
kubectl apply -f examples/01-gateway.yaml
kubectl apply -f examples/02-virtualservice.yaml
