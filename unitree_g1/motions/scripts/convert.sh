#!/usr/bin/env bash
# Re-derive a G1 motion NPZ from an upstream LAFAN1-retargeted CSV.
#
# Usage:
#     ./convert.sh <hf_csv_relpath> <output_basename>
#
#     <hf_csv_relpath>   Path inside the lvhaidong/LAFAN1_Retargeting_Dataset
#                        HuggingFace dataset (e.g. `g1/dance1_subject2.csv`).
#     <output_basename>  Name written into wandb (also used as the local NPZ
#                        basename when this script copies it out of /tmp).
#
# Outputs `<output_basename>.npz` next to this script. The NPZ inherits the
# CC BY-NC-ND 4.0 license of the upstream LAFAN1 data — see ../LICENSE.NOTICE.
#
# Requires:
#   * curl
#   * a CUDA-capable GPU
#   * uv (https://github.com/astral-sh/uv) — the script invokes mjlab through it
#   * mjlab installed in the venv (`uv pip install mjlab`) OR an upstream clone
#     at $MJLAB_DIR (default: ../../../../mjlab).

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: $0 <hf_csv_relpath> <output_basename>" >&2
  echo "  e.g.: $0 g1/dance1_subject2.csv dance1_subject2" >&2
  exit 2
fi

CSV_REL="$1"
OUT_NAME="$2"

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MOTIONS_DIR="$(cd "$THIS_DIR/.." && pwd)"
WORK_DIR="$MOTIONS_DIR/lafan1_csv"
MJLAB_DIR="${MJLAB_DIR:-$MOTIONS_DIR/../../../../mjlab}"

mkdir -p "$WORK_DIR"
CSV_PATH="$WORK_DIR/$(basename "$CSV_REL")"

if [[ ! -f "$CSV_PATH" ]]; then
  echo "Downloading $CSV_REL from HuggingFace..." >&2
  curl -sL -o "$CSV_PATH" \
    "https://huggingface.co/datasets/lvhaidong/LAFAN1_Retargeting_Dataset/resolve/main/$CSV_REL"
fi

if [[ ! -d "$MJLAB_DIR" ]]; then
  echo "mjlab clone not found at $MJLAB_DIR" >&2
  echo "Set MJLAB_DIR or clone https://github.com/Mujoco-Lab/mjlab there." >&2
  exit 1
fi

echo "Running mjlab.scripts.csv_to_npz on $CSV_PATH..." >&2
(
  cd "$MJLAB_DIR"
  WANDB_MODE=disabled MUJOCO_GL=egl uv run -m mjlab.scripts.csv_to_npz \
    --input-file "$CSV_PATH" \
    --output-name "$OUT_NAME" \
    --input-fps 30 --output-fps 50
)

cp -v /tmp/motion.npz "$MOTIONS_DIR/$OUT_NAME.npz"
md5sum "$MOTIONS_DIR/$OUT_NAME.npz"
echo "Done. Update the matching AssetSpec md5 in genelab/asset_zoo/unitree_g1_motions.py."
