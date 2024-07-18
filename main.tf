# Configure the Kubernetes provider with the path to your kubeconfig file
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Define a Kubernetes deployment resource
resource "kubernetes_deployment" "passapp" {
  metadata {
    name = "passapp"                   # The name of the deployment
    labels = {
      App = "passapp"                  # Labels for the deployment
    }
  }
  spec {
    replicas = 2                     # Number of replicas (Pods) to create
    selector {
      match_labels = {
        App = "passapp"                # Match the labels to identify Pods managed by this deployment
      }
    }
    template {
      metadata {
        labels = {
          App = "passapp"              # Labels for the Pod template
        }
      }
      spec {
        container {
          image = "stanislavhaitov/pass_app:v1.0"  # Docker image for the container
          name  = "passapp"              # Name of the container
          port {
            container_port = 5000      # Container port to expose
          }
        }
      }
    }
  }
}

# Define a Kubernetes service resource
resource "kubernetes_service" "passapp" {
  metadata {
    name = "tf-passapp-service"            # The name of the service
  }
  spec {
    selector = {
      App = "passapp"                    # Selects Pods with the label 'App=myapp'
    }
    port {
      port        = 80                 # The port that the service will expose
      target_port = 5000               # The target port on the Pods
    }
    type = "NodePort"                  # Type of service (NodePort)
  }
}
