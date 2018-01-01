FROM golang:latest

LABEL Description="rpi filebeat image"

ADD ./filebeat /filebeat

RUN ["chown","-R","root:root","/filebeat"]

WORKDIR /filebeat

CMD ["./filebeat","-v","-e"]