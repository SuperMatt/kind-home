locals {
    cortex_config = {
        "config.blocks_storage.backend" = "filesystem"
        "store_gateway.enabled" = false
        "ruler.enabled" = false
        "compactor.enabled" = false
        "alertmanager.enabled" = false
    }
}

provider "kubernetes" {
  config_path = "/workspaces/helm-test/.kube/config"
  config_context = "kind-helm-test"
}

provider "helm" {
    kubernetes {
      config_path = "/workspaces/helm-test/.kube/config"
    }
}

resource "helm_release" "cortex" {
    name = "cortex"
    repository = "https://cortexproject.github.io/cortex-helm-chart"
    chart = "cortex"
    namespace = "cortex"
    create_namespace = true
    wait = false
    wait_for_jobs = false

    dynamic set {
        for_each = local.cortex_config
        content {
            name = set.key
            value = set.value
        }
    }
}