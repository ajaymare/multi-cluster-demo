# multi-cluster-demo
├── README.md
├── Taskfile.yaml
├── app
│   ├── bookinfo-service.yaml
│   ├── gw-config.yaml
│   ├── namespace.yaml
│   ├── sleep.yaml
│   └── tls-secret.yaml
├── infra
│   ├── east-west.yaml
│   ├── install-ew-gw.yaml
│   ├── install-gw.yaml
│   ├── ws-config.yaml
│   └── ws-ew-config.yaml
├── scripts
│   ├── deploy-app.sh
│   ├── deploy-t1.sh
│   ├── east-west.sh
│   ├── t2-failover.sh
│   └── ws-config.sh
└── t1
    ├── install-gw-t1.yaml
    ├── namespace.yaml
    ├── t1-gw-config.yaml
    └── t1-ws-config.yaml