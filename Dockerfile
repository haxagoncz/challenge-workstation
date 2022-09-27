FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y \
    openssh-server sudo
COPY ./entrypoint.sh /var/lib/entrypoint.sh
COPY ./bin/ttyd /usr/bin/ttyd
RUN chmod +x /var/lib/entrypoint.sh
RUN chmod +x /usr/bin/ttyd
CMD /var/lib/entrypoint.sh
