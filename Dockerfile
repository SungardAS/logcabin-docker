FROM node:6-slim

ENV CONFD_VER 0.12.0-alpha3
ENV EC2_METADATA_VER 2.1.2

ADD VERSION .

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y \
    --no-install-recommends \
    git \
    unzip \
    # Clean up packages
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove -y \
    # Remove extraneous files
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/man/* \
    && rm -rf /usr/share/info/* \
    && rm -rf /var/cache/man/* \
    # Clean up tmp directory
    && rm -rf /tmp/* /var/tmp/*

ADD https://github.com/kelseyhightower/confd/releases/download/v$CONFD_VER/confd-$CONFD_VER-linux-amd64 /usr/local/bin/confd
ADD https://raw.githubusercontent.com/SungardAS/ec2-metadata/$EC2_METADATA_VER/ec2-metadata /usr/local/bin/ec2-metadata

ADD /scripts/* /scripts/
RUN chmod +x /scripts/*

RUN chmod +x /usr/local/bin/ec2-metadata \
    && chmod +x /usr/local/bin/confd \
    && mv /scripts/ec2-metadata-value /usr/local/bin/ec2-metadata-value

ADD src/src/ /opt/logcabin/
RUN useradd logcabin

RUN cd /opt/logcabin \
    && npm install \
    && chown -R logcabin /opt/logcabin

ADD /templates/*.toml /etc/confd/conf.d/
ADD /templates/*.tmpl /etc/confd/templates/

USER logcabin

WORKDIR /scripts

ENTRYPOINT ["/scripts/entry.sh"]

CMD ["run.sh"]

