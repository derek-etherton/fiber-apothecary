#!/usr/bin/env bash
# Turn one raw camera photo into a responsive image set, cropped to a
# given aspect ratio (defaults to 4:5, the .product-photo cards in
# "The Collection", css/style.css).
#
# Usage:
#   scripts/resize-product.sh images/raw/DSC08605.jpg amethyst-cigarette-holder
#   scripts/resize-product.sh images/raw/DSC08668.jpg bench-1 16:11 images/process
#
# Produces, in OUT_DIR (default images/products/):
#   <slug>-480.webp  <slug>-480.jpg    (mobile 1x)
#   <slug>-900.webp  <slug>-900.jpg    (mobile 2x / desktop 1x)
#   <slug>-1400.webp <slug>-1400.jpg   (desktop 2x retina)
#
# Requires ffmpeg on PATH, or set FFMPEG=/path/to/ffmpeg.

set -euo pipefail

FFMPEG="${FFMPEG:-ffmpeg}"
SRC="${1:?usage: resize-product.sh <source-image> <slug> [aspect W:H] [out-dir]}"
SLUG="${2:?usage: resize-product.sh <source-image> <slug> [aspect W:H] [out-dir]}"
ASPECT="${3:-4:5}"
OUT_DIR="${4:-$(dirname "$0")/../images/products}"
WIDTHS=(480 900 1400)

ASPECT_W="${ASPECT%%:*}"
ASPECT_H="${ASPECT##*:}"

# crop to the given aspect ratio, centered, works for both portrait and
# landscape sources, then scale to each target width.
CROP="crop='min(iw,ih*${ASPECT_W}/${ASPECT_H})':'min(ih,iw*${ASPECT_H}/${ASPECT_W})':'(iw-min(iw,ih*${ASPECT_W}/${ASPECT_H}))/2':'(ih-min(ih,iw*${ASPECT_H}/${ASPECT_W}))/2'"

for W in "${WIDTHS[@]}"; do
  "$FFMPEG" -y -i "$SRC" -vf "${CROP},scale=${W}:-1" -q:v 82 \
    "${OUT_DIR}/${SLUG}-${W}.webp" -loglevel error
  "$FFMPEG" -y -i "$SRC" -vf "${CROP},scale=${W}:-1" -q:v 3 \
    "${OUT_DIR}/${SLUG}-${W}.jpg" -loglevel error
done

echo "Wrote ${OUT_DIR}/${SLUG}-{480,900,1400}.{webp,jpg}"
ls -la "${OUT_DIR}/${SLUG}"-*.{webp,jpg} 2>/dev/null
