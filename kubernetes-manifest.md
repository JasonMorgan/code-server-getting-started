# Build out a Manifest for code-server

In order to use code-server in a containerized environment there's a few things that we might want to look at. Namely, how will we handle storage and how are we going to get our code into the container.

## Persistent disks

```yaml
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: code-server-pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

If you want data to persist between sessions it's worth starting out with a persistent disk, that way you won't lose your work should your container get restarted. The example in the [manifest](code-server.yaml) assumes you have a default storage class defined. You can find more about storage classes [here](https://kubernetes.io/docs/concepts/storage/storage-classes/).

## Init Container

```yaml
    initContainers:
      # This container clones the desired git repo to the pvc volume.
      - name: git-clone
        image: my-docker-hub-username/code-server # Any image with git will do
        command:
          - bash
        args:
          - /home/coder/prep.sh # Run the prep script from our configmap
        volumeMounts:
          - name: code-server-pv-claim
            mountPath: /home/coder/
          - name: prep-script
            mountPath: /home/coder/prep.sh
            subPath: prep.sh
        env:
        - name: REPO
          value: https://github.com/spring-projects/spring-petclinic.git
```

In my case I wanted to start out with my repo already pulled so our example has an init container spin up to pull down spring-petclinic. In order to get my user set up right and the repo cloned on AWS I had to chown the persistent volume so I ended up using the code-server container itself to do the work.  Modify this section to pull down whatever repo you want to work on.

## Sprucing it up

If you're going to be using it outside of a lab environment it's worth exposing it to the internet. You can change the service type to use a LoadBalancer or add an ingress, ideally one that handles TLS termination for you. Huge word of caution, it you send a username an password to an editor running with a shell enabled on your kubernetes cluster over an unencrypted, and by that I mean http, connection you are inviting serious trouble. Code is a terrific editor with a ton of cool functionality that you absolutely do not want to provide to a malicious actor. Do not connect to, or send passwords to, any site that is offering an unencrypted connection. Code-server will use https, and any ingress can be configured to automatically maintain free TLS certificates with let's encrypt. I'm not going to cover setting up TLS in this guide but I do link to cert-mananger's docs in the [readme](README.md).
