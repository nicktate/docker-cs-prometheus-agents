# docker-cs-prometheus-agents
containership prometheus agents docker image

## Build Status
[![Build Status](https://drone.containership.io/api/badges/containership/docker-cs-prometheus-agents/status.svg)](https://drone.containership.io/containership/docker-cs-prometheus-agents)

## Installation
```
sudo docker run \
         --volume=/:/rootfs:ro \
         --volume=/var/run:/var/run:rw \
         --volume=/sys:/sys:ro \
         --volume=/var/lib/docker/:/var/lib/docker:ro \
         --net=bridge \
         --detach=true \
         --name=containership-prometheus-agents \
         containership/docker-cs-prometheus-agents:latest
```

## Environment Variables

### Prometheus Agents
`PROMETHEUS_AGENT_HOME` - location in container where prometheus agents are installed (default: "/opt/prometheus/containership-agents")

#### Prometheus cAdvisor Agent
`PROMETHEUS_AGENT_CADVISOR` - flag for turning on/off the cadvisor prometheus scraper (default: true)

`PROMETHEUS_AGENT_CADVISOR_VERSION` - cadvisor version to run (default: v0.23.2)

`PROMETHEUS_AGENT_CADVISOR_PORT` - port cadvisor should run on (default: 8500)

`PROMETHEUS_AGENT_CADVISOR_METRICS_PATH` - reverse proxy route for fetching cadvisor agent metrics (default: "/node/metrics")

`PROMETHEUS_AGENT_CADVISOR_CMD` - command used to start cadvisor in the container (default: "sudo $PROMETHEUS_AGENT_HOME/agents/cadvisor/cadvisor")

`PROMETHEUS_AGENT_CADVISOR_ARGS` - arguments passed to the cadvisor cmd (default: "--port $PROMETHEUS_AGENT_CADVISOR_PORT --logtostderr")

#### Prometheus node_exporter Agent
`PROMETHEUS_AGENT_NODE_EXPORTER` - flag for turning on/off the cadvisor prometheus scraper (default: true)

`PROMETHEUS_AGENT_NODE_EXPORTER_VERSION` - node_exporter version to run (default: 0.12.0)

`PROMETHEUS_AGENT_NODE_EXPORTER_PORT` - port node_exporter should run on (default: 8501)

`PROMETHEUS_AGENT_NODE_EXPORTER_METRICS_PATH` - reverse proxy route for fetching node agent metrics (default: "/node/metrics")

`PROMETHEUS_AGENT_NODE_EXPORTER_CMD` - command used to start cadvisor in the container (default: "$PROMETHEUS_AGENT_HOME/agents/node_exporter/./node_exporter")

`PROMETHEUS_AGENT_NODE_EXPORTER_ARGS` - arguments passed to the node_exporter cmd (default: "--web.listen-address=0.0.0.0:$PROMETHEUS_AGENT_NODE_EXPORTER_PORT")

## Roadmap
* Support for dynamically adding custom scrapers
