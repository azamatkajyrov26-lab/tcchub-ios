# TCC Hub iOS — Asset & Design Requirements

This document is the **contract** between the iOS app and the design/branding repo.
Another Claude Code agent (or a human designer) should read this and populate the design repo with everything listed below, in **exactly the paths and formats specified**.

Once the design repo is ready, the iOS agent will:
1. Copy / reference assets into `TCCHub/Resources/` and `TCCHub/Assets.xcassets/`.
2. Update `TCCHub/Core/Theme/Theme.swift` with the final design tokens.
3. Regenerate the Xcode project with XcodeGen and rebuild.

---

## 0. Deliverable structure (design repo)

Please organize the design repo exactly like this so the iOS agent can map files 1:1:

```
tcchub-design/
├── README.md                          # brand overview, usage rules
├── tokens/
│   ├── colors.json                    # see §2
│   ├── typography.json                # see §3
│   ├── spacing.json                   # see §4
│   └── radius.json                    # see §4
├── logo/
│   ├── logo-full.svg                  # horizontal wordmark
│   ├── logo-full-dark.svg             # for light backgrounds
│   ├── logo-full-light.svg            # for dark backgrounds
│   ├── logo-mark.svg                  # square glyph only (icon)
│   ├── logo-mark-dark.svg
│   ├── logo-mark-light.svg
│   └── png/                           # 1x/2x/3x raster exports
│       ├── logo-full@1x.png           # 240×64
│       ├── logo-full@2x.png           # 480×128
│       ├── logo-full@3x.png           # 720×192
│       ├── logo-mark@1x.png           # 64×64
│       ├── logo-mark@2x.png           # 128×128
│       └── logo-mark@3x.png           # 192×192
├── app-icon/
│   ├── AppIcon-1024.png               # 1024×1024, no alpha, no rounding, sRGB
│   ├── AppIcon-iPad-1024.png          # same, iPad variant (optional if identical)
│   └── source.sketch | .fig | .afdesign   # editable source
├── launch/
│   ├── launch-logo.svg                # centered on launch screen
│   ├── launch-background.png          # optional full-bleed background
│   └── launch-spec.md                 # color + positioning notes
├── fonts/
│   ├── Montserrat-Regular.ttf
│   ├── Montserrat-Medium.ttf
│   ├── Montserrat-SemiBold.ttf
│   ├── Montserrat-Bold.ttf
│   ├── Montserrat-Light.ttf
│   └── LICENSE.txt                    # SIL OFL
├── illustrations/                     # empty-state, onboarding, errors
│   ├── onboarding-1.svg
│   ├── onboarding-2.svg
│   ├── onboarding-3.svg
│   ├── empty-courses.svg
│   ├── empty-messages.svg
│   ├── empty-notifications.svg
│   ├── error-404.svg
│   ├── error-offline.svg
│   └── success-certificate.svg
├── course-covers/                     # fallback cover images
│   ├── cover-default.jpg              # 1200×800
│   ├── cover-logistics.jpg
│   ├── cover-advanced.jpg
│   ├── cover-customs.jpg
│   └── cover-placeholder.svg
├── badges/                            # achievement icons
│   ├── badge-first-course.svg
│   ├── badge-perfect-score.svg
│   ├── badge-streak-7.svg
│   └── ... (at least 6)
├── certificate-template/
│   ├── certificate-template.pdf       # A4 landscape
│   ├── certificate-template.svg
│   └── spec.md                        # name/date/signature coordinates
├── screenshots-reference/             # Figma exports for visual QA
│   ├── login.png
│   ├── signup.png
│   ├── dashboard.png
│   ├── courses-list.png
│   ├── course-detail.png
│   ├── activity-lesson.png
│   ├── activity-video.png
│   ├── activity-quiz.png
│   ├── profile.png
│   └── tablet/                        # iPad variants
│       ├── dashboard-ipad.png
│       └── course-detail-ipad.png
└── copy/
    ├── en.json                        # English strings
    ├── ru.json                        # Russian
    └── kk.json                        # Kazakh
```

