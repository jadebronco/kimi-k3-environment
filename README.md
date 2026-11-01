# Kimi K3 — Deployment Environment

A ready-to-run home for **Kimi K3**, Moonshot AI's open-weight flagship and the
top-ranked open model in the world right now: 2.8 trillion parameters
(Mixture-of-Experts, 896 experts, ~104B active per token), native vision, and a
1,048,576-token context window. Weights were published July 27, 2026.

- Weights: https://huggingface.co/moonshotai/Kimi-K3 (ungated, free download)
- Format: MXFP4 safetensors, 96 shards, **~1.56 TB** total
- License: Kimi K3 License (MIT-derived; a separate agreement with Moonshot is
  needed only for a Model-as-a-Service business over $20M/year revenue)
- This repo contains **no weights** — GitHub cannot host files of this size.
  It contains everything needed to fetch the weights and serve the model on
  hardware that can hold it.

## Quick start (on a suitable GPU host)

```bash
cp .env.example .env          # set MODEL_DIR, GPU counts; HF_TOKEN optional
./fetch.sh                    # downloads the weights from Hugging Face (~1.56 TB)
./serve.sh                    # serves an OpenAI-compatible API on :8000
# or, with Docker:
docker compose up -d
```

## What hardware it takes

K3 is a datacenter model. Moonshot recommends **supernode configurations with
64 or more accelerators** for production serving; community deployments have
run it on 16× NVIDIA H200. The weights alone need ~1.6 TB of fast storage and
roughly that much aggregate GPU memory in MXFP4. See [HARDWARE.md](HARDWARE.md)
for the full tier table, including the single-GPU fallback.

## Files

| File | Purpose |
|---|---|
| `fetch.sh` | Resumable download of the weights from Hugging Face |
| `serve.sh` | vLLM launch with tensor parallelism sized by `.env` |
| `docker-compose.yml` | Same serving stack, containerized (SGLang image, vLLM alternative noted) |
| `.env.example` | Every tunable: model id, dirs, GPU counts, context length, port |
| `HARDWARE.md` | What each class of machine can and cannot run |
| `.gitignore` | Keeps weights and caches out of git — they never belong here |

## Notes

- K3 always reasons; control depth per request with `reasoning_effort`
  (`low` / `high` / `max`, default `max`).
- NVIDIA publishes its own quantized checkpoint (`nvidia/Kimi-K3-NVFP4`) for
  Blackwell hosts — set `MODEL_ID` in `.env` to use it instead.
- The serving stack is vLLM by default; Moonshot also recommends SGLang and
  TokenSpeed. The compose file notes where to swap.
