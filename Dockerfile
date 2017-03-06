FROM library/ubuntu:14.04

MAINTAINER ContainerShip Developers <developers@containership.io>

ENV NODE_VERSION 6.10.0

ENV PROMETHEUS_AGENT_HOME=/opt/prometheus/containership-agents
WORKDIR $PROMETHEUS_AGENT_HOME
COPY . .

RUN apt-get update && apt-get install -y git npm supervisor wget
RUN npm install -g n
RUN n $NODE_VERSION
RUN npm install

WORKDIR $PROMETHEUS_AGENT_HOME/agents

# CADVISOR
ENV PROMETHEUS_AGENT_CADVISOR=true
ENV PROMETHEUS_AGENT_CADVISOR_VERSION=v0.24.1
ENV PROMETHEUS_AGENT_CADVISOR_PORT=8500
ENV PROMETHEUS_AGENT_CADVISOR_METRICS_PATH="/cadvisor/metrics"
ENV PROMETHEUS_AGENT_CADVISOR_CMD="sudo $PROMETHEUS_AGENT_HOME/agents/cadvisor/cadvisor"
ENV PROMETHEUS_AGENT_CADVISOR_ARGS=""

RUN mkdir cadvisor
RUN cd cadvisor && wget https://github.com/google/cadvisor/releases/download/$PROMETHEUS_AGENT_CADVISOR_VERSION/cadvisor
RUN chmod u+x cadvisor/cadvisor

# Node_exporter
ENV PROMETHEUS_AGENT_NODE_EXPORTER=true
ENV PROMETHEUS_AGENT_NODE_EXPORTER_VERSION=0.13.0
ENV PROMETHEUS_AGENT_NODE_EXPORTER_PORT=8501
ENV PROMETHEUS_AGENT_NODE_METRICS_PATH="/node/metrics"
ENV PROMETHEUS_AGENT_NODE_EXPORTER_CMD="$PROMETHEUS_AGENT_HOME/agents/node_exporter/./node_exporter"
ENV PROMETHEUS_AGENT_NODE_EXPORTER_ARGS=""

RUN mkdir node_exporter
ENV NODE_EXPORTER_FILE=node_exporter-$PROMETHEUS_AGENT_NODE_EXPORTER_VERSION.linux-amd64
RUN wget https://github.com/prometheus/node_exporter/releases/download/v$PROMETHEUS_AGENT_NODE_EXPORTER_VERSION/$NODE_EXPORTER_FILE.tar.gz
RUN tar xvzf $NODE_EXPORTER_FILE.tar.gz -C node_exporter && mv node_exporter/$NODE_EXPORTER_FILE/* node_exporter
RUN rm $NODE_EXPORTER_FILE.tar.gz && rmdir node_exporter/$NODE_EXPORTER_FILE
RUN chmod u+x node_exporter/node_exporter

CMD $PROMETHEUS_AGENT_HOME/run.sh
