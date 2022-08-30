FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y \
    openssh-server sudo
COPY ./entrypoint.sh /var/lib/entrypoint.sh
RUN chmod +x /var/lib/entrypoint.sh
CMD /var/lib/entrypoint.sh
