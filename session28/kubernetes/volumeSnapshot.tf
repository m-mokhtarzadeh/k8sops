resource "kubernetes_manifest" "volumesnapshot_longhorn" {
  depends_on = [ 
    module.velero,
    module.longhorn
  ]
  manifest = {
    "apiVersion" = "snapshot.storage.k8s.io/v1"
    "deletionPolicy" = "Delete"
    "driver" = "driver.longhorn.io"
    "kind" = "VolumeSnapshotClass"
    "parameters" = {
        "type" = "snap"
    }
    "metadata" = {
      "labels" = {
        "velero.io/csi-volumesnapshot-class" = "true"
      }
      "annotations" = {
        "snapshot.storage.kubernetes.io/is-default-class" = "true"
      }
      "name" = "longhorn"
    }
  }
}
