FROM alpine

VOLUME [ "/logi" ]

WORKDIR /app
COPY pluto.sh pluto.sh
RUN chmod +x pluto.sh

CMD [ "/app/pluto.sh" ]