---

## 1. Brand fundamentals

Please fill in the `README.md` of the design repo with:

- **Brand name** (final spelling/casing): `TCC Hub`? `TCCHub`? `TransCaspian Cargo Hub`?
- **One-line tagline** (en/ru/kk) — for launch screen + App Store
- **Brand voice** (formal? approachable? technical?)
- **Target audience note** (logistics professionals in Kazakhstan)
- **Do / Don't** rules for logo usage (clear space, min size, background contrast)

---

## 2. Color tokens — `tokens/colors.json`

Current placeholders from `SPEC.md` are the starting point. **Confirm or override each one.** Add semantic tokens (success, warning, error, info) and full dark-mode variants.

```json
{
  "brand": {
    "primary":        { "light": "#C6A46D", "dark": "#D4B87E" },
    "primaryHover":   { "light": "#A38450", "dark": "#E0C68F" },
    "primaryMuted":   { "light": "#F5EEDF", "dark": "#3A2F1E" },
    "navy":           { "light": "#1B2A4A", "dark": "#E6ECF5" },
    "navyLight":      { "light": "#2D4A7A", "dark": "#B8C4D8" }
  },
  "surface": {
    "background":     { "light": "#FAFBFD", "dark": "#0E1320" },
    "card":           { "light": "#FFFFFF", "dark": "#1A2133" },
    "elevated":       { "light": "#FFFFFF", "dark": "#242C42" },
    "alt":            { "light": "#F3F4F8", "dark": "#151B2A" }
  },
  "text": {
    "primary":        { "light": "#1B2A4A", "dark": "#F5F7FB" },
    "secondary":      { "light": "#3D5070", "dark": "#B8C4D8" },
    "tertiary":       { "light": "#7A8BA8", "dark": "#7A8BA8" },
    "onPrimary":      { "light": "#FFFFFF", "dark": "#0E1320" }
  },
  "border": {
    "default":        { "light": "rgba(27,42,74,0.08)", "dark": "rgba(255,255,255,0.08)" },
    "strong":         { "light": "rgba(27,42,74,0.16)", "dark": "rgba(255,255,255,0.16)" }
  },
  "semantic": {
    "success":        { "light": "#2E8B57", "dark": "#4CAF82" },
    "warning":        { "light": "#E0A020", "dark": "#F2B73A" },
    "error":          { "light": "#D9534F", "dark": "#FF6B6B" },
    "info":           { "light": "#4A90E2", "dark": "#6AA8EE" }
  },
  "gradient": {
    "hero":           ["#1B2A4A", "#C6A46D"],
    "card":           ["#FFFFFF", "#F3F4F8"]
  }
}
```

**Required:** every token must have both `light` and `dark` values. The iOS agent will generate SwiftUI `Color` extensions from this file.

---

## 3. Typography — `tokens/typography.json`

```json
{
  "family": {
    "primary": "Montserrat",
    "mono":    "SF Mono"
  },
  "weights": {
    "light": 300, "regular": 400, "medium": 500,
    "semibold": 600, "bold": 700
  },
  "styles": {
    "displayLarge":  { "size": 34, "weight": "bold",     "lineHeight": 41, "letterSpacing": -0.5 },
    "displayMedium": { "size": 28, "weight": "bold",     "lineHeight": 34, "letterSpacing": -0.3 },
    "title":         { "size": 22, "weight": "semibold", "lineHeight": 28, "letterSpacing": -0.2 },
    "headline":      { "size": 17, "weight": "semibold", "lineHeight": 22 },
    "body":          { "size": 15, "weight": "regular",  "lineHeight": 22 },
    "bodyEmphasis":  { "size": 15, "weight": "medium",   "lineHeight": 22 },
    "callout":       { "size": 14, "weight": "regular",  "lineHeight": 19 },
    "caption":       { "size": 12, "weight": "regular",  "lineHeight": 16 },
    "overline":      { "size": 11, "weight": "semibold", "lineHeight": 14, "letterSpacing": 1.0, "uppercase": true }
  }
}
```

