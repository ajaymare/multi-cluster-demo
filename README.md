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
│   ├── gw-config.yaml
│   ├── install-gw.yaml
│   └── ws-config.yaml
├── canary
├── east-west
│   ├── install-ew-gw.yaml
│   └── ws-ew-config.yaml
├── edge-gateway
│   ├── install-gw-t1.yaml
│   ├── namespace.yaml
│   ├── t1-gw-config.yaml
│   └── t1-ws-config.yaml
└── scripts
    ├── deploy-app.sh
    ├── deploy-t1.sh
    ├── east-west.sh
    ├── ew-failover.sh
    ├── ext-client.sh
    └── t2-failover.sh
```