#!/usr/bin/env bash
# Uploads the site to S3 with browser cache settings, then clears the CloudFront cache.
# Usage: BUCKET=your-bucket-name DIST_ID=your-cloudfront-id ./deploy-s3.sh
set -euo pipefail
: "${BUCKET:?Set BUCKET to your S3 bucket name}"
: "${DIST_ID:?Set DIST_ID to your CloudFront distribution ID}"
cd "$(dirname "$0")"
SKIP=(--exclude "*.sh" --exclude "README.md" --exclude ".htaccess" --exclude ".DS_Store")

# Fonts and images: cached for 1 year. If you change an image, save it under a new file name.
aws s3 sync assets/fonts  "s3://$BUCKET/assets/fonts"  --delete --cache-control "public, max-age=31536000, immutable"
aws s3 sync assets/images "s3://$BUCKET/assets/images" --delete --cache-control "public, max-age=31536000, immutable"
aws s3 sync assets/icons  "s3://$BUCKET/assets/icons"  --delete --cache-control "public, max-age=31536000, immutable"

# CSS and JS: cached for 1 year. Pages load them with ?v=..., so a new version is fetched after each build.
aws s3 sync assets/css "s3://$BUCKET/assets/css" --delete --cache-control "public, max-age=31536000, immutable"
aws s3 sync assets/js  "s3://$BUCKET/assets/js"  --delete --cache-control "public, max-age=31536000, immutable"

# Pages, sitemap, robots and manifest: always checked for updates.
aws s3 sync . "s3://$BUCKET" --delete --exclude "assets/*" "${SKIP[@]}" --cache-control "public, max-age=0, must-revalidate"
aws s3 cp site.webmanifest "s3://$BUCKET/site.webmanifest" --content-type "application/manifest+json" --cache-control "public, max-age=86400"

aws cloudfront create-invalidation --distribution-id "$DIST_ID" --paths "/*" >/dev/null
echo "Done. CloudFront cache cleared."