**Confirm:** Is Montserrat the final choice? If a Cyrillic-friendly alternative is preferred for RU/KK (e.g. Manrope, Inter, Golos Text), specify it and include the TTFs under `fonts/`.

---

## 4. Spacing & radius — `tokens/spacing.json`, `tokens/radius.json`

```json
// spacing.json
{ "xs": 4, "s": 8, "m": 16, "l": 24, "xl": 32, "xxl": 48, "xxxl": 64 }

// radius.json
{ "none": 0, "sm": 8, "md": 12, "card": 16, "lg": 20, "pill": 30, "full": 9999 }
```

Confirm or override.

---

## 5. Logo — mandatory variants

The iOS agent needs **all** of these to handle every context:

| Variant               | Format  | Background use       | Where it appears              |
|-----------------------|---------|----------------------|-------------------------------|
| `logo-full.svg`       | vector  | neutral              | login, sign-up, splash        |
| `logo-full-dark.svg`  | vector  | on light background  | navigation bar, headers       |
| `logo-full-light.svg` | vector  | on dark background   | dark-mode header              |
| `logo-mark.svg`       | vector  | neutral              | avatar fallback, small chips  |
| `logo-mark-dark.svg`  | vector  | on light             | tab bar glyph                 |
| `logo-mark-light.svg` | vector  | on dark              | loading states, dark mode     |

**Constraints**
- SVG: no embedded raster images, no external fonts (convert text to outlines).
- PNG exports: transparent background, sRGB, 8-bit.
- Minimum clear space around the mark = the height of the "T" in the logo.
- Minimum render size = 24pt (mark) / 120pt (full).

---

## 6. App icon

- **Master file:** `AppIcon-1024.png`, 1024×1024, **sRGB, no alpha, no rounded corners** (iOS applies the squircle mask).
- Must be legible at **40×40** (Spotlight) and **29×29** (Settings).
- **Do not** put text smaller than ~60px on the 1024 canvas.
- Provide the editable source (`.sketch`, `.fig`, or `.afdesign`) so we can tweak if App Store Review rejects it.
- If the iPad icon should differ visually, provide `AppIcon-iPad-1024.png`.

The iOS agent will slice it into all required sizes via the asset catalog — **only the 1024 is required**.

---

## 7. Launch screen

iOS launch screens are a storyboard, not an image. Provide:

- `launch-logo.svg` — what appears centered
- Background color token (reference `colors.brand.navy` or `surface.background`)
- `launch-spec.md` describing:
  - Logo size (as a fraction of screen width, e.g. "40% of screen width, max 240pt")
  - Vertical alignment (center? 40% from top?)
  - Any tagline? If yes, which typography token?
  - Status bar style (light or dark content)

---

## 8. Illustrations

SVG, single-color or 2-color using brand palette. Style: flat, geometric, no photographic elements. Each illustration should have a **max bounding box of 512×512**.

Required set:
- `onboarding-1/2/3.svg` — 3 screens explaining: Learn · Track Progress · Earn Certificates
- `empty-courses.svg` — "No courses yet"
- `empty-messages.svg`
- `empty-notifications.svg`
- `error-404.svg`
- `error-offline.svg`
- `success-certificate.svg` — shown after course completion

---

## 9. Course cover images

Fallback visuals when the backend doesn't supply a cover:

- Format: **JPEG, 1200×800, sRGB, quality 85**
- `cover-default.jpg` — generic
- Optionally topic-specific covers (`cover-logistics.jpg`, etc.)
- `cover-placeholder.svg` — used while the JPEG loads

Style: abstract / thematic; avoid stock-photo clichés; must read well with a gold (`#C6A46D`) title overlay.

---

## 10. Badges

Achievement badge icons, SVG, 120×120 bounding box, single-color (gold) with optional navy accent.

