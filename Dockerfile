FROM ubuntu:16.04

ENV COLLECTD_VER 5.5.1-1build2
ENV CONFD_VER 0.12.0-alpha3
ENV EC2_METADATA_VER 2.1.2

ADD VERSION .

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y \
    --no-install-recommends \
    libpython2.7 \
    python-setuptools \
    collectd=$COLLECTD_VER \
    curl \
    ca-certificates && \
    easy_install -U requests \
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
ADD https://raw.githubusercontent.com/awslabs/collectd-cloudwatch/master/src/setup.py /tmp/setup.py

ADD /collectd-elasticsearch/elasticsearch_collectd.py /opt/collectd-plugins/
ADD /scripts/* /scripts/
RUN chmod +x /scripts/*

RUN chmod +x /usr/local/bin/ec2-metadata \
    && chmod +x /usr/local/bin/confd \
    && mv /scripts/ec2-metadata-value /usr/local/bin/ec2-metadata-value \
    && mkdir /etc/collectd/plugin-cfgs \
    && (echo "1"; echo "1"; echo "1"; echo "1"; cat) | python /tmp/setup.py

ADD /templates/*.toml /etc/confd/conf.d/
ADD /templates/*.tmpl /etc/confd/templates/

WORKDIR /scripts

ENTRYPOINT ["/scripts/entry.sh"]

CMD ["run.sh"]

