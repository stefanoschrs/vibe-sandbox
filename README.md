# vibe-sandbox

A Docker-based sandbox environment for vibe coding with AI CLI tools. Supports **Claude Code CLI** (Anthropic) and/or **OpenAI Codex CLI** — mount your project and credentials, and start coding.

## What's inside

- Ubuntu (latest)
- Node.js (LTS) + npm
- Go 1.25.4
- [Claude Code CLI](https://claude.ai/code) — `claude`
- [OpenAI Codex CLI](https://github.com/openai/codex) — `codex`

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- API credentials for the CLI(s) you intend to use:
  - **Claude Code**: `~/.claude/` directory (populated after running `claude login`)
  - **OpenAI Codex**: `~/.codex/auth.json`

---

## Build

```bash
docker build -t stefanoschrs/vibe-sandbox .
```

Or pull the pre-built image from Docker Hub:

```bash
docker pull stefanoschrs/vibe-sandbox
```

---

## Run

In all examples below `$(pwd)` is the project directory you want to work in. Change it to an absolute path if needed.

### Claude Code only

```bash
docker run -ti --rm \
  -v ~/.claude:/root/.claude \
  -v $(pwd):/app \
  -w /app \
  stefanoschrs/vibe-sandbox
```

Inside the container, run:

```bash
claude
```

### OpenAI Codex only

```bash
docker run -ti --rm \
  -v ~/.codex/auth.json:/root/.codex/auth.json \
  -v $(pwd):/app \
  -w /app \
  stefanoschrs/vibe-sandbox
```

Inside the container, run:

```bash
codex
```

### Both Claude Code and OpenAI Codex

```bash
docker run -ti --rm \
  -v ~/.claude:/root/.claude \
  -v ~/.codex/auth.json:/root/.codex/auth.json \
  -v $(pwd):/app \
  -w /app \
  stefanoschrs/vibe-sandbox
```

---

## First-time authentication

If you haven't authenticated yet, run the container without mounting credentials and log in interactively. The credentials will be stored inside the container (not persisted). Mount the credential paths on subsequent runs.

### Claude Code

```bash
docker run -ti --rm stefanoschrs/vibe-sandbox claude login
```

Then copy `~/.claude` out of the container, or use `docker cp`.

### OpenAI Codex

```bash
docker run -ti --rm stefanoschrs/vibe-sandbox codex login
```

Then copy `~/.codex/auth.json` out of the container.

---

## License

MIT
