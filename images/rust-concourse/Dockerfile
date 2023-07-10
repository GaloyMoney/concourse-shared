FROM rust

RUN rustc --version

RUN rustup component add rustfmt
RUN rustup component add clippy

RUN cargo install cargo-nextest cargo-deny cargo-audit typos-cli sqlx-cli handlebars-cli

# Install gcloud
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

RUN apt-get update && apt-get install -y \
  make git curl python3 jq rsync wget ca-certificates gnupg lsb-release gettext-base protobuf-compiler bc

ENV YQ_VERSION 4.31.1
RUN wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_386.tar.gz -O - |\
  tar xz && mv yq_linux_386 /usr/bin/yq

RUN apt-get remove -y docker docker.io runc
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
   && apt-get update \
   && apt-get install -y docker-ce docker-ce-cli containerd.io

ENV DOCKER_COMPOSE_VERSION 2.16.0
RUN mkdir -p /usr/local/lib/docker/cli-plugins \
  && curl -SL https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose \
  && chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

ENV GH_CLI_VERSION 2.31.0
RUN mkdir ghcli && cd ghcli \
  && wget https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_386.tar.gz -O ghcli.tar.gz \
  && tar --strip-components=1 -xf ghcli.tar.gz \
  && mv bin/gh /usr/local/bin && cd ../ && rm -rf ./ghcli

ENV BUF_VERSION 1.4.0
RUN wget https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-Linux-x86_64 -O buf \
  && chmod +x buf && mv buf /usr/local/bin
  
 RUN git clone https://github.com/bats-core/bats-core.git \
  && cd bats-core \
  && ./install.sh /usr/local

RUN wget -O ghtoken \
    https://raw.githubusercontent.com/Link-/gh-token/main/gh-token && \
    echo "6a6b111355432e08dd60ac0da148e489cdb0323a059ee8cbe624fd37bf2572ae  ghtoken" | \
    shasum -c - && \
    chmod u+x ./ghtoken && \
    mv ./ghtoken /usr/local/bin/ghtoken
