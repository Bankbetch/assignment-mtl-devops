resource "kubernetes_config_map" "argocd-cm" {
  metadata {
    name      = "argocd-cm"
    namespace = "pipeline"
  }
  data = {
    "accounts.demo"                  = " apiKey,login"
    "accounts.demo.enabled"          = "true"
    "admin.enabled"                  = "true"
    "application.instanceLabelKey"   = " argocd.argoproj.io/instance"
    "exec.enabled"                   = "false"
    "server.rbac.log.enforce.enable" = "false"
    "timeout.hard.reconciliation"    = "0s"
    "timeout.reconciliation"         = "30s"
  }
}

resource "kubernetes_config_map" "argocd_rbac_cm" {
  metadata {
    name      = "argocd-rbac-cm"
    namespace = "pipeline"
  }

  data = {
    "policy.demo"    = "role:readonly"
    "policy.default" = ""
    "scopes"         = "[groups]"
    "policy.csv"     = <<-EOT
    p, role:demo-ro, projects, get, demo, allow
    p, role:demo-ro, applications, get, demo/*, allow
    p, role:demo-ro, clusters, get, *, allow
    p, role:demo-ro, repositories, get, *, allow
    p, role:demo-ro, applications, sync, *, allow
    g, demo, role:demo-ro
    EOT
  }
}
