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
        image: alpine/git # Any image with git will do
        args:
          - clone
          - https://github.com/spring-projects/spring-petclinic.git 
          - /home/coder/petclinic/ # Put it in the volume
        securityContext:
          runAsUser: 1000
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
        volumeMounts:
          - name: code-server-pv-claim
            mountPath: /home/coder/petclinic/
```

In my case I wanted to start out with my repo already pulled so our example has an init container spin up to pull down spring-petclinic. Any container with git will work, I used alpine/git. Only significant caveat is you want to ensure you use rhte right user id, in our case the coder user is UID 1000, so you can read and modify the repo you pull down. Modify this section to pull down whatever repo you want to work on.

## Sprucing it up

If you're going to be using it outside of a lab environment it's worth exposing it to the internet. You can change the service type to use a LoadBalancer or add an ingress, ideally one that handles TLS termination for you. Huge word of caution, it you send a username an password to an editor running with a shell enabled on your kubernetes cluster over an unencrypted, read http, connection you are inviting serious trouble. Code is a terrific editor with a ton of cool functionality that you absolutely do not want to provide to a malicious actor. Do not connect to, or send passwords to, any site that is offering an unencrypted connection. Code-server will use https, and any ingress can be configured to automatically maintain free TLS certificates with let's encrypt.
