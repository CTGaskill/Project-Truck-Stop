FROM apache/superset:GHA-12441231843
ARG SUPERSET_USERNAME
ARG SUPERSET_PASSWORD
ARG SUPERSET_FIRSTNAME
ARG SUPERSET_LASTNAME
ARG SUPERSET_EMAIL
ARG SUPERSET_SECRET_KEY

ENV SUPERSET_USERNAME=${SUPERSET_USERNAME}
ENV SUPERSET_PASSWORD=${SUPERSET_PASSWORD}
ENV SUPERSET_FIRSTNAME=${SUPERSET_FIRSTNAME}
ENV SUPERSET_LASTNAME=${SUPERSET_LASTNAME}
ENV SUPERSET_EMAIL=${SUPERSET_EMAIL}
ENV SUPERSET_SECRET_KEY=${SUPERSET_SECRET_KEY}

RUN superset fab create-admin --username $SUPERSET_USERNAME --password $SUPERSET_PASSWORD --email $SUPERSET_EMAIL --firstname $SUPERSET_FIRSTNAME --lastname $SUPERSET_LASTNAME
RUN superset db upgrade
RUN superset load_examples
RUN superset init

# Switching to root to install the required packages
USER root

# Copy Docker specific scripts
COPY docker/scripts/*.sh /app/docker/
RUN chmod +x /app/docker/*.sh

# Copy Docker specific config
# COPY --chown=superset:superset docker/pythonpath/superset_config.py /app/pythonpath/superset_config.py

# Switching back to using the `superset` user
USER superset