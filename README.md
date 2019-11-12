# Kubernetes (k8s) Wait For Container

To be used in an initContainer section of a Job to prevent the Job from starting before the 'compute' Pods are all running.

## Building

```
$ docker build -t jjhursey/k8s-waitfor:ppc64le -f Dockerfile .
```

## Running

```
$ docker pull jjhursey/k8s-waitfor
```