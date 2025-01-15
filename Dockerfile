FROM python:3.10

ARG ENVIRONMENT=production

RUN useradd --create-home avraeservice
USER avraeservice
WORKDIR /home/avraeservice

COPY --chown=avraeservice:avraeservice requirements.txt .
RUN pip install --user --no-warn-script-location -r requirements.txt

COPY --chown=avraeservice:avraeservice . .

COPY --chown=avraeservice:avraeservice docker/config-${ENVIRONMENT}.py config.py

# Download AWS pubkey to connect to documentDB
RUN wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem

COPY --chown=avraeservice:avraeservice docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
