FROM ubuntu:16.04

RUN apt-get update -y \ 
	&& apt-get upgrade -y \
	&& apt-get install -y nano dstat pv wget unzip bzip2 curl parallel jq nmap python-pip bc \
	&& apt-get clean

RUN pip install awscli

RUN wget https://github.com/openshift/origin/releases/download/v3.7.2/openshift-origin-client-tools-v3.7.2-282e43f-linux-64bit.tar.gz -O oc.tar \
  && tar -xf oc.tar

# OpenShift gives a random uid for the user and some programs (e.g. dstat) try to find a username from the /etc/passwd.
# Let user to fix it, but obviously this shouldn't be run outside OpenShift
RUN chmod ug+rw /etc/passwd \
 && echo 'echo "chipster:x:$(id -u):$(id -g)::/tmp:/bin/bash" >> /etc/passwd' > fix-username.bash
  	
USER 0	

CMD sleep inf