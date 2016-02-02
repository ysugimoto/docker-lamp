FROM centos:centos6
MAINTAINER Yoshiaki Sugimoto <yoshiaki-sugimoto@rich.co.jp>

# install epel and basic middlewares
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm && \
    yum -y update --enablerepo=rpmforge,epel,remi,remi-php56 && \
    yum clean all && \
    yum -y install --enablerepo=remi,epel \
    git \
    openssh-server \
    openssh-clients \
    passwd \
    vim \
    wget \
    php56 \
    php56-php-mbstring \
    php56-php-gd \
    php56-php-mcrypt \
    php56-php-pdo \
    php56-php-mysql \
    php56-php-pecl-apc\
    php56-php-pecl-memcached \
    php56-php-fpm \
    memcached \
    ImageMagick \
    nginx \
    mysql-server && \
    yum clean all

RUN echo "root:root" | chpasswd

# Default Time Zone
RUN ln -sf /usr/share/zoneinfo/Japan /etc/localtime

# Create known_hosts
RUN mkdir /root/.ssh/ && \
    touch /root/.ssh/known_hosts && \
    echo -e "Host bitbucket.org\n\
    HostName bitbucket.org\n\
    User git\n\
    IdentityFile ~/.ssh/id_rsa\n\
    IdentitiesOnly yes\n\
    StrictHostKeyChecking no" >> /root/.ssh/config && \
    echo -e "Host github.com\n\
    HostName github.com\n\
    User git\n\
    IdentityFile ~/.ssh/id_rsa\n\
    IdentitiesOnly yes\n\
    StrictHostKeyChecking no" >> /root/.ssh/config

# setting japanese http://qiita.com/snaka/items/55fc351ef61c12bc09a5
RUN echo 'LANG="ja_JP.UTF-8"' > /etc/sysconfig/i18n && localedef -f UTF-8 -i ja_JP ja_JP

ADD files/php.ini /etc/php.ini
ADD files/default.conf /etc/nginx/conf.d/default.conf
ADD files/www.conf /opt/remi/php56/root/etc/php-fpm.d/www.conf
ADD files/nginx.conf /etc/nginx/nginx.conf
ADD files/my.cnf /etc/my.cnf
ADD scripts/start.sh /start.sh
ADD scripts/php56-php-fpm /etc/init.d/php56-php-fpm

RUN chmod +x /start.sh
RUN chmod +x /etc/init.d/php56-php-fpm

# Not Caching after this action
# https://github.com/docker/docker/issues/1996#issuecomment-51292997
# ADD http://www.sethcardoza.com/api/rest/tools/random_password_generator/complexity:alpha uuid
ADD http://www.random.org/strings/?num=10&len=8&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new uuid

# Port Expose : httpd zabbix_agentd
EXPOSE 80 3306
CMD ["/start.sh"]
