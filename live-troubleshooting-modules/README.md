# live-troubleshooting-modules 


#### Deploying your live-troubleshooting-module for the candidate:

```
gcloud container clusters get-credentials interview-cluster --zone northamerica-northeast1-a --project techops-interview
cd live-troubleshooting-modules/k8s-rails-todo-list
kustomize build . | kubectl apply -f-
```

#### Change the LoadBalancerIP to reflect the address of the 'interview-ingress-ip'
```
gcloud config set project techops-interview
gcloud compute addresses list | grep -i interview-ingress-ip | awk '{print $2}'
```


```
# live-troubleshooting-modules/k8s-rails-todo-list/ingress/controller-service.yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
  name: interview-ingress-nginx-controller
spec:
  type: LoadBalancer
  loadBalancerIP: 35.203.17.222 # CHANGE THIS TO REFLECT 'interview-ingress-ip' EVERY TIME YOU REDEPLOY A NEW STATIC ADDRESS WITH TERAFORM
```

#### How to review terminal sessions

```
# view terminal session
ls -alh /var/log/session 
scriptreplay -d 10 -t session.interview.27146.050620212155{.timing,}
```

```
# view latest terminal sesion of 'interview' user
scriptreplay -d 3 -t $(ls -tr | grep 'session.interview' | grep -v timing | tail -n 1){.timing,}
```

---
## live-troubleshooting-module: (Whats broken) 



#### Rails Application

- deployment | wrong DATABASE_HOST (should be `example-postgres.database`)
- deployment | wrong DATABASE_PORT (should be `5432`)

```
# railsk8s-app-deploy.yaml
        - name: DATABASE_HOST
          value: example-postgres.database
        - name: DATABASE_PORT
          value: '5432'
```

- ingress | wrong ingress-class (should be `nginx`)

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: rails-app-ingress
  annotations:
    certmanager.k8s.io/acme-http01-edit-in-place: "true"
    certmanager.k8s.io/cluster-issuer: issuer-dns01
    kubernetes.io/ingress.class: nginx
```
#### Postgres Database
- deployment | cannot be scheduled (no toleration deployment)

```
# example-postgres-deploy.yaml
      tolerations:
      - key: "data-pool"
        operator: "Equal"
        value: "true"
        effect: "NoSchedule"
```

