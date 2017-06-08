phpfpm_exporter
---

Exports metrics from PHP-FPM for Prometheus.


## How to use

Run as a docker container:

```
docker run -e PHPFPM_HOST=mywebserver barwell/phpfpm_exporter -d
```

Configure the container to point towards your PHP-FPM instance by setting the environment variables:
- PHPFPM_HOST: required, the PHP-FPM host
- PHPFPM_PORT: optional, the PHP-FPM status page port, defaults to 80
- PHPFPM_PATH: optional, the PHP-FPM status page path, defaults to "/status"
- METRICS_PORT: optional, the port to expose the metrics interface, defaults to 9253

The container will poll PHP-FPM on a 5 second interval, and expose the metrics at the path `/metrics`.

## PHP-FPM and webserver configuration

Please ensure that you set your PHP-FPM and webserver config to allow external access to the status page. In the PHP-FPM config, this is typically done by uncommenting the following line:

`pm.status_path = /status`

You may need to adjust your webserver config to allow access to this path. See the nginx example config below for a suggestion of how it may be configured.

## Scrape behaviour and troubleshooting

This exporter works by scraping the PHP-FPM status page, and as such is reliant on being able to access that page. If it cannot connect, it will set `phpfpm_up 0` and will reset the following metrics to `0` until it is next able to connect:
- listen_queue
- max_listen queue
- listen_queue_len
- idle_processes
- active_processes
- total_processes
- slow_requests

After scraping the PHP-FPM status page, the result is dumped into the logfile at `/var/log/phpfpm/current`. This logfile is watched by the `mtail` process and used to generate the metrics interface. If you encounter issues or unexpected metric values, please examine this logfile and check whether it is receiving the correct output. Log entries should look like this:

```
pool: www process manager: dynamic start time: 26/May/2017:07:11:29 +0000 start since: 10 accepted conn: 2 listen queue: 0 max listen queue: 0 listen queue len: 0 idle processes: 1 active processes: 1 total processes: 2 max active processes: 1 max children reached: 0 slow requests: 0
```


## Testing

In the `test` directory, there is a script `run` which uses docker-compose to bring up a PHP-FPM webserver and an instance of this exporter. The exporter will bind to `localhost:9253` and can be queried at `/metrics`.

## Example output

```
# TYPE phpfpm_up gauge
phpfpm_up{prog="phpfpm.mtail",instance="f206ebacdab4"} 1
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
phpfpm_slow_requests{prog="phpfpm.mtail",instance="f206ebacdab4"} 0
```

## Example nginx config

For security, I recommend blocking access to the PHP-FPM status page on your public listen port. Set up a separate listener on its own port (9001 in this case) to allow access to the PHP-FPM status page. You can then configure this exporter to access the status page via the dedicated port.

```
http {

    server {
        listen 80;
        server_name www.example.com;

        location ~ ^/status$ {
            deny all;
        }

        location / {
            try_files = $uri @php;
        }

        location @php {
          fastcgi_pass 127.0.0.1:9000;
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME $document_root/index.php;
          include fastcgi_params;
        }
    }

    server {
        listen 9001;
        server_name fpmstatus;

        access_log off;
        error_log off;

        location ~ ^/status$ {
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME /status;
            fastcgi_pass 127.0.0.1:9000;
        }
    }
}
```

## Licence

This project is available under the terms of the MIT licence. See the included licence agreement in this repository.


## Credits

This project relies on the following:

* [alpine](https://www.alpinelinux.org/)
* [mtail](https://github.com/google/mtail)
* [s6-overlay](https://github.com/just-containers/s6-overlay)
