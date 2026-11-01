# Hardware — what can run what

## Kimi K3 (this repo's target)

| Requirement | Figure |
|---|---|
| Weights on disk | ~1.56 TB (MXFP4, 96 shards) |
| GPU memory to serve | ~1.6 TB aggregate, minimum |
| Moonshot's recommendation | Supernode, 64+ accelerators |
| Smallest reported community run | 16× NVIDIA H200 |
| Download cost | $0 — weights are free; budget the bandwidth and the iron |

There is no consumer-hardware path. Not a gaming PC, not a Mac Studio, not a
multi-GPU workstation.

## Single-GPU fallback: Qwen3.8-27B

The strongest open model that fits on **one** GPU (Apache 2.0, 27B dense,
262K native context). Its FP8 build runs on a single RTX 5090 (~27 GB).
To aim this same environment at it: set `MODEL_ID=Qwen/Qwen3.8-27B` and
`TP_SIZE=1` in `.env`, and lower `MAX_MODEL_LEN` to 262144.

## This repo's origin machine (for the record)

Prepared on a small cloud VM: 4 CPU cores, 7.7 GB RAM, no GPU, 166 GB free
disk. It can hold this environment and orchestrate a deployment — it cannot
itself store or run K3, or even the 27B fallback. The environment is built so
that any suitable GPU host can pick it up and go.
