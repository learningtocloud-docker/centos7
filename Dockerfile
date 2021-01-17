FROM centos:7
LABEL maintainer="Hans Hibelmann"

ENV container docker
# Install systemd -- See https://hub.docker.com/_/centos/
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Update packages and install dependencies
RUN yum makecache fast \
  && yum update -y \
  && yum clean all \
  && rm -rf /var/cache/yum

# Set locale
ARG LANGUAGE=en_US
ARG ENCODING=UTF-8
ENV LANG $LANGUAGE.$ENCODING
RUN localedef -i $LANGUAGE -c -f $ENCODING $LANG;

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
