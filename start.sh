#!/bin/bash
kubectl create ns kong

echo add kong
helm repo add kong https://charts.konghq.com
helm repo update
helm install kong kong/kong -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/kong/kong-conf.yaml --set proxy.type=NodePort,proxy.http.nodePort=30000,proxy.tls.nodePort=30003 --set ingressController.installCRDs=false --set serviceMonitor.enabled=true --set serviceMonitor.labels.release=promstack --namespace kong

echo add keycloak
kubectl create ns iam
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install keycloak bitnami/keycloak --set auth.adminUser=keycloak,auth.adminPassword=keycloak --namespace iam

echo add prometheus
kubectl create ns monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-stack prometheus-community/kube-prometheus-stack -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/prometheus/prometheus.yaml --namespace monitoring

echo add bets
kubectl create ns bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apps/ --recursive -n bets

echo add kong api plugins
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/kratelimit.yaml -n bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/kprometheus.yaml -n bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/king.yaml -n bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/bets-api.yaml -n bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/kopenid.yaml -n bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/bets-api.yaml -n bets

echo add argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo acessando argocd
echo kubectl exec -n argocd --stdin --tty argocd-server -- /bin/bash
echo argocd admin initial-password -n argocd
echo kubectl port-forward svc/argocd-server -n argocd 8081:443

echo add helm apis argo deployment
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/matches.yaml -n argocd
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/players.yaml -n argocd
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/championships.yaml -n argocd
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/bets.yaml -n argocd

echo acessando keycloak
echo kubectl port-forward svc/keycloak 8080:80 -n iam
echo user keycloak and password keycloak

echo configurar iam auth
echo Criar um realm chamado bets no Keycloak e o usuário para autenticação;

echo Criar Um novo client chamado kong para autenticação da api com os parametros:
echo Standard flow on
echo Client authentication on
echo Direct access grants on
echo Service accounts roles on
echo Valid redirect URIs  * 
echo Try to disable all features from "Autentication" Reuired Actions menu