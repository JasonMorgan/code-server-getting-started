# Building your code-server container

If you want to start running code server in your kubernetes cluster it's probably best to customize your container. If you're following along using this repo copy your ~/.vscode directory into the root, the .gitignore is already configure to ignore it, and be sure to modify the RUN command to install any dependencies your extensions have. In the example I install shellcheck and kubectl. I also had to do a chown inside the RUN block to give code-server, and it's default user coder, read permissions. This lets you keep a dev environment that matches your local instance. It also gets you past a weird [licensing restriction](https://github.com/cdr/code-server/blob/master/doc/FAQ.md#differences-compared-to-vs-code) with vscode extensions.

## Understanding our Example

```Dockerfile
FROM codercom/code-server
COPY .vscode /home/coder/.local/share/code-server
RUN curl -Lo shellcheck-v0.7.1.linux.aarch64.tar.xz https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.aarch64.tar.xz \
  && tar -xvf shellcheck-v0.7.1.linux.aarch64.tar.xz \
  && chmod +x shellcheck-v0.7.1/shellcheck && sudo mv shellcheck-v0.7.1/shellcheck /usr/local/bin/ \
  && rm -rf shellcheck* && sudo chown -R coder:coder /home/coder/.local/share/code-server \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
  && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
```

### FROM

We pull the coder/code-server image down and use it as our starting point.

### COPY

This is where we make it look like your local vscode instance. Copy your .vscode directory into the root of this repo, the gitignore is already prepped to ignore it. When you build the container it'll copy your extensions in so you code-server instance can use them.

### RUN

So when we make a docker image we want to minimize the number of layers we create in the container, which is why you see all the && statements in the dockerfile example. You need to use this section to install any other dependencies your extensions need. In my case that was shellcheck and kubectl. As of the time of this writing code-server was built on Ubuntu and apt-get works in case you need it for any installs.
