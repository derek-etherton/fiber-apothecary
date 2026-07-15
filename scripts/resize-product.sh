#!/usr/bin/env bash
# Turn one raw camera photo into the responsive image set used by the
# .product-photo cards in "The Collection" (css/style.css:180, aspect-ratio 4/5).
#
# Usage:
#   scripts/resize-product.sh images/raw/DSC08605.jpg amethyst-cigarette-holder
#
# Produces, in images/products/:
#   <slug>-480.webp  <slug>-480.jpg    (mobile 1x)
#   <slug>-900.webp  <slug>-900.jpg    (mobile 2x / desktop 1x)
#   <slug>-1400.webp <slug>-1400.jpg   (desktop 2x retina)
#
# Requires ffmpeg on PATH, or set FFMPEG=/path/to/ffmpeg.

set -euo pipefail

FFMPEG="${FFMPEG:-ffmpeg}"
SRC="${1:?usage: resize-product.sh <source-image> <product-slug>}"
SLUG="${2:?usage: resize-product.sh <source-image> <product-slug>}"
OUT_DIR="$(dirname "$0")/../images/products"
WIDTHS=(480 900 1400)

# crop to 4:5 (matches .product-photo aspect-ratio) centered, works for
# both portrait and landscape sources, then scale to each target width.
CROP="crop='min(iw,ih*4/5)':'min(ih,iw*5/4)':'(iw-min(iw,ih*4/5))/2':'(ih-min(ih,iw*5/4))/2'"

for W in "${WIDTHS[@]}"; do
  "$FFMPEG" -y -i "$SRC" -vf "${CROP},scale=${W}:-1" -q:v 82 \
    "${OUT_DIR}/${SLUG}-${W}.webp" -loglevel error
  "$FFMPEG" -y -i "$SRC" -vf "${CROP},scale=${W}:-1" -q:v 3 \
    "${OUT_DIR}/${SLUG}-${W}.jpg" -loglevel error
done

echo "Wrote ${OUT_DIR}/${SLUG}-{480,900,1400}.{webp,jpg}"
ls -la "${OUT_DIR}/${SLUG}"-*.{webp,jpg} 2>/dev/null
