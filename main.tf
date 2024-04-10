resource "kubernetes_manifest" "configmap" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ConfigMap"
    "metadata" = {
      "namespace" = "${var.namespace}"
      "name"      = "entrypoint"
      "labels" = {
        "app" = "${gke_timezone_label}"
      }
    }
    "data" = {
      "entrypoint.sh" = <<-EOF
        #!/usr/bin/env bash
        set -euo pipefail
        chroot /root timedatectl set-timezone ${var.timezone}
      EOF
    }
  }
}

resource "kubernetes_manifest" "daemonset" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind"       = "DaemonSet"
    "metadata" = {
      "namespace" = "${var.namespace}"
      "name"      = "node-initializer"
      "labels" = {
        "app" = "${gke_timezone_label}"
      }
    }
    "spec" = {
      "selector" = {
        "matchLabels" = {
          "app" = "${gke_timezone_label}"
        }
      }
      "updateStrategy" = {
        "type" = "RollingUpdate"
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "name" = "node-initializer"
            "app"  = "${gke_timezone_label}"
          }
        }
        "spec" = {
          "volumes" = [
            {
              "name" = "root-mount"
              "hostPath" = {
                "path" = "/"
              }
            },
            {
              "name" = "entrypoint"
              "configMap" = {
                "name"        = "entrypoint"
                "defaultMode" = 484     # decimal format
                # "defaultMode" = 0744  # octal format (it would fail if octal)
              }
            }
          ]
          "initContainers" = [
            {
              "image"   = "ubuntu:18.04"
              "name"    = "node-initializer"
              "command" = ["/scripts/entrypoint.sh"]
              "securityContext" = {
                "privileged" = true
              }
              "volumeMounts" = [
                {
                  "name"      = "root-mount"
                  "mountPath" = "/root"
                },
                {
                  "name"      = "entrypoint"
                  "mountPath" = "/scripts"
                }
              ]
            }
          ]
          "containers" = [
            {
              "image" = "gcr.io/google-containers/pause:2.0"
              "name"  = "pause"
            }
          ]
        }
      }
    }
  }
  depends_on = [
    kubernetes_manifest.configmap,
  ]
}
