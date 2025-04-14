#!/bin/bash

#apply bets rate limit e auth
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/kratelimit.yaml -n bets

#apply cluster
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/kprometheus.yaml 

#apply api bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/bets-api.yaml -n bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/king.yaml -n bets

#teste de conexão
curl --location 'http://localhost:80/api/bets' \
--header 'Content-Type: application/json' \
--data-raw '{
    "match": "1X-DC",
    "email": "joe@doe.com",
    "championship": "Uefa Champions League",
    "awayTeamScore": "2",
    "homeTeamScore": "3"
}'

###Log no kong - se tiver o openid connect atiado e passar o token ele não validará o token
#kubectlogs -f kong-kong-7d698895f4-bms8f proxy -n kong
#10.244.0.1 - - [11/Apr/2025:21:24:29 +0000] "POST /api/bets HTTP/1.1" 201 134 "-" "curl/7.81.0"
#####time="2025-04-11T21:16:59Z" level=error msg="failed to fetch KongPlugin resource" error="no KongPlugin or KongClusterPlugin was found for bets/oidc-bets" kongplugin_name=oidc-bets kongplugin_namespace=bets

#ativando openid connect
kubectl port-forward svc/keycloak 8080:80 -n iam
echo user keycloak and password keycloak
#1 - create realm bets
#2 - create user rodrigo com uma senha
#3 - create app client kong
#4 - Inserir o token no infra/kong-k8s/misc/apis/kopenid.yaml -> kizhRIPgcnvL3Uw61iw4yeCzqBccpTQm
#http://localhost:8080/realms/bets/.well-known/openid-configuration

#ativando o plugin de autenticacao no kong usando o keycloak
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/kopenid.yaml -n bets

#Para pegar o token teremos que subir um novo pod que acessará o keycloak para gerar oauth
chmod 775 /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/token/get-token.sh /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/token/apply-token.sh
/home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/token/apply-token.sh
/home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/token/get-token.sh
#no arquivo get-token.sh precisará colocar o usuario, senha e client_secret
#isso porque será validado o host http://keycloak.iam/ na requisição do token