At least 6 initial badges:
- First course completed
- Perfect quiz score
- 7-day learning streak
- 30-day streak
- First certificate earned
- Peer helper (forum contribution)

---

## 11. Certificate template

- **`certificate-template.pdf`** — A4 landscape (297×210mm), print-quality
- **`certificate-template.svg`** — same layout, for future dynamic rendering
- **`spec.md`** — coordinates (as % of canvas) for:
  - Recipient name
  - Course title
  - Issue date
  - Certificate number (UUID)
  - Signature line

---

## 12. Localization — `copy/en.json`, `copy/ru.json`, `copy/kk.json`

All user-facing strings. Keys should be **dot-namespaced** by feature:

```json
{
  "auth.login.title": "Sign in to continue learning",
  "auth.login.emailPlaceholder": "Email",
  "auth.login.passwordPlaceholder": "Password",
  "auth.login.submitButton": "Sign In",
  "auth.login.forgotPassword": "Forgot password?",
  "auth.login.noAccount": "New here?",
  "auth.login.createAccount": "Create account",
  "auth.signup.title": "Create account",
  "auth.signup.firstName": "First name",
  "auth.signup.lastName": "Last name",
  "auth.signup.submitButton": "Sign Up",
  "auth.errors.invalidCredentials": "Invalid email or password",
  "auth.errors.network": "Network error. Check your connection.",

  "dashboard.greeting": "Welcome back,",
  "dashboard.continueLearning": "Continue learning",
  "dashboard.continueLearningSubtitle": "Pick up where you left off",
  "dashboard.upcomingDeadlines": "Upcoming deadlines",
  "dashboard.noDeadlines": "No items due",
  "dashboard.progressCard": "Your progress",
  "dashboard.progressCardSubtitle": "Track certificates & badges",

  "courses.title": "Courses",
  "courses.empty": "No courses yet",
  "courses.loadError": "Couldn't load courses",
  "courses.retry": "Retry",

  "courseDetail.enroll": "Enroll",
  "courseDetail.enrolled": "Enrolled",
  "courseDetail.syllabus": "Syllabus",

  "activity.markComplete": "Mark as complete",
  "activity.completed": "Completed",
  "activity.quizPlaceholder": "Quiz — take it in Phase 3.",
  "activity.assignmentPlaceholder": "Assignment — submission coming in Phase 3.",

  "profile.grades": "Grades",
  "profile.certificates": "Certificates",
  "profile.badges": "Badges",
  "profile.calendar": "Calendar",
  "profile.logout": "Log out",

  "tabs.home": "Home",
  "tabs.courses": "Courses",
  "tabs.messages": "Messages",
  "tabs.alerts": "Alerts",
  "tabs.profile": "Profile",

  "common.retry": "Retry",
  "common.cancel": "Cancel",
  "common.save": "Save",
  "common.error": "Something went wrong"
}
```

Provide **all three languages** with **identical keys**. Leave a value empty only if the translation is genuinely pending (mark with `"__TODO__"`).

---

## 13. Screens to design (reference Figma exports)

Export each as a PNG into `screenshots-reference/`. The iOS agent will use these for visual QA — layouts should match **within 10% tolerance**.

**Phone (iPhone 16 Pro — 393×852):**
1. Splash / launch
2. Onboarding (3 screens)
3. Login
4. Sign up
5. Password reset
6. Dashboard (empty state + with-data state)
7. Courses list (empty + with-data)
8. Course detail (expanded sections)
9. Activity — lesson (text content)
10. Activity — video (with player)
11. Activity — quiz question
12. Activity — quiz results
13. Activity — assignment submit
14. Grades
15. Messages list
16. Chat thread
17. Notifications
18. Profile
19. Edit profile
20. Certificate gallery + PDF preview
21. Badges grid
22. Calendar
23. Settings
24. Error states (offline, 404, 500)

