'use strict';

const express = require('express');
const request = require('request');

const app = new express();
const PORT = process.env.PORT || 3000;

app.get(process.env.PROMETHEUS_AGENT_CADVISOR_METRICS_PATH, (req, res, next) => {
    const url = `http://localhost:${process.env.PROMETHEUS_AGENT_CADVISOR_PORT}/metrics`;

    return req.pipe(request(url)).pipe(res);
});

app.get(process.env.PROMETHEUS_AGENT_NODE_METRICS_PATH, (req, res, next) => {
    const url = `http://localhost:${process.env.PROMETHEUS_AGENT_NODE_EXPORTER_PORT}/metrics`;

    return req.pipe(request(url)).pipe(res);
});

app.listen(PORT, () => {
    console.info(`Prometheus agent reverse proxy is listening on port ${PORT}`);
});
