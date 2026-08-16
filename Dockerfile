FROM alpine:3.24.1

COPY --chmod=755 setup.sh /usr/local/bin/setup.sh
RUN /usr/local/bin/setup.sh

WORKDIR /root
ENV SHELL=/bin/zsh
ENTRYPOINT ["zsh"]
