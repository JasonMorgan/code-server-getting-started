# Building your code-server container

If you want to start running code server in your kubernetes cluster it's probably best to customize your container. If you're following along using this repo copy your ~/.vscode directory into the root, the .gitignore is already configure to ignore it, and be sure to modify the RUN command to install any dependencies your extensions have. In the example I install shellcheck and kubectl. I also had to do a chown inside the RUN block to give code-server, and it's default user coder, read permissions. This lets you keep a dev environment that matches your local instance. It also gets you past a weird [licensing restriction](https://github.com/cdr/code-server/blob/master/doc/FAQ.md#differences-compared-to-vs-code) with vscode extensions.

## Understanding our Example

### FROM

We pull the coder/code-server image down and use it as our starting point.

### COPY

This is where we make it look like your local vscode instance. Copy your .vscode directory into the root of this repo, the gitignore is already prepped to ignore it. When you build the container it'll copy your extensions in so you code-server instance can use them.

### RUN

So when we make a docker image we want to minimize the number of layers we create in the container, which is why you see all the && statements in the dockerfile example. You need to use this section to install any other dependencies your extensions need. In my case that was shellcheck and kubectl. As of the time of this writing code-server was built on Ubuntu and apt-get works in case you need it for any installs.
