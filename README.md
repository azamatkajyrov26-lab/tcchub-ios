# TCC Hub iOS

Native iOS SwiftUI client for the [TCC Hub LMS](https://tcchub.kz) — a Django-based learning platform for TransCaspian Cargo logistics training.

## Status

🚧 **Spec / handoff stage.** Source code will be added by the iOS implementation session running on macOS with Xcode.

## What's in this repo

- **[SPEC.md](SPEC.md)** — full architectural handoff: backend overview, REST API surface, auth, design system, screen-by-screen mapping, database schema, recommended SwiftUI architecture, and phased roadmap.

## Bootstrap on macOS (for the build session)

> Run these on the Mac (e.g. MacinCloud Dedicated Server with Xcode preinstalled).

### 1. Install tooling
```bash
# Homebrew (skip if already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Node + git + gh
brew install node git gh

# Claude Code
npm i -g @anthropic-ai/claude-code
```

### 2. Clone this repo
```bash
gh auth login        # one-time
git clone https://github.com/azamatkajyrov26-lab/tcchub-ios.git
cd tcchub-ios
```

### 3. Start Claude Code with the spec loaded
```bash
claude
```

Then in the Claude session say:

> Read SPEC.md. Scaffold a SwiftUI iOS 16+ project named **TCCHub** following the architecture in section 9. Bundle id `kz.tcchub.lms`. Use the API base URL `https://tcchub.kz/api/v1/`. Implement Phase 1 (Auth + Courses) end to end and open the project in Xcode when done.

The Mac Claude session will:
1. Generate the Xcode project (`xcodegen` or `swift package init`)
2. Add Theme, APIClient, KeychainStore
3. Build Auth + Dashboard + Courses screens
4. Run on the iOS Simulator for sanity checks

## API

Base URL: `https://tcchub.kz/api/v1/`
Auth: JWT (SimpleJWT) — access (30 min) + refresh (7 d)
OpenAPI: https://tcchub.kz/api/docs/

See [SPEC.md §3](SPEC.md#3-api-surface) for the full endpoint list.

## Design

- **Primary:** `#C6A46D` (gold)
- **Navy:** `#1B2A4A`
- **Surface:** `#FAFBFD`
- **Font:** Montserrat
- **Icons:** SF Symbols (replacing Material Icons from web)

See [SPEC.md §6](SPEC.md#6-design-system).

## Roadmap

| Phase | Scope |
|---|---|
| **1 — MVP** | Auth, Dashboard, Courses, Activities, Video |
| **2 — Assessment** | Quizzes, Assignments, Grades |
| **3 — Social** | Messaging, Notifications, Forums |
| **4 — Polish** | Certificates, Badges, Localization (ru/kk/en), Offline, Dark mode, App Store |

## License

Proprietary — © TransCaspian Cargo.
