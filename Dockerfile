FROM centos:7

LABEL maintainer="Joshua Hursey"

# ------------------------------------------------------------
# Install required packages
#   bind-utils : For DNS query (dig, host, nslookup
# ------------------------------------------------------------
RUN yum -y update && \
    yum -y install \
    bind-utils wget && \
    yum clean all

# ------------------------------------------------------------
# Kubernetes support functionality
# kubectl     : kubectl binary (see get-kubectl.sh)
# kubexec.sh  : kubectl wrapper to use as the launch agent for mpirun
# k8s-wait-for-pods.sh : Script used to wait for Pods to become 'Ready'
# ------------------------------------------------------------
ARG _K8S_VERSION=v1.12.4
LABEL k8s.version=${_K8S_VERSION}

RUN mkdir -p /opt/mpi/bin /opt/mpi/src && \
    cd /opt/mpi/bin && \
    wget -q https://storage.googleapis.com/kubernetes-release/release/${_K8S_VERSION}/bin/linux/ppc64le/kubectl && \
    chmod +x ./kubectl
COPY k8s-bin/kubexec.sh \
     k8s-bin/k8s-wait-for-pods.sh \
     /opt/mpi/bin/
