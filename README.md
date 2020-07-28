# Getting started running code-server in Kubernetes

Get started running vscode in your kubernetes cluster with code-server. code-server is an open source project from the folks at coder.com that makes it easy to run and manage a cloud based vscode instance that you can connect to and operate remotely. This repo covers how to configure your own docker container to run vscode in kubernetes and how to deploy an instance that you can work with. While you can deploy code-server in a number of ways, including on a vm, in this case we're going to run it directly in our kubernetes cluster so we can natively interact with our kubernetes environment. This guide covers the basics of how to get up and running but I'll caution you right now we only lightly touch on setting up TLS. Do not deploy code-server in your cluster and expose it to the internet without an https connection. With that lets get started!

## What you'll need

* A kubernetes cluster
  * Can be docker-desktop, minikube, or kind
* kubectl
* docker

## Steps

* prepare your [code server container](docker-container.md)
* push it to your registry
  * `docker login` if required
  * `docker push <container-name>`
* [modify the kubernetes manifest](kubernetes-manifest.md)
* deploy your app
  * `kubectl apply -f code-server.yaml`
* port-forward
  * `kubectl port-forward svc/code-server 8080:80`

## Stretch goals

Setup an ingress and use https with cert-manager. If you're on AWS/GCP/Azure/DigitalOcean/etc, it's fairly straightforward to set up and configure an ingress that's compatible with cert-manager. After trying a few things I decided to go with nginx, they have a good, but slightly dated walkthrough [here](https://cert-manager.io/docs/tutorials/acme/ingress/). If you follow the tutorial try using the [ingress example](ingress.yaml) to get your instance up and running with TLS. Be sure to replace the relevant values to match your domain and obviously get cert-manager configured first.

## TL;DR

* Clone and cd into this repo
* Copy your .vscode directory here
  * `cp -R ~/.vscode .`
* Change the Dockerfile to install any dependencies required by your extensions
* build the image
  * `docker build -t my-docker-hub-username/code-server`
* push your image to dockerhub
  * `docker push my-docker-hub-username/code-server`
* update the code-server.yaml file
  * change the image name to match the value you used for docker build
  * probably change the repo being pulled by the init container
    * target whatever repo you want to work on
  * update the password
* Apply it to your kubernetes cluster
  * `kubectl apply -f code-server.yaml`
