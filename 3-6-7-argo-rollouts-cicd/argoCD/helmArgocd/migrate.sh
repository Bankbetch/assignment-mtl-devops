export NAMESPACE=pipeline

helm upgrade --install argocd -f values.yaml argo/argo-cd -p $NAMESPACE

k apply -f argocd-cm.yaml
k apply -f argocd-rbac-cm.yml
k apply -f argocd-repo.yaml

argocd login localhost:49391 --username admin

argocd account update-password --account demo --new-password password