#!/bin/bash

kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/matches.yaml -n argocd
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/players.yaml -n argocd
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/championships.yaml -n argocd
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/argo-apps/bets.yaml -n argocd
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl delete -f  /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/bets-api.yaml -n bets
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/kopenid.yaml -n bets
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apis/king.yaml -n bets
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/bets-api.yaml -n bets
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/kprometheus.yaml -n bets
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/kratelimit.yaml -n bets
kubectl delete -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apps/ --recursive -n bets
kubectl delete pods testcurl 

helm list --all-namespaces
helm uninstall kong  --namespace kong
helm uninstall kibana --namespace logs
helm uninstall fluentd --namespace logs
helm uninstall elasticsearch --namespace logs

kubectl get namespaces
kubectl delete ns argocd bets kong iam logs monitoring

kubectl get pods -A