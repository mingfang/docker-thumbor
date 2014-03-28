FROM ubuntu
 
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list && \
    apt-get update

#Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server &&	mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential python-dev python-pycurl python-pip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-numpy python-opencv webp libpng-dev libtiff-dev libjasper-dev libjpeg-dev
RUN pip install thumbor

#RUN git clone https://github.com/thumbor/thumbor.git

#RUN echo "deb http://ppa.launchpad.net/thumbor/ppa/ubuntu precise main" >> /etc/apt/sources.list.d/thumbor.list && \
#    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C6C3D73D1225313B && \
#    apt-get update
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes thumbor
RUN curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | python
#RUN sed -i 's/ALLOW_UNSAFE_URL = False/ALLOW_UNSAFE_URL = True/g' /etc/thumbor.conf

#Configuration
ADD . /docker

#Runit Automatically setup all services in the sv directory
RUN for dir in /docker/sv/*; do echo $dir; chmod +x $dir/run $dir/log/run; ln -s $dir /etc/service/; done

ENV HOME /root
WORKDIR /root
EXPOSE 22
