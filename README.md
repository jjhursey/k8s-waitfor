# Kubernetes (k8s) Wait For Container

To be used in an initContainer section of a Job to prevent the Job from starting before the 'compute' Pods are all running.

 * Available on [DockerHub](https://hub.docker.com/r/jjhursey/k8s-waitfor)

## Building

Build with the default Kubernetes version (see Dockerfile):
```
$ docker build -t jjhursey/k8s-waitfor:ppc64le -f Dockerfile .
```

Build with a different Kubernetes version (`v1.16.0` in this case):
```
$ docker build -t jjhursey/k8s-waitfor:ppc64le --build-arg _K8S_VERSION=v1.16.0 -f Dockerfile .
```

## Running

```
$ docker pull jjhursey/k8s-waitfor
```

## Adding this to your Kubernetes Job

Requirements:
 * You need to define a Kubernetes [Headless Service](https://kubernetes.io/docs/concepts/services-networking/service/#headless-services) (or regular Service) with a domain for your pods.
 * Pods should have a unique selector defined.

```
apiVersion: batch/v1
kind: Job
...
      initContainers:
      - name: my-waiter
        imagePullPolicy: Always
        image: jjhursey/k8s-waitfor:ppc64le
        command: ["timeout"]
        # Arguments:
        #  (1) timeout length in seconds before re-cycling the initContainer
        #  (2) The program to run to wait for the pods
        #  (3) The number of pods to wait for
        #  (4) Selector to pass to "kubectl get pods -l" to pick the pods to to track to Running
        #  (5) Cluster domain defined by the headless service
        args: [
          "30",
          "/opt/mpi/bin/k8s-wait-for-pods.sh",
          "2",
          "parallelJob.name=my-job",
          "my-mpi-service"
        ]
```
