# Certificate Template Spec

- Canvas: 1600 × 1131 (A4 landscape @ ~135 dpi)
- Colors: bg `#FAF8F3`, navy `#1B2A4A`, gold `#C6A46D`
- Font: Montserrat (900 display, 700 title, 600 italic, 500 meta)

## Placeholders
| Token | Description | Max chars |
|---|---|---|
| `{{STUDENT_NAME}}` | Full name | 60 |
| `{{COURSE_TITLE}}` | Course title | 80 |
| `{{CERT_ID}}` | Short verification ID | 12 |
| `{{ISSUE_DATE}}` | Localized date | 24 |
| `{{INSTRUCTOR_NAME}}` | Instructor full name | 40 |

## Rendering
- iOS generates PDF via PDFKit from this SVG after token substitution.
- Fallback: PNG@2x rasterized on device via `UIGraphicsImageRenderer`.
- QR code (optional) may be drawn at `(1420, 940)` 140×140 linking to `https://<host>/verify/{{CERT_ID}}`.
