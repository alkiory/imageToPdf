# Image to PDF Converter

A fast, private, 100% client-side tool to convert, edit, redact, and merge images into PDFs directly in your web browser.

Developed by [Alkiory](https://alkiory.com).

## Features

- **100% Client-Side & Private:** Images never leave your device. Works completely offline.
- **Drag & Drop:** Upload and reorder thumbnail cards natively.
- **Image Editor & Redaction:** Draw blackout boxes over sensitive information (IDs, addresses, faces) and adjust filters (brightness, contrast, B&W, sepia).
- **Tiled Watermarks:** Stamp repeating diagonal watermarks across all pages.
- **Page Options:** Fit to image, A4, or US Letter in Portrait, Landscape, or Auto orientation with custom margins.
- **Zero Build Step:** Plain HTML5, CSS3, and JavaScript with [`pdf-lib`](https://pdf-lib.js.org/).

## Quick Start

Open [`index.html`](./index.html) directly in any browser.

## Deployment (GitHub Pages)

1. Push this repository to GitHub.
2. In your repo settings, go to **Pages** -> Source: **Deploy from a branch** -> Select `main` / `root`.
3. Done! The local `./pdf-lib.min.js` and `index.html` work immediately with zero build pipelines.

## Testing

Open [`test.html`](./test.html) in your browser to run the automated in-browser test suite.

## License

MIT
