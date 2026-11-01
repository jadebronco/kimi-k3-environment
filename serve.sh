#!/usr/bin/env bash
# Serve Kimi K3 with vLLM (OpenAI-compatible API).
# K3 production serving wants a multi-node supernode (Moonshot recommends
# 64+ accelerators). TP_SIZE x GPU_COUNT_PER_NODE covers one node; for
# multi-node, run one worker per node with the vLLM ray/head flags from the
# Kimi K3 deployment recipes and the same model path on shared storage.
set -euo pipefail
cd "$(dirname "$0")"
[ -f .env ] && set -a && . ./.env && set +a

MODEL_DIR="${MODEL_DIR:-/data/models/kimi-k3}"
TP_SIZE="${TP_SIZE:-8}"
PORT="${PORT:-8000}"
MAX_MODEL_LEN="${MAX_MODEL_LEN:-1048576}"

python3 -m pip install -U vllm
exec vllm serve "$MODEL_DIR" \
  --tensor-parallel-size "$TP_SIZE" \
  --max-model-len "$MAX_MODEL_LEN" \
  --port "$PORT" \
  --served-model-name kimi-k3
