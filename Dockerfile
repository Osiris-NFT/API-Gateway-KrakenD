FROM devopsfaith/krakend

COPY config/krakend.json /etc/krakend/krakend.json

EXPOSE 8080
