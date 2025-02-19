FROM almalinux:9.5
LABEL maintainer="maxmilio@kiv.zcu.cz" \
      org.opencontainers.image.source="https://github.com/maxotta/kiv-dsa-vagrant-base-docker"

RUN yum -y update ;\
    yum clean all ;\
    yum -y install \
        net-tools \
        curl-minimal \
        procps-ng \
        less \
        mc

RUN yum -y install \
        openssh-server \
        openssh-clients \
        passwd \
        sudo; \
    yum clean all ;\
    mkdir /var/run/sshd ;\
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

RUN useradd --create-home -s /bin/bash vagrant ;\
    echo -e "vagrant\nvagrant" | (passwd --stdin vagrant) ;\
    echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant ;\
    chmod 440 /etc/sudoers.d/vagrant

RUN mkdir -p /home/vagrant/.ssh ;\
    chmod 700 /home/vagrant/.ssh
ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys ;\
    chown -R vagrant:vagrant /home/vagrant/.ssh

COPY dev-container-startup.sh /etc
RUN chmod a+x /etc/dev-container-startup.sh

ENTRYPOINT ["/etc/dev-container-startup.sh"]
