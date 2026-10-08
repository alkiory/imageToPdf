# Changelog

All notable changes to **image2pdf** are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Readable footer watermark line**: when a watermark is set, the same text is drawn as a single centred line at the bottom of every page — larger (up to 5% of the shorter page edge, auto-shrunk to fit), dark gray at 60% opacity, and independent from the background pattern. Rendered identically in the live preview and in the exported PDF.

### Changed
- **Watermark pattern flows as a wave**: the background texture no longer reads as a rigid diagonal grid — every row now follows a sinusoidal baseline (amplitude ≈1.4× the font size, wavelength 0.6× the shorter page edge) drawn as short chords tilted to the curve's tangent, for an organic banknote-style flow. Measured on the exported PDF: perfect sine (correlation 1.0000), amplitude 20.7 pt, tangent rotation ±20°.
- **Smaller pattern text**: 4% → 2.5% of the shorter page edge (≈15 pt on A4), so the texture reads as small legible security text with the footer standing out above it.

### Fixed
- **Watermark texture is now truly continuous in the exported PDF**: the stamp grid was anchored to the page's bottom-left corner and laid out in unrotated page coordinates while each stamp was rotated on its own, which left the top third of every page (≈33% of the height) and diagonal bands completely free of watermark. The grid now lives in the rotated frame and is mapped around the page centre, so the texture is uniform corner to corner — measured ink coverage ≈39% with zero empty rows or columns at 0°, −30° and −45° (was 17–26% with a 273–279 px empty band).
- **No lanes between lines**: the row pitch went from 0.9× to 0.7× the font size (rows overlap slightly) and every row gets a golden-ratio horizontal phase, so neither line gaps nor word-space channels can line up vertically — previously 2–3 px white lanes appeared at 0°.
- **Live preview now matches the export**: the preview rendered the watermark text 33% larger than the PDF (a stray `×1.33` px conversion); it now uses the same pt→px scale, so what you see is what downloads.

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
- **English and Spanish now render the exact same page skeleton**: the Spanish SEO content shipped as only two blocks — the FAQ was nested inside the steps card (under an `<h3>`, so a gray card containing bordered boxes) and the features card came first, while English had three independent cards in the order steps → features → FAQ with `<h2>` headings. Both languages now use the same three-section structure, same order, same heading levels and the same 6 FAQ items (the “works on mobile/offline?” entry was missing in Spanish). Switching the language only swaps text — a DOM parity check over the visible element tree reports `STRUCTURE IDENTICAL` (221 nodes in both).
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
