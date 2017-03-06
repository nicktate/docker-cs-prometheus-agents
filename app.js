'use strict';

const _ = require('lodash');
const fs = require('fs');
const path = require('path');
const spawn = require('child_process').spawn;

const agentsPath = path.resolve(__dirname, 'agents');
const supervisorConfigPath = path.resolve(__dirname, 'supervisord.conf');

const agents = _.filter(fs.readdirSync(agentsPath), (agent) => {
    const env_flag = `PROMETHEUS_AGENT_${_.toUpper(agent)}`;

    return 'true' === process.env[env_flag];
});

function generateSupervisorProgram(agent) {
    const cmd_env = process.env[`PROMETHEUS_AGENT_${_.toUpper(agent)}_CMD`];
    let cmd_args = process.env[`PROMETHEUS_AGENT_${_.toUpper(agent)}_ARGS`];

    if (!cmd_args) {
        switch (agent) {
            case 'cadvisor':
                cmd_args = `--port ${process.env.PROMETHEUS_AGENT_CADVISOR_PORT || 8500}`;
                cmd_args += ` --logtostderr`;
                break;
            case 'node_exporter':
                cmd_args = `--web.listen-address=0.0.0.0:${process.env.PROMETHEUS_AGENT_NODE_EXPORTER_PORT || 8501}`;
                break;
            default:
                console.warn(`Unknown agent type: ${agent}`);
                break;
        }
    }

    return `[program:${agent}]
command=${cmd_env} ${cmd_args}
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0

`   ;
}

const template = `
[supervisord]
nodaemon=true

[program:agentproxy]
command=node ${process.env.PROMETHEUS_AGENT_HOME}/agent-proxy.js
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0

${_.map(agents, agent => generateSupervisorProgram(agent)).join('')}`;
fs.writeFileSync(supervisorConfigPath, template);
