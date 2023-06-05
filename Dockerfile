FROM rust as rustbuild

RUN apt-get update
RUN apt-get install -y libpam0g-dev
RUN git clone https://github.com/coastalwhite/lemurs.git /lemurs
RUN cd /lemurs && cargo build --release
RUN sed -i 's/focus_behaviour = "default"/focus_behaviour = "username"/g' /lemurs/extra/config.toml
RUN sed -i 's/allow_shutdown = true/allow_shutdown = false/g' /lemurs/extra/config.toml
RUN sed -i 's/allow_reboot = true/allow_reboot = false/g' /lemurs/extra/config.toml


FROM ubuntu:jammy as ttyd-builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y build-essential cmake git libjson-c-dev libwebsockets-dev autoconf automake curl libtool make
RUN git clone https://github.com/tsl0922/ttyd.git
RUN cd /ttyd && env BUILD_TARGET=x86_64 ./scripts/cross-build.sh

FROM ubuntu:jammy

RUN apt-get update
RUN apt-get install -y \
    openssh-server sudo iproute2 libwebsockets-dev libpam0g-dev tini
COPY ./entrypoint.sh /var/lib/entrypoint.sh

COPY --from=ttyd-builder /ttyd/build/ttyd /usr/bin/ttyd

COPY --from=rustbuild /lemurs/target/release/lemurs /usr/sbin/lemurs
RUN mkdir /etc/lemurs
COPY --from=rustbuild /lemurs/extra/config.toml /etc/lemurs/config.toml

RUN chmod +x /var/lib/entrypoint.sh
RUN chmod +x /usr/bin/ttyd
RUN chmod +x /usr/sbin/lemurs
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD /var/lib/entrypoint.sh
