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