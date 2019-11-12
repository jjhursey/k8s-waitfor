#!/bin/bash

#
# Wait for the compute 'nodes'/Pods to startup.
#
# Useful in an initContainers section of a Job to prevent the Job from starting
# before the Pods are all running.
#

# (1) Number of servers to wait for
_TARGET_CNS=$1
# (2) Pod selector to wait for
_SELECTOR=$2
# (3) Cluster domain to wait for
_TARGET_CLUSTER=$3


#
# Verify all command line arguments
#
if [ "x" == "x$_TARGET_CNS" ] ; then
    echo "Error: Supply the number of servers to wait for."
    exit 0
fi

if [ "x" == "x$_SELECTOR" ] ; then
    echo "Error: Supply the selector string to wait for Ready."
    exit 0
fi

if [ "x" == "x$_TARGET_CLUSTER" ] ; then
    echo "Error: Supply the target cluster name to wait for."
    exit 0
fi


#
# Wait for Pods to get DNS entries
#
_ACTUAL_CNS=`nslookup $_TARGET_CLUSTER | grep Name | wc -l`
until [ $_TARGET_CNS == $_ACTUAL_CNS ] ; do
    echo "Waiting for Service: Target: $_TARGET_CNS / Actual: $_ACTUAL_CNS"
    sleep 1
    _ACTUAL_CNS=`nslookup $_TARGET_CLUSTER | grep Name | wc -l`
done

#
# Wait for Pods to enter the 'Ready' state
#
_ACTUAL_CNS=`/opt/mpi/bin/kubectl get pods -l $_SELECTOR | grep Running | wc -l`
until [ $_TARGET_CNS == $_ACTUAL_CNS ] ; do
    echo "Waiting for Ready: Target: $_TARGET_CNS / Actual: $_ACTUAL_CNS"
    sleep 1
    _ACTUAL_CNS=`/opt/mpi/bin/kubectl get pods -l $_SELECTOR | grep Running | wc -l`
done

# All done
echo "Compute Nodes are ready"
