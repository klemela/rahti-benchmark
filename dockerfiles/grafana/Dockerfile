FROM ubuntu:16.04

RUN apt-get update \
&& apt-get install -y apt-transport-https \
&& apt-get install -y software-properties-common wget \
&& wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - \
&& echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list \
&& apt-get update \
&& apt-get install -y grafana

RUN chmod -R a+rwx /var/lib
RUN chmod -R a+rwx /var/log

RUN echo [auth.anonymous] >> /usr/share/grafana/conf/custom.ini \
 && echo enabled = true >> /usr/share/grafana/conf/custom.ini \
 && chmod ugo+rwx /usr/share/grafana/conf/custom.ini

CMD cd /usr/share/grafana ; /usr/sbin/grafana-server