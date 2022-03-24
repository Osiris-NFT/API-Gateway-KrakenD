FROM alpine

# INSTALL DEPENDENCIES & CLONE KRAKEND SOURCE CODE
RUN apk fix ; \
    apk --update add git git-lfs less openssh && \
    cd /home ; \
    git clone https://github.com/devopsfaith/krakend-ce.git && \
    apk add --no-cache bash git openssh make cmake && \
    apk add --no-cache git make musl-dev go && \
    rm -rf /var/lib/apt/lists/* && \
    rm /var/cache/apk/* && \
    adduser -D -s /bin/ash runner

# BUILD THE BINARY
RUN cd /home/krakend-ce &&\
    make build

COPY /config/ /home/krakend/config/

# COPY THE BINARY FILE
RUN cp /home/krakend-ce/krakend /home/krakend/krakend ; \
    rm -r /home/krakend-ce/

RUN chown -R runner:runner /home/krakend/

EXPOSE 8080

USER runner

WORKDIR /home/krakend

ENTRYPOINT ["./krakend", "run", "-c", "config/krakend.json"]