**Tablet (iPad Pro 13" — 1024×1366, landscape + portrait):**
1. Dashboard (sidebar + content split view)
2. Courses list → detail (two-column NavigationSplitView)
3. Activity viewer with collapsible section sidebar
4. Profile

### iPad layout rules

- Use `NavigationSplitView` with a **sidebar** listing primary tabs (Home/Courses/Messages/Alerts/Profile).
- Content should use **max-width columns** (~720pt) centered on wide screens — avoid edge-to-edge text.
- Forms and cards should grow to 2-column layouts where appropriate.
- Tab bar is **hidden** on iPad (replaced by sidebar).

Please annotate the Figma frames with any adaptive behavior (min/max widths, breakpoints).

---

## 14. Motion & micro-interaction notes

Add a short `motion.md` describing:
- Primary button press: scale to 0.97, 120ms ease-out
- Card tap: subtle shadow lift
- Screen transitions: default iOS push, or custom?
- Loading: skeleton shimmer or spinner? (prefer skeletons with navy-10% → surface-alt → navy-10% gradient)
- Success states: do you want haptic feedback? (`.success` notification haptic)

---

## 15. Accessibility requirements

- **Minimum contrast ratio 4.5:1** for all text against its background (both light & dark mode).
- All interactive targets **≥ 44×44pt**.
- Every illustration must have an accompanying `altText` field in the design repo so the iOS agent can set `.accessibilityLabel`.
- Support **Dynamic Type** — typography tokens should describe a base size; the iOS agent will scale using `@ScaledMetric`.

---

## 16. License & attribution

- Confirm Montserrat (or chosen font) license allows embedding in an iOS app (`SIL OFL` does — include `LICENSE.txt`).
- Any stock illustrations / icons must be either original or under a license compatible with App Store distribution — list them in `ATTRIBUTIONS.md`.

---

## 17. Hand-off checklist

When the design repo is ready, verify:

- [ ] `tokens/colors.json` has light + dark values for every token
- [ ] `tokens/typography.json` includes all styles in §3
- [ ] `fonts/` contains all Montserrat weights + LICENSE
- [ ] `logo/` has 6 SVG variants + PNG exports at 1x/2x/3x
- [ ] `app-icon/AppIcon-1024.png` is 1024×1024, sRGB, no alpha
- [ ] `launch/launch-logo.svg` + `launch-spec.md` present
- [ ] `illustrations/` has all 9 required SVGs
- [ ] `badges/` has at least 6 SVGs
- [ ] `course-covers/cover-default.jpg` exists
- [ ] `certificate-template/` has PDF + SVG + spec
- [ ] `copy/` has `en.json`, `ru.json`, `kk.json` with identical keys
- [ ] `screenshots-reference/` has all 24 phone screens + 4 iPad screens
- [ ] `README.md` documents brand name, tagline, voice, usage rules

---

## 18. What the iOS agent will do next

Once this design repo is populated and the URL is shared, the iOS agent will:

1. Clone the design repo as a sibling of `tcchub-ios`.
2. Copy fonts into `TCCHub/Resources/Fonts/` and register them in `Info.plist` (`UIAppFonts`).
3. Copy logos and illustrations into `TCCHub/Assets.xcassets/` as image sets with 1x/2x/3x slices.
4. Generate `TCCHub/Core/Theme/Colors.generated.swift` from `tokens/colors.json` (with light/dark `.init(light:dark:)` pairs).
5. Generate `TCCHub/Core/Theme/Typography.generated.swift` from `tokens/typography.json`.
6. Generate `TCCHub/Resources/Localization/{en,ru,kk}.lproj/Localizable.strings` from `copy/*.json`.
7. Replace the placeholder `AppIcon` and generate a proper launch storyboard.
8. Refactor views to use only the generated tokens — no more hard-coded hex values.
9. Add iPad `NavigationSplitView` variants and size-class-aware layouts.
10. Rebuild and hand back for visual QA against `screenshots-reference/`.

---

**End of requirements.** Any open questions or additions should be filed as GitHub issues on `tcchub-ios` with the label `design-handoff`.
