#!/usr/bin/env bash
# Batch version of resize-product.sh: processes every image dropped in
# images/raw/bases/, using each filename (minus extension) as the slug.
#
# Usage:
#   scripts/build-products.sh
#
# e.g. images/raw/bases/amethyst.png -> images/products/amethyst-{480,900,1400}.webp/.jpg
#
# Requires ffmpeg on PATH, or set FFMPEG=/path/to/ffmpeg.

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
BASES_DIR="${SCRIPT_DIR}/../images/raw/bases"

shopt -s nullglob nocaseglob
FILES=("${BASES_DIR}"/*.png "${BASES_DIR}"/*.jpg "${BASES_DIR}"/*.jpeg)
shopt -u nullglob nocaseglob

if [ ${#FILES[@]} -eq 0 ]; then
  echo "No .png/.jpg/.jpeg files found in ${BASES_DIR}" >&2
  exit 1
fi

for SRC in "${FILES[@]}"; do
  BASENAME="$(basename "$SRC")"
  SLUG="${BASENAME%.*}"
  echo "== ${BASENAME} -> ${SLUG} =="
  "${SCRIPT_DIR}/resize-product.sh" "$SRC" "$SLUG"
done
