FROM alpine:3.24.1

COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh && /usr/local/bin/setup.sh

WORKDIR /root
ENV SHELL=/bin/zsh
ENTRYPOINT ["zsh"]
