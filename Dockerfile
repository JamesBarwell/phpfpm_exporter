FROM jaymedh/docker-mtail

COPY progs /etc/mtail
COPY init /init
COPY phpfpmlogger /phpfpmlogger

EXPOSE 9253

ENTRYPOINT [ "/init" ]
