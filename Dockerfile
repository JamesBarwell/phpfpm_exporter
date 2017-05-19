FROM jaymedh/docker-mtail

COPY progs /etc/mtail
COPY init /init
COPY phpfpmlogger /phpfpmlogger

ENTRYPOINT [ "/init" ]
