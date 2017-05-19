phpfpm_exporter
---

Exports metrics from PHP-FPM for Prometheus.


## How to use

Run as a docker container:

```
docker run -e PHPFPM_HOST=mywebserver barwell/phpfpm_exporter -d
```

Configure the container to point towards your PHP-FPM instance by setting the environment variables:
- PHPFPM_HOST: required, the host of the PHP-FPM instance
- PHPFPM_PORT: optional, the port of the PHP-FPM instance, defaults to 80
- PHPFPM_PATH: optional, the path to the PHP-FPM status page, defaults to "/status"
- METRICS_PORT: optional, the port to expose the metrics interface, defaults to 9253

The container will poll PHP-FPM on a 5 second interval, and expose the metrics at the path /metrics.

## PHP-FPM and webserver configuration

Please ensure that you set your PHP-FPM and webserver config to allow external access to the status page. In the PHP-FPM config, this is typically done by uncommenting the following line:

`pm.status_path = /status`

You may need to adjust your webserver config to allow access to this path.

## Testing

In the `test` directory, there is a script `run` which uses docker-compose to bring up a PHP-FPM webserver and an instance of this exporter. The exporter will bind to localhost 9253 and can be queried at `/metrics`.

## Example output

```
# TYPE phpfpm_start_since gauge
phpfpm_start_since{prog="phpfpm.mtail",instance="f206ebacdab4"} 369
# TYPE phpfpm_accepted_conn gauge
phpfpm_accepted_conn{prog="phpfpm.mtail",instance="f206ebacdab4"} 74
# TYPE phpfpm_listen_queue gauge
phpfpm_listen_queue{prog="phpfpm.mtail",instance="f206ebacdab4"} 0
# TYPE phpfpm_max_listen_queue gauge
phpfpm_max_listen_queue{prog="phpfpm.mtail",instance="f206ebacdab4"} 0
# TYPE phpfpm_listen_queue_len gauge
phpfpm_listen_queue_len{prog="phpfpm.mtail",instance="f206ebacdab4"} 0
# TYPE phpfpm_idle_processes gauge
phpfpm_idle_processes{prog="phpfpm.mtail",instance="f206ebacdab4"} 1
# TYPE phpfpm_active_processes gauge
phpfpm_active_processes{prog="phpfpm.mtail",instance="f206ebacdab4"} 1
# TYPE phpfpm_total_processes gauge
phpfpm_total_processes{prog="phpfpm.mtail",instance="f206ebacdab4"} 2
# TYPE phpfpm_max_active_processes gauge
phpfpm_max_active_processes{prog="phpfpm.mtail",instance="f206ebacdab4"} 1
# TYPE phpfpm_max_children_reached gauge
phpfpm_max_children_reached{prog="phpfpm.mtail",instance="f206ebacdab4"} 0
# TYPE phpfpm_slow_requests gauge
phpfpm_slow_requests{prog="phpfpm.mtail",instance="f206ebacdab4"} 0```
