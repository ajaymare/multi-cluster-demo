# multi-cluster-demo

```yaml
.
├── README.md
├── Taskfile.yaml
├── app
│   ├── bookinfo-service.yaml
│   ├── gw-config.yaml
│   ├── namespace.yaml
│   ├── sleep.yaml
│   └── tls-secret.yaml
├── east-west
│   ├── install-ew-gw.yaml
│   └── ws-ew-config.yaml
├── infra
│   ├── install-gw.yaml
│   └── ws-config.yaml
├── scripts
│   ├── deploy-app.sh
│   ├── deploy-t1.sh
│   ├── east-west.sh
│   ├── ew-failover.sh
│   ├── t2-failover.sh
│   └── ws-config.sh
└── t1
    ├── install-gw-t1.yaml
    ├── namespace.yaml
    ├── t1-gw-config.yaml
    └── t1-ws-config.yaml
```