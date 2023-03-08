FROM ubuntu:20.04 as ttyd-builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential cmake git libjson-c-dev libwebsockets-dev
RUN git clone https://github.com/tsl0922/ttyd.git
RUN mkdir -p  /ttyd/build
RUN cd /ttyd/build && cmake ..
RUN cd /ttyd/build &&  make && make install


FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y \
    openssh-server sudo libjson-c-dev libwebsockets-dev
COPY ./entrypoint.sh /var/lib/entrypoint.sh


COPY --from=ttyd-builder /usr/local/bin/ttyd /usr/bin/ttyd

RUN chmod +x /var/lib/entrypoint.sh
RUN chmod +x /usr/bin/ttyd
CMD /var/lib/entrypoint.sh
