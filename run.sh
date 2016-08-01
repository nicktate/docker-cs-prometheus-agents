#!/bin/bash

node $PROMETHEUS_AGENT_HOME/app.js
/usr/bin/supervisord -c $PROMETHEUS_AGENT_HOME/supervisord.conf
