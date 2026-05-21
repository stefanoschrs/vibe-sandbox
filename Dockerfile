FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/stefanoschrs/vibe-sandbox
LABEL org.opencontainers.image.description="A Docker-based sandbox environment for vibe coding with AI CLI tools. Supports Claude Code CLI (Anthropic) and/or OpenAI Codex CLI — mount your project and credentials, and start coding."
LABEL org.opencontainers.image.authors="Stefanos Chrs <root@stefanoschrs.com>"
LABEL org.opencontainers.image.licenses=MIT

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
    curl \
    git \
    ca-certificates \
    build-essential \
    gcc \
    wget \
    unzip \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# — Install Node.js (latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs
RUN node --version && npm --version

# — Install Golang
ENV GOLANG_VERSION=1.25.4
RUN wget https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && rm -rf /usr/local/go \
    && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz \
    && rm go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
RUN go version

# Invalidates cached CLI layers when CACHE_BUST changes (CI publish builds).
ARG CACHE_BUST
RUN echo "CLI cache bust: ${CACHE_BUST}"

# — Install Codex CLI (npm global)
RUN npm i -g @openai/codex

# — Install Claude Code CLI
RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/root/.local/bin:$PATH"

# — Install Cursor Agent CLI
RUN curl https://cursor.com/install -fsS | bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
