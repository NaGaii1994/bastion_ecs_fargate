FROM amazonlinux:2

RUN yum update -y && \
    yum clean all

CMD ["sleep", "3600"]