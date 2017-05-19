phpfpm_exporter
---

This container will connect to your PHP-FPM server, retrieve its status and make it available to Prometheus.


## How to use

Configure the container to point towards your PHP-FPM instance by setting the environment variables:
- PHPFPM_HOST: required, the hostname of the PHP-FPM instance
- PHPFPM_PORT: optional, the port of the PHP-FPM instance, defaults to 80
- PHPFPM_PATH: optional, the path to the PHP-FPM status page, defaults to /status
- METRICS_PORT: optional, the port to expose the metrics interface, defaults to 9253

The container will poll PHP-FPM on a 5 second interval, and expose the metrics at the path /metrics.

## PHP-FPM and webserver configuration

Please ensure that you set your PHP-FPM and webserver config to allow external access to the status page. In the PHP-FPM config, this is typically done by uncommenting the following line:

`pm.status_path = /status`

You may need to adjust your webserver config to allow access to this path.

## Testing

In this project's test directory, there is a script `run` which uses docker-compose to bring up a PHP-FPM webserver and an instance of this exporter. The exporter will bind to localhost 9253 and can be queried at /metrics.
