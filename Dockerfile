FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common && apt-get install -y apache2

RUN add-apt-repository ppa:ondrej/php && apt-get update && apt-get install -y --no-install-recommends \
    php7.2 php7.2-cli php7.2-mysql php7.2-curl php7.2-mbstring php7.2-json php7.2-xml php7.2-zip \
    mysql-server \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
    tar vxfz ioncube_loaders_lin_*.tar.gz && \
    rm -f ioncube_loaders_lin_*.tar.gz

RUN echo "zend_extension=/ioncube/ioncube_loader_lin_7.2.so" > /etc/php/7.2/cli/php.ini.new && \
    cat /etc/php/7.2/cli/php.ini >> /etc/php/7.2/cli/php.ini.new && \
    mv /etc/php/7.2/cli/php.ini.new /etc/php/7.2/cli/php.ini && \
    echo "zend_extension=/ioncube/ioncube_loader_lin_7.2.so" > /etc/php/7.2/apache2/php.ini.new && \
    cat /etc/php/7.2/apache2/php.ini >> /etc/php/7.2/apache2/php.ini.new && \
    mv /etc/php/7.2/apache2/php.ini.new /etc/php/7.2/apache2/php.ini

COPY testrail-*.zip /
RUN cd /var/www/html && unzip -q /testrail-*.zip

COPY config.php /var/www/html/testrail/config.php
COPY testrail.sql /
COPY run.sh /

CMD /run.sh
