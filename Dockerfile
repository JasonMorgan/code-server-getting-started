FROM codercom/code-server
COPY .vscode /home/coder/.local/share/code-server
RUN curl -Lo shellcheck-v0.7.1.linux.aarch64.tar.xz https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.aarch64.tar.xz \
  && tar -xvf shellcheck-v0.7.1.linux.aarch64.tar.xz \
  && chmod +x shellcheck-v0.7.1/shellcheck && sudo mv shellcheck-v0.7.1/shellcheck /usr/local/bin/ \
  && rm -rf shellcheck* && sudo chown -R coder:coder /home/coder/.local/share/code-server \
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
  && chmod +x kubectl && sudo mv kubectl /usr/local/bin/ 
