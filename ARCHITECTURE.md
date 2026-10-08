# Architecture & Design Decisions

## 1. Why We Built This App

Most online image-to-PDF tools suffer from fundamental flaws:
- **Privacy Risks:** Users are forced to upload sensitive documents (passports, tax forms, IDs, personal photos) to third-party remote servers.
- **Latency & Bandwidth Bottlenecks:** Uploading and downloading megabytes of image data across the network is slow.
- **Hosting & Maintenance Costs:** Server-based conversion requires backend servers, disk cleanup cron jobs to purge temporary uploads, and container infrastructure.

**Our Goal:** Build an instant, zero-latency, 100% private image-to-PDF converter, editor, and redaction tool that runs completely in the user's browser without uploading a single byte to any server.

---

## 2. Pre-Build Decisions (The Ponytail Simplification)

Before writing code, we audited the initial proposed multi-tier architecture (FastAPI + Docker + Preact + `react-dropzone` + `dnd-kit` + Tailwind) against the **Ponytail ladder**:

| Proposed Component | Ponytail Decision | Rationale |
| :--- | :--- | :--- |
| **FastAPI Backend + Uvicorn** | **Eliminated** | Processing files in-memory in the browser eliminates server costs, latency, network transfer, and server-side data leaks. |
| **Temp Storage & Cleanup Daemons** | **Eliminated** | Browser RAM handles byte streams natively without disk I/O or race conditions. |
| **Docker & Cloud Hosting** | **Eliminated** | The static app can be hosted on GitHub Pages or run locally via `file:///` for $0/mo. |
| **Preact + Dropzone + DnD-Kit** | **Replaced with Native HTML5** | `<input type="file" multiple>`, `<label for="...">`, and native HTML5 Drag & Drop API (`draggable`, `dragover`, `drop`) replaced 200MB+ of `node_modules`. |
| **Tailwind & Build Bundlers** | **Replaced with Vanilla CSS** | Modern CSS variables, flexbox, and grid eliminate build pipelines (`npm run build`, Vite, Webpack). |
| **Node/Jest Test Runner** | **Replaced with In-Browser Runner** | [`test.html`](./test.html) validates PDF generation, ordering, watermarks, and canvas filters directly in any browser with zero host dependencies. |

---

## 3. Application Workflow

```
[User Drop / Picker] ──> [URL.createObjectURL] ──> [Interactive Thumbnail Grid]
                                                             │
                  ┌──────────────────────────────────────────┴──────────────────────────────────────────┐
                  ▼                                                                                     ▼
    [Edit & Redact Modal]                                                                   [Reorder / Sort / Rotate]
    • HTML5 2D Canvas                                                                       • HTML5 Drag & Drop
    • Pixel blackout boxes (IDs, faces)                                                     • Array splice reordering
    • Brightness, contrast, B&W filters                                                     • 90° rotation transforms
                  │                                                                                     │
                  └──────────────────────────────────────────┬──────────────────────────────────────────┘
                                                             ▼
                                                [PDF Compilation (pdf-lib)]
                                                • Direct lossless embedding (JPG/PNG)
                                                • Canvas render fallback (WebP/SVG/Rotated)
                                                • Page size & margin scaling (Fit / A4 / Letter)
                                                • Tiled repeating watermark grid
                                                             │
                                                             ▼
                                                    [Instant Download]
                                                • In-memory Blob URL
                                                • Trigger download & revoke URL
```

### Detailed Pipeline

1. **Ingestion:** Native file input and drag-and-drop events read selected `File` objects and assign random IDs and lightweight object URLs.
2. **Client-Side Redaction & Editing:** When editing, the image is rendered onto an offscreen canvas. Users draw blackout rectangles to mask sensitive text or switch to the freehand **pencil tool** (custom color and thickness) to write, sign or highlight. Redactions, pencil strokes and color matrix adjustments are rendered to a JPEG canvas stream.
3. **Reordering & State Management:** Cards use native HTML5 drag events (`dragstart`, `dragover`, `drop`) to reorder the item array in memory.
4. **PDF Generation (`pdf-lib`):**
   - Direct embedding is used for unedited JPEGs and PNGs to preserve original fidelity and bypass re-encoding.
   - Rotated, filtered, or redacted images are processed through the Canvas 2D API.
   - Scaling calculations adjust image aspect ratios according to the chosen page size (Fit to Image, A4, US Letter) and margin settings.
   - If a watermark is requested, a **continuous WAVY security texture** is stamped across the entire page: the text is repeated as one unbroken line (`TEXT·TEXT·TEXT·…`, words glued with a `·` separator so there are no horizontal gaps) and every row follows a sinusoidal baseline (amplitude ≈1.4× the font size, wavelength = 0.6× the shorter page edge, drawn as 6 rotated chords per wavelength, each chord tilted to the tangent of the curve), so the pattern reads as an organic wave instead of a rigid grid. Rows are packed perpendicular to the text direction at ~0.7× the font size (they overlap slightly, so no empty lane can open between lines) and every row is offset by a golden-ratio phase so word spaces never align into vertical lanes. The whole block is rotated as a single piece (0°, −30° or −45°) around the page center and over-scanned by the page diagonal so corners are always covered. Pattern text is small (2.5% of the shorter page edge) and drawn at 13% opacity.
   - **Footer watermark line**: when a watermark is set, the same text is also drawn as a single readable line — larger (up to 5% of the shorter page edge, shrunk to fit the page width), dark gray at 60% opacity, centred at the bottom. It is *not* part of the wave pattern.
   - The same texture and footer run in a **live canvas preview** in the hero section (pt→px scaled), so what the user sees is exactly what gets exported.
6. **Discoverability:** The page ships semantic HTML, a canonical URL, Open Graph/Twitter meta, JSON-LD structured data (`WebApplication` + `FAQPage` for rich results), plus `robots.txt` and `sitemap.xml` at the site root. Below the tool, bilingual (EN/ES) how-to steps, feature cards and FAQs give first-time users clear guidance and search engines indexable content.
7. **Internationalization:** A lightweight `data-i18n` attribute system translates the entire tool UI between English and Spanish via a single in-page dictionary (`applyLang`). The static bilingual SEO sections stay server-rendered in the HTML (crawlable in both languages) and are toggled with a `body[lang]` CSS rule. Preference persists in `localStorage`, is overridable with `?lang=es|en`, and defaults to the browser language.
8. **Single-Page Landing (SPA-style):** Everything lives in one `index.html` — no routes, no reloads. A two-column hero stacks the live document preview (canvas, sticky on desktop) next to the controls column (dropzone, options, gallery, actions); changes re-render the preview instantly via input events. Informational SEO sections and the footer follow vertically in the same view.
5. **Zero-Server Export:** The compiled byte array is wrapped in a `Blob`, attached to an ephemeral anchor tag, triggered for download, and cleaned up from memory via `URL.revokeObjectURL`.

---

## 4. Summary

By eliminating unnecessary backend infrastructure and frontend build chains, the entire application consists of **two static files** ([`index.html`](./index.html) and [`pdf-lib.min.js`](./pdf-lib.min.js)) plus SEO support files (`robots.txt`, `sitemap.xml`), offering infinite scalability, maximum privacy, and zero maintenance.
