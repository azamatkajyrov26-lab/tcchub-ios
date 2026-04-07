# TCC Hub · Design Assets

Brand and design asset bundle for the **TCC Hub LMS** iOS & iPadOS app.

## Brand

- **Product**: TCC Hub LMS — logistics training platform for TransCaspian Cargo partners and staff.
- **Tone**: Formal, editorial, confident. Think premium business publication, not consumer edtech.
- **Languages**: Russian (primary), Kazakh, English.
- **Audience**: Adult professionals in logistics/transport. Ages 22–55.

## Palette

| Role | Hex | Use |
|---|---|---|
| Navy | `#1B2A4A` | Primary brand, headings, hero backgrounds |
| Gold | `#C6A46D` | Accent, CTAs on dark, italic detail text |
| Ivory | `#FAF8F3` | Light surface, certificates |
| Ink  | `#0F172A` | Body text on light |

Full light/dark tokens: `tokens/colors.json`.

## Typography

- **Family**: Montserrat (variable, 300–900).
- Display: 900 weight, tight tracking (-0.8).
- Italic 300 gold eyebrows for editorial accents.
- Full scale: `tokens/typography.json`.

## Folder map

```
Design/
├── README.md                    ← this file
├── tokens/                      ← colors, typography, spacing, radius JSON
├── logo/                        ← SVG + rasterized PNG @1x/@2x/@3x
├── app-icon/                    ← 1024×1024 master + iPad variant
├── launch/                      ← launch logo + spec
├── illustrations/               ← onboarding, empty states, errors
├── badges/                      ← achievement SVGs
├── course-covers/               ← placeholder cover
├── certificate-template/        ← PDF template SVG + spec
└── copy/                        ← en/ru/kk JSON strings
```

## Usage in Xcode

1. Drag `tokens/` into the Xcode project, create a `Theme.swift` that reads these JSON files (or hand-convert to Swift enums).
2. Add all assets in `logo/`, `illustrations/`, `badges/` to `Assets.xcassets` as image sets with @1x/@2x/@3x slots where applicable.
3. Use `app-icon/AppIcon-1024.png` as the `AppIcon` 1024×1024 slot (iOS auto-generates smaller sizes from this).
4. Launch screen: see `launch/launch-spec.md`.
5. Localization: import the three `copy/*.json` files into your localization layer (or convert to `.strings`/`.stringsdict`).

## Design principles

1. **Editorial over playful** — prefer thin borders, serif-feeling italics, numbered sections.
2. **Gold is punctuation, not decoration** — use gold only for CTAs, accents, dividers, focus states.
3. **Navy dominates** — primary surfaces are navy; ivory/white is secondary.
4. **No emojis** — icon set is SF Symbols (system) for consistency with iOS.
5. **Dark mode is not inverted** — it's a separate theme; test both manually.
