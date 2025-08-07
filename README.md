# multi-cluster-demo

```yaml
.
├── README.md
├── Taskfile.yaml
├── app
│   ├── bookinfo-service.yaml
│   ├── namespace.yaml
│   ├── sleep.yaml
│   └── tls-secret.yaml
├── app-gateway
│   ├── app-gw-config.yaml
│   ├── install-app-gw.yaml
│   └── ws-config.yaml
├── canary
├── east-west
│   ├── install-ew-gw.yaml
│   └── ws-ew-config.yaml
├── edge-gateway
│   ├── edge-gw-config.yaml
│   ├── install-edge-gw.yaml
│   ├── namespace.yaml
│   └── ws-config.yaml
└── scripts
    ├── app-gw-failover.sh
    ├── deploy-app.sh
    ├── deploy-edge.sh
    ├── east-west.sh
    ├── ew-failover.sh
    ├── ext-client.sh
    └── int-client.sh
```
## Usage:
```yaml
task: Available tasks for this project:
* deploy:app:                   Deploy Bookinfo app and Gateway to all available clusters
* deploy:app-gw-failover:       Perform App GW failover and restore
* deploy:east-west:             Deploy East West Gateway and respective configuration across clusters
* deploy:edge:                  Deploy Edge Gateway and configuration
* deploy:ew-failover:           Perform East West Gateway failover test and restore
```