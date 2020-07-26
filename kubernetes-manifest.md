# Build out a Manifest for code-server

In order to use code-server in a containerized environment there's a few things that we might want to look at.

## Persistent disks

If you want data to persisten between sessions it's worth starting out with a persisten disk, that way you won't randomly lose your work should your container get restarted. The example in the [manifest](code-server.yaml) assumes you have a default storage class defined. You can find more about storage classes [here](https://kubernetes.io/docs/concepts/storage/storage-classes/).

## Init Container

In my case I wanted to start out with my repo already pulled so our example has an init container spin up to pull down spring-petclinic. You should modify it to pull down whatever repo you want to work on.

## Sprucing it up

If you're going to be using it outside of a lab envirnoment it's worth exposing it to the internet. You can change the service type to use a LoadBalancer or add an ingress, ideally one that handles TLS termination for you.
