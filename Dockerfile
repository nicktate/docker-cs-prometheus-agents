FROM library/ubuntu:14.04

MAINTAINER ContainerShip Developers <developers@containership.io>

ENV NODE_VERSION 6.3.0

ENV PROMETHEUS_AGENT_HOME=/opt/prometheus/containership-agents
WORKDIR $PROMETHEUS_AGENT_HOME
COPY . .

RUN apt-get update && apt-get install -y git npm supervisor wget
RUN npm install -g n
RUN n $NODE_VERSION
RUN npm install

WORKDIR $PROMETHEUS_AGENT_HOME/agents

# CADVISOR
ENV PROM_AGENT_CADVISOR=true
ENV PROM_AGENT_CADVISOR_VERSION=v0.23.2
ENV PROM_AGENT_CADVISOR_PORT=8500
ENV PROM_AGENT_CADVISOR_CMD="sudo $PROMETHEUS_AGENT_HOME/agents/cadvisor/cadvisor"
ENV PROM_AGENT_CADVISOR_ARGS=""

RUN mkdir cadvisor
RUN cd cadvisor && wget https://github.com/google/cadvisor/releases/download/$PROM_AGENT_CADVISOR_VERSION/cadvisor
RUN chmod u+x cadvisor/cadvisor

# Node_exporter
ENV PROM_AGENT_NODE_EXPORTER=true
ENV PROM_AGENT_NODE_EXPORTER_VERSION=0.12.0
ENV PROM_AGENT_NODE_EXPORTER_PORT=8501
ENV PROM_AGENT_NODE_EXPORTER_CMD="$PROMETHEUS_AGENT_HOME/agents/node_exporter/./node_exporter"
ENV PROM_AGENT_NODE_EXPORTER_ARGS=""

RUN mkdir node_exporter
ENV NODE_EXPORTER_FILE=node_exporter-$PROM_AGENT_NODE_EXPORTER_VERSION.linux-amd64
RUN wget https://github.com/prometheus/node_exporter/releases/download/$PROM_AGENT_NODE_EXPORTER_VERSION/$NODE_EXPORTER_FILE.tar.gz
RUN tar xvzf $NODE_EXPORTER_FILE.tar.gz -C node_exporter && mv node_exporter/$NODE_EXPORTER_FILE/* node_exporter
RUN rm $NODE_EXPORTER_FILE.tar.gz && rmdir node_exporter/$NODE_EXPORTER_FILE
RUN chmod u+x node_exporter/node_exporter

CMD $PROMETHEUS_AGENT_HOME/run.sh
