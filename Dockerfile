FROM ubuntu
 
RUN apt-get update

#Runit
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server &&	mkdir -p /var/run/sshd && \
    echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat tree htop unzip sudo

#Thumbor Requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential python-dev python-pycurl python-pip
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python-numpy python-opencv webp libpng-dev libtiff-dev libjasper-dev libjpeg-dev

#Thumbor
RUN pip install thumbor==4.1.2

#OpenCV Engine
RUN pip install opencv-engine

#Configuration
ADD . /docker
RUN ln -s /docker/etc/thumbor.conf /etc/thumbor.conf

#Runit Automatically setup all services in the sv directory
RUN for dir in /docker/sv/*; do echo $dir; chmod +x $dir/run $dir/log/run; ln -s $dir /etc/service/; done

ENV HOME /root
WORKDIR /root
EXPOSE 22 8888
