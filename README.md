# GKE Nodes timezone configurator

Instead of using default UTC0 you can specify your own timezone.  
More details you can find [here](https://cloud.google.com/knowledge/kb/how-to-change-a-container-s-time-zone-000004909#cause) and [there](https://cloud.google.com/kubernetes-engine/docs/tutorials/automatically-bootstrapping-gke-nodes-with-daemonsets).

Configure timezone on GKE Nodes using:
- ConfigMap
- DaemonSet

Default values:
- `namespace` - default
- `timezone` - Europe/Berlin
- `gke_timezone_label` - default-init

Keep in mind to set up the same `label` for GKE nodes and have `kubeconfig` available!

```
module "gke_nodes_timezone" {
  source   = "git@github.com:michalswi/gke-nodes-timezone.git?ref=main"
}
```

```
> check ConfigMap
$ kubectl get cm
NAME               DATA   AGE
entrypoint         1      8s
kube-root-ca.crt   1      20h


> check DaemonSet (3 GKE nodes)
$ kubectl get ds
NAME               DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
node-initializer   3         3         3       3            3           <none>          58s


> check GKE node
gke-node-pool-01999668-t0jv ~ $ timedatectl
Local time: Wed 2024-04-09 08:41:03 CEST
Universal time: Wed 2024-04-09 06:41:03 UTC
RTC time: Wed 2024-04-09 06:41:03
Time zone: Europe/Warsaw (CEST, +0200)
System clock synchronized: yes
NTP service: active
RTC in local TZ: no
```
