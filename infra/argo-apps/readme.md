Usando infra como código para deployment: 

Aqui estão os arquivos de deployments que fará a integraçao com o argo.
apiVersion: argoproj.io/v1alpha1

Namespace o repositorio de origem:
  repoURL: https://github.com/rrddevops/bets-api.git

Validação do Kong:
    path: deployments/bets
      valueFiles:
        - values-kong.yaml

Destino  - onde será criado a aplicação:
  destination:
    namespace: bets
    server: https://kubernetes.default.svc

As aplicações não podem ser iniciadas pelo repositorio.
Encerre caso tenha criado manualmente: 
/home/rodrigo/projetos/kong-k8s/infra/kong-k8s/misc/apps/deployments
Ex: kubectl delete -f infra/kong-k8s/misc/apis/bets-api.yaml -n bets

#vamos iniciar as aplicações pelo argocd
kubectl apply -f infra/argo-apps/players.yaml -n argocd
kubectl apply -f infra/argo-apps/matches.yaml -n argocd