# image2pdf — Image to PDF Converter

![image2pdf logo](./image2pdfLogo.png)

**image2pdf** is a fast, private, 100% client-side tool to convert, edit, redact, and merge images into PDFs directly in your web browser.

## Features

- **100% Client-Side & Private:** Images never leave your device. Works completely offline.
- **Drag & Drop:** Upload and reorder thumbnail cards natively.
- **Image Editor & Redaction:** Draw blackout boxes over sensitive information (IDs, addresses, faces), annotate freehand with the **pencil tool** (custom color & thickness), and adjust filters (brightness, contrast, B&W, sepia).
- **Branding:** `image2pdf` logo used as favicon, header logo and social-sharing image (Open Graph / Twitter). Optimized variants ship alongside the original: `image2pdfLogo-512.webp` (18 KB, header/favicon), `image2pdfLogo-512.png` (177 KB, OG/apple-touch) and `image2pdf-favicon-64.png` (5 KB).
- **Security-Texture Watermarks:** Continuous watermark lines (`CONFIDENTIAL·CONFIDENTIAL·…`) with no word or line gaps, rotated as a single block (0°, −30°, −45°) — like banknote/official-document security paper.
- **Single-Page Landing with Live Preview:** Hero section renders the document (image + watermark texture) on canvas in real time as controls change; two-column layout, light minimalist design.
- **Page Options:** Fit to image, A4, or US Letter in Portrait, Landscape, or Auto orientation with custom margins.
- **SEO & Discoverability:** Semantic HTML, canonical URL, Open Graph, JSON-LD structured data (WebApplication + FAQ rich results), `robots.txt` and `sitemap.xml`.
- **Bilingual:** Built-in language switcher (EN/ES) that translates the entire tool UI, plus guide, feature overview and FAQs in both languages. Preference saved in `localStorage`, `?lang=` URL param support and browser-language auto-detection.
- **Zero Build Step:** Plain HTML5, CSS3, and JavaScript with [`pdf-lib`](https://pdf-lib.js.org/).

## Quick Start

Open [`index.html`](./index.html) directly in any browser.

## Testing

Open [`test.html`](./test.html) in your browser to run the automated in-browser test suite.