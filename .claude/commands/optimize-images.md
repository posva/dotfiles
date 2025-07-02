# Optimize Images for Web

Optimize images for web usage by generating multiple responsive sizes in WebP format with JPEG fallbacks.

## Task

You will optimize the images specified in `$ARGUMENTS` for web delivery.

1. **Check Dependencies**: Verify that `cwebp` and `magick` (ImageMagick) are available
2. **Parse Arguments**: Handle image file paths and optional quality parameters. If none are provided, use default settings
3. **Generate WebP Variants**: Create multiple sizes (500w, 1000w, 1500w, 2000w) using `cwebp`
4. **Generate JPEG Fallback**: Create 1000w JPEG using `magick`
5. **Preserve Originals**: Keep original files as backup
6. **Report Results**: Show file size comparisons and optimization summary

## Tools

- Use `cwebp` with default quality settings (not lossless unless requested)
- Use `magick` with default quality settings for jpg conversion

### Command Examples

- Basic: `cwebp -resize WIDTH 0 input.ext -o output-WIDTH.webp`
- JPEG: `magick input.ext -resize WIDTHx output.jpg`
- Custom quality: Add `-q QUALITY` to cwebp or `-quality QUALITY` to magick only if user specifies

### Expected Output Files

For input `image.png`, generate:

- `image-500.webp`
- `image-1000.webp`
- `image-1500.webp`
- `image-2000.webp`
- `image.jpg` (1000w fallback)

