# Changelog

All notable changes to **image2pdf** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] — 2026-09-29

Big release: security-texture watermarks, a live-preview single-page landing, freehand pencil editing, bilingual UI with dark mode, and full SEO/branding work.

### Added
- **Continuous security-texture watermark** (`CONFIDENTIAL·CONFIDENTIAL·…`): words glued with a `·` separator and rows packed perpendicular to the text direction, rotated as a single block (0°, −30°, −45°) — no horizontal or vertical gaps, like banknote security paper. Selectable angle and color.
- **Live document preview (hero)**: canvas rendering of the final pages (image + redactions + strokes + watermark texture) that updates instantly on every control change — no save button, no reloads. Two-column single-page landing layout with a light, minimalist theme.
- **Freehand pencil tool** in the image editor: continuous lines (not dots) with custom color and 3–80 px thickness, smart undo, touch support; strokes survive rotation and are burned into the PDF.
- **Bilingual interface (EN/ES)**: in-page language switcher translating the whole tool UI via a `data-i18n` system; preference persisted in `localStorage`, `?lang=` URL param support and browser-language auto-detection.
- **Dark mode** with a 🌙/☀️ toggle: persisted, defaults to the system preference, full dark palette via CSS variables.
- **Secondary surface color** (`--surface-2`) so modals, cards and panels are visually distinct from the page background in both themes.
- **SEO foundation** (#08f0257): canonical URL, Open Graph/Twitter cards, JSON-LD structured data (`WebApplication` + `FAQPage`), `robots.txt` and `sitemap.xml`, plus code refactor for readability (#9d1fe20).
- **Bilingual informational content**: 3-step guide, feature grid and FAQs in English and Spanish (indexable static HTML).
- **Branding**: `image2pdf` logo as favicon, header logo and social-sharing image, with optimized variants (`image2pdfLogo-512.webp` 18 KB, `image2pdfLogo-512.png`, `image2pdf-favicon-64.png`).
- **Footer credit** stating the tool's purpose and authorship: developed by [Alkiory](https://alkiory.web.app).

### Changed
- Watermark rebuilt from a sparse tiled grid to the continuous texture (≈10× stamp density on A4).
- Header H1 and metadata now lead with the `image2pdf` brand for branded search queries.

### Fixed
- Pencil strokes previously collapsed to single dots; they now accumulate intermediate points while drawing.
- Watermark vertical gaps eliminated (row pitch compensates for the rotation angle).

## [1.0.0] — 2026-09-02

### Added
- Initial single-page application (#c549104): convert, merge and reorder images (JPG, PNG, WEBP, GIF, BMP, SVG) into PDFs entirely in the browser with [`pdf-lib`](https://pdf-lib.js.org/).
- 100% client-side privacy: no uploads, works offline.
- Image editor with blackout redaction boxes and brightness/contrast/grayscale/sepia filters.
- Page options: fit-to-image, A4, US Letter; portrait/landscape/auto; custom margins.
- Tiled watermark text option.
- Drag & drop ingestion with native HTML5 reordering; 90° rotation.
- Project documentation (#8941644).

[1.1.0]: https://github.com/alkiory/imageToPdf/compare/c549104...HEAD
[1.0.0]: https://github.com/alkiory/imageToPdf/releases/tag/v1.0.0
