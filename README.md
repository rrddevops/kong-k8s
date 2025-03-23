
install helm
install k3d and docker
install kubectl

Kong install: 
/kong-k8s/infra/kong-k8s/kong/kong.sh

Install Keycloak:
/kong-k8s/infra/kong-k8s/misc/keycloak/keycloak.sh

Install Prometheus:
./kong-k8s/infra/kong-k8s/misc/prometheus/prometheus.sh

kubectl create ns bets:
```sh
kubectl apply -f ./kong-k8s/infra/kong-k8s/misc/apps/ --recursive -n bets
```

Plugin ratelimit:
```sh
kubectl apply -f  ./kong-k8s/infra/kong-k8s/misc/apis/kratelimit.yaml -n bets
```

Plugin Prometheus
```sh
kubectl apply -f  ./kong-k8s/infra/kong-k8s/misc/apis/kprometheus.yaml -n bets
```

Opção de usar service Mesh opção de roteamento a seguir:
```sh
kubectl apply -f ./kong-k8s/infra/kong-k8s/misc/apis/king.yaml -n bets
kubectl apply -f ./kong-k8s/infra/kong-k8s/misc/apis/bets-api.yaml -n bets
```

Expor o keycloak criar os usuarios para autenticação: 
```sh
kubectl port-forward svc/keycloak 8080:80 -n iam
```

Criar um realm chamado bets no Keycloak e o usuário para autenticação;

Criar um novo client para autenticação da api:
Standard flow on
Client authentication on
Direct access grants on
Service accounts roles on
Valid redirect URIs  * 
Try to disable all features from "Autentication" menu

```sh
kubectl apply -f ./kong-k8s/infra/kong-k8s/misc/apis/kopenid.yaml -n bets
```

Ele fara o download da jwks uri para chave publica e validar a credencial

Habilitar o plugin de oidc no betsapi:
konghq.com/plugins: oidc-bets,rl-by-header,prometheus-bets

```sh
kubectl apply -f  ./kong-k8s/infra/kong-k8s/misc/apis/bets-api.yaml -n bets
```
```sh
kubectl exec -it testcurl -- sh
```
```sh
curl --location --request POST 'http://keycloak.iam/realms/bets/protocol/openid-connect/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'client_id=kong' \
--data-urlencode 'grant_type=password' \
--data-urlencode 'username=rodrigo' \
--data-urlencode 'password=123456' \
--data-urlencode 'client_secret=Mq0WIyGRnumtnXdWl9q16SI9y55YBy40' \
--data-urlencode 'scope=openid'
```

```sh
curl --location 'http://localhost:80/api/bets' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJEelFNVnUyQ2RnWk9wbXlQR2J6U2piWUNlX2ZzY3dVd1duTU92V0NkRmg4In0.eyJleHAiOjE3NDI2ODE4NDEsImlhdCI6MTc0MjY4MTU0MSwianRpIjoiNTlmMTI1MWEtMmI0OC00MTAxLWJmMjAtZDEyYzQ0YWNiYTFjIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrLmlhbS9yZWFsbXMvYmV0cyIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiI4NWE3NmRmNi04ZmNkLTRhZTYtYmIyZS1jYWE0YTMxOTE5NTAiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJrb25nIiwic2lkIjoiZTJlNTQ5MjgtNDZhOC00NjJkLWEyMjEtYjQxMTA3ZDEzOWI4IiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiZGVmYXVsdC1yb2xlcy1iZXRzIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJvcGVuaWQgcHJvZmlsZSBlbWFpbCIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJyb2RyaWdvIiwiZW1haWwiOiJyb2RyaWdvcmRhdmlsYUBnbWFpbC5jb20ifQ.moGx8yG_1bQ96jb3nV2HBNn4bTuYLjVckRfrY1mWGOqDme2zBcWgNGiNJUMB5GAHooFzFNXRQeTo9-51FWjyNi4cV_nIWFfW8ShHQtRm3pk_2PLwh4J2Oq9cUs34EM8eHWw4XKuI4HReW4ncpZVXGuYZF8WeybJl_-0wadnz3FWBYQx1n4CiSECkpu604tZC2KQnJlwI6sZIVBS-7FbBuT1PXQlgg-ka_abAeObay0m8wt97kNQHiRCjFdByw16D0YqyuHyA8WxX9K78W8r3UQ4rPKHWQMFmzINfJNurtOdrV31BJ5hVQi4iN1OHjHM1m5FZFwOOk8C3WaP05xylWA' \
--data-raw '{
    "match": "1X-DC",
    "email": "joe@doe.com",
    "championship": "Uefa Champions League",
    "awayTeamScore": "2",
    "homeTeamScore": "3"
}'
```


API com GitOps Operator:
Argo
Spectro validação do contrato da API (Design da API)
Postman
Github Pipeline (workflows com runset)
https://github.com/rrddevops/kong-k8s/actions/runs/14021754244/job/39254628199