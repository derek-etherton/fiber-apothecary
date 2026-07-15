# Product images

## Workflow

1. In Affinity, crop the photo to a **4:5 aspect ratio** (matches `.product-photo{aspect-ratio:4/5}` in [css/style.css](../css/style.css)) and export at **2800×3500** (or 1400×1750 minimum — see [export notes](#export-notes)). Format doesn't matter (PNG or JPEG both fine, script recompresses anyway).
2. Save the export into `images/raw/bases/`, named after the product, e.g. `amethyst.png`. The filename (minus extension) becomes the slug used everywhere downstream — keep it short, lowercase, no spaces.
3. Run:
   ```
   scripts/build-products.sh
   ```
   This processes every image in `images/raw/bases/` and writes the responsive set to `images/products/`.
4. Reference the result in HTML:
   ```html
   <img class="product-photo" src="images/products/amethyst-900.webp"
     srcset="images/products/amethyst-480.webp 480w,
             images/products/amethyst-900.webp 900w,
             images/products/amethyst-1400.webp 1400w"
     sizes="(max-width:640px) 90vw, (max-width:900px) 45vw, 30vw"
     alt="Amethyst Cigarette Holder" loading="lazy">
   ```

To process a single file with a specific slug instead of batch-processing everything in `bases/`, use `scripts/resize-product.sh <source-image> <slug>` directly.

## Output

Each source photo becomes 6 files in `images/products/`:

| Width | Height | Covers |
|---|---|---|
| 480px | 600px | mobile 1x |
| 900px | 1125px | mobile 2x / desktop 1x |
| 1400px | 1750px | desktop 2x retina |

...at both `.webp` and `.jpg` (WebP is what gets used in `srcset`; the `.jpg` is kept as a manual fallback if ever needed — not currently wired into any `<picture>` tag since WebP support is effectively universal).

## Directories

- `images/raw/` — camera originals and Affinity working files (`.af`). Gitignored — too large to commit, back these up separately.
- `images/raw/bases/` — cropped, full-res exports staged for processing. Also under `images/raw/`, so gitignored.
- `images/products/` — final web-ready output. Committed to the repo; this is what the site actually loads.

## Export notes

- Crop to 4:5 **before** resizing, not after — keeps cropping consistent across all three output sizes.
- Export oversized (2800×3500) rather than exactly at target size (1400×1750) when possible — downsampling produces a sharper result than exporting 1:1.
- Convert to sRGB before export if Affinity is working in Adobe RGB, otherwise colors can shift in-browser.
- Strip EXIF/ICC metadata on export — it's dead weight on a product photo.
