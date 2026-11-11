# Avyentra Technologies website

## Publish
Upload everything in this folder to the site's root folder, including `.htaccess`, `robots.txt`, `sitemap.xml` and `site.webmanifest`.

Google search setup after going live:
1. Add the site in Google Search Console and verify it.
2. Submit `https://avyentra.com/sitemap.xml`.
3. Request indexing for the home page.

If the domain is not `avyentra.com`, replace it in `index.html`, `robots.txt`, `sitemap.xml` and `.htaccess`.

## Editing
The live page loads two compact files:
- `assets/css/style.min.css`
- `assets/js/app.min.js`

The readable versions are in `assets/css` and `assets/js`. To edit them directly, replace these lines in `index.html`:

    <link rel="stylesheet" href="assets/css/style.min.css">
    <script src="assets/js/app.min.js" defer></script>

with:

    <link rel="stylesheet" href="assets/css/fonts.css">
    <link rel="stylesheet" href="assets/css/base.css">
    <link rel="stylesheet" href="assets/css/sections.css">
    <link rel="stylesheet" href="assets/css/animations.css">
    <link rel="stylesheet" href="assets/css/responsive.css">
    <script src="assets/js/testimonials-data.js" defer></script>
    <script src="assets/js/testimonials.js" defer></script>
    <script src="assets/js/services.js" defer></script>
    <script src="assets/js/animations.js" defer></script>
    <script src="assets/js/hero.js" defer></script>
    <script src="assets/js/main.js" defer></script>

Service pages are in the `services` folder. They use `contact.css`, `services.css` and `detail.css`. contact.html uses `contact.css` and `contact.js`, services.html uses `contact.css` and `services.css`, and the legal pages use `legal.css`.

The page runs slightly slower this way, so compact the files again before publishing.

Service tab text is in `index.html`. Testimonials are in `assets/js/testimonials-data.js`.

## Enquiry emails

Home and Contact forms post to the AWS Lambda URL set in the `enquiry-endpoint` meta tag of `index.html` and `contact.html`. Lambda sends the email through Amazon SES to business@avyentra.com. Setup files are in `Avyentra-Email-Setup.zip`, which must not be uploaded to the website bucket.

## Speed and caching

- Each page has its above-the-fold CSS inlined in a `<style data-crit>` block; the full CSS loads without blocking the page.
- CSS and JS links end in `?v=...`, a short hash of the file. After editing CSS or JS, rebuild the `.min` files and update the `?v=` values, so visitors get the new file.
- Upload with `deploy-s3.sh` (needs the AWS CLI). It sets Cache-Control on every file: 1 year for fonts, images, CSS and JS, and always-revalidate for HTML. A plain drag-and-drop upload to S3 does not set these headers.
- Images are cached for 1 year, so save a changed image under a new file name.
- In CloudFront, keep "Compress objects automatically" turned on.
