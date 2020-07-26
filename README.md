# Getting started running code-server in Kubernetes

If you want to know more about the what and why checkout my blog post here. Long story short code-server is a tool that allows you to run vscode remotely. In this case we're going to run it directly in our kubernetes cluster so we can natively interact with our kubernetes environment.

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
