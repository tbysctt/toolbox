FROM alpine:3.22.2

COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh && /usr/local/bin/setup.sh

WORKDIR /root
ENTRYPOINT ["zsh"]
