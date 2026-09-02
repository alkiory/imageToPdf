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
2. **Client-Side Redaction & Editing:** When editing, the image is rendered onto an offscreen canvas. Users draw blackout rectangles to mask sensitive text. Redactions and color matrix adjustments are rendered to a JPEG canvas stream.
3. **Reordering & State Management:** Cards use native HTML5 drag events (`dragstart`, `dragover`, `drop`) to reorder the item array in memory.
4. **PDF Generation (`pdf-lib`):**
   - Direct embedding is used for unedited JPEGs and PNGs to preserve original fidelity and bypass re-encoding.
   - Rotated, filtered, or redacted images are processed through the Canvas 2D API.
   - Scaling calculations adjust image aspect ratios according to the chosen page size (Fit to Image, A4, US Letter) and margin settings.
   - If a watermark is requested, `StandardFonts.HelveticaBold` is stamped in a repeating diagonal grid across the entire page.
5. **Zero-Server Export:** The compiled byte array is wrapped in a `Blob`, attached to an ephemeral anchor tag, triggered for download, and cleaned up from memory via `URL.revokeObjectURL`.

---

## 4. Summary

By eliminating unnecessary backend infrastructure and frontend build chains, the entire application consists of **two static files** ([`index.html`](./index.html) and [`pdf-lib.min.js`](./pdf-lib.min.js)), offering infinite scalability, maximum privacy, and zero maintenance.
