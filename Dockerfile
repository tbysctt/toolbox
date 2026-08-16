FROM alpine:3.24.1

COPY setup.sh /usr/local/bin/setup.sh
ARG TARGETARCH
RUN chmod +x /usr/local/bin/setup.sh && TARGETARCH="${TARGETARCH}" /usr/local/bin/setup.sh

WORKDIR /root
ENV SHELL=/bin/zsh
ENTRYPOINT ["zsh"]
