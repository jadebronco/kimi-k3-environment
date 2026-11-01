#!/usr/bin/env bash
# Download Kimi K3 weights from Hugging Face into $MODEL_DIR.
# Resumable: re-running picks up where a dropped transfer left off.
set -euo pipefail
cd "$(dirname "$0")"
[ -f .env ] && set -a && . ./.env && set +a

MODEL_ID="${MODEL_ID:-moonshotai/Kimi-K3}"
MODEL_DIR="${MODEL_DIR:-/data/models/kimi-k3}"

python3 -m pip install -U "huggingface_hub[cli]" hf_transfer
export HF_HUB_ENABLE_HF_TRANSFER=1
[ -n "${HF_TOKEN:-}" ] && huggingface-cli login --token "$HF_TOKEN" || true

echo "Downloading $MODEL_ID -> $MODEL_DIR  (~1.56 TB, 96 shards)"
huggingface-cli download "$MODEL_ID" --local-dir "$MODEL_DIR" --resume-download
echo "Done. Weights in $MODEL_DIR"
