# DEPLOY PROMETHEUS OPERATOR



# DEPLOY K8S KIND CLUSTER

# DEPLOY OUR SAMPLE APPLICATION
~~~
kubectl create -f deployment.yaml
kubectl create service clusterip sample-app --tcp=80:8080
~~~

Expose our sample-app
~~~
kubectl port-forward svc/sample-app 8089:80
~~~
Run from another terminal
~~~
curl localhost:8089

> Hello! My name is sample-app-74684b97f-tlhzs. I have served 21 requests so far.
~~~

Now we can expose this metric using Prometheus 'ServiceMonitor' CRD

~~~
kind: ServiceMonitor
apiVersion: monitoring.coreos.com/v1
metadata:
  name: sample-app
  labels:
    app: sample-app
spec:
  selector:
    matchLabels:
      app: sample-app
  endpoints: # scraping > our port named http in our deployment
  - port: http
~~~

Let's expose Prom Dashboard and view those metrics
~~~
kubectl port-forward svc/my-prom-prometheus-operato-prometheus 9090
~~~
Browse localhost:9090