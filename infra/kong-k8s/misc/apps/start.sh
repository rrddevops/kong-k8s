#!/bin/bash
kubectl create ns bets
kubectl apply -f /home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apps --recursive -n bets