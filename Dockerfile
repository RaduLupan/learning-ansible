FROM centos:centos7.7.1908

RUN  yum check-update; \
   yum install -y gcc libffi-devel python3 epel-release; \
   yum install -y openssh-clients; \
   yum clean all; \
   yum install -y sshpass; \
   yum install git -y; \
   yum install jq -y; \
   pip3 install --upgrade pip

RUN pip3 install "ansible==2.9.12"; \
   pip3 install boto3; \
   pip3 install boto; \
   pip3 install "pywinrm>=0.3.0"; \
   pip3 install ansible-lint