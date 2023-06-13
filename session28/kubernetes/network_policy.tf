resource "kubernetes_namespace" "backend" {
  metadata {
    name = "backend"
  }
}

resource "kubernetes_namespace" "db" {
  metadata {
    name = "db"
  }
}

resource "kubernetes_network_policy" "db" {
  metadata {
    name      = "db"
    namespace = kubernetes_namespace.db.metadata.0.name
  }

  spec {
    pod_selector {
			match_labels = {
				app = "db"
			}
    }
    ingress {
      ports {
        port     = "3306"
        protocol = "TCP"
      }
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "backend"
          }
        }
      }
   }
    policy_types = ["Ingress"]
  }
}


##############

resource "kubernetes_config_map" "db" {
  metadata {
    name = "db-config"
    namespace = kubernetes_namespace.db.metadata.0.name
  }

  data = {
    "example.conf" = <<EOF
      server {
            listen       3306;
            listen  [::]:3306;
            server_name  localhost;
            location / {
                root   /usr/share/nginx/html;
                index  index.html index.htm;
            }
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   /usr/share/nginx/html;
            }
      }
      server {
            listen       5432;
            listen  [::]:5432;
            server_name  localhost;
            location / {
                root   /usr/share/nginx/html;
                index  index.html index.htm;
            }
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   /usr/share/nginx/html;
            }
      }
    EOF
  }
}

resource "kubernetes_deployment" "db" {
  metadata {
    name = "db"
    namespace = kubernetes_namespace.db.metadata.0.name
    labels = {
      app = "db"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "db"
      }
    }

    template {
      metadata {
        labels = {
          app = "db"
        }
      }

      spec {
        container {
          image = "registry.mmokhtar.ir/library/nginx:alpine"
          name  = "db"
          volume_mount {
            mount_path = "/etc/nginx/conf.d"
            name = "db-config"
          }
        }
        volume {
          name = "db-config"
          config_map {
            name = "${kubernetes_config_map.db.metadata.0.name}"
          }
        }
      }
    }
  }
}

##############

resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
    namespace = kubernetes_namespace.backend.metadata.0.name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          image = "registry.mmokhtar.ir/library/nginx:alpine"
          name  = "backend"
        }
      }
    }
  }
}

#################

resource "kubernetes_deployment" "backend_in_db_ns" {
  metadata {
    name = "backend"
    namespace = kubernetes_namespace.db.metadata.0.name
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          image = "registry.mmokhtar.ir/library/nginx:alpine"
          name  = "backend"
        }
      }
    }
  }
}