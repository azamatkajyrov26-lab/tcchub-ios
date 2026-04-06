# TCC HUB iOS Rebuild — Comprehensive Handoff Document

## 1. Project Overview

**TCC Hub** is a Django-based Learning Management System (LMS) platform for TransCaspian Cargo, a logistics company based in Atyrau, Kazakhstan. The platform provides professional development training in logistics and freight forwarding across three main course streams:

- **Logistics from Scratch (Beginner)** — 7-module intro course + final exam
- **Advanced Logistics** — 9-module advanced course for professionals
- **Specialized Tracks** — Career navigation, specialized skills

### Key Facts
- **Current Tech:** Django 5.1 backend (REST API), Moodle-like architecture
- **Users:** ~30+ student cohorts across multiple course streams
- **Languages:** Russian (RU), Kazakh (KK), English (EN)
- **Live URL:** https://tcchub.kz
- **User Roles:** 6 main roles (student, teacher, assistant, course_creator, manager, admin)
- **Purpose:** Deliver professional logistics training with certificates, badges, peer interaction, and progress tracking

---

## 2. Backend Architecture

### Tech Stack (Current)
| Component | Technology | Version |
|-----------|-----------|---------|
| Language | Python | 3.12 |
| Framework | Django | 5.1 |
| REST API | Django REST Framework | 3.15 |
| Auth | SimpleJWT (tokens) | 5.3+ |
| Database | PostgreSQL | 16 |
| Cache/Broker | Redis | 7 |
| Task Queue | Celery | 5.4 |
| PDF Generation | WeasyPrint | 62 |
| WSGI Server | Gunicorn | 22 |
| Reverse Proxy | Nginx | Alpine |

### Django Apps

#### Core LMS
| App | Purpose | Models |
|-----|---------|--------|
| `accounts` | Auth & profiles | CustomUser, UserProfile |
| `courses` | Catalog & enrollment | Category, Course, Enrollment, Section |
| `content` | Course materials | Activity, Resource, Folder, VideoProgress |
| `quizzes` | Assessment | Quiz, Question, Answer, QuizAttempt, QuizResponse |
| `assignments` | Submissions | Assignment, Submission, SubmissionFile |
| `grades` | Gradebook | GradeCategory, GradeItem, Grade |
| `forums` | Discussion | Forum, Discussion, Post |
| `messaging` | Direct messages | Conversation, Message, ContactRequest |
| `notifications` | Alerts | NotificationType, NotificationPreference, Notification |
| `certificates` | Certs | CertificateTemplate, IssuedCertificate |
| `badges` | Gamification | Badge, BadgeIssuance |
| `calendar` | Events | Event |
| `analytics` | Reporting | (queried from logs) |
| `landing` | Public page | HeroSection, Metric, Partner, Testimonial |

---

## 3. API Surface

Base URL: `/api/v1/` — JSON REST, JWT (SimpleJWT) auth.

### Auth
```
POST   /auth/login                 → access + refresh tokens
POST   /auth/register
POST   /auth/token/refresh/
POST   /auth/logout
POST   /auth/password-reset/
POST   /auth/password-reset/confirm/
POST   /auth/change-password/
```

### Users
```
GET    /accounts/users/me/
PATCH  /accounts/users/me/
POST   /accounts/users/me/avatar/
GET    /accounts/users/{id}/
```

### Courses
```
GET    /courses/                   ?page=&search=&category=
GET    /courses/{slug}/
POST   /courses/{slug}/enroll
GET    /courses/{slug}/progress
POST   /courses/{slug}/unenroll
GET    /courses/categories/
```

### Content / Activities
```
GET    /content/sections/{section_id}/activities/
GET    /content/activities/{id}/
POST   /content/activities/{id}/complete/
GET    /content/resources/{id}/
GET    /content/videos/{id}/progress/
PATCH  /content/videos/{id}/progress/
```

### Quizzes
```
GET    /quizzes/{id}/
GET    /quizzes/{id}/questions/
POST   /quizzes/{id}/attempts/
GET    /quizzes/{id}/attempts/
POST   /quizzes/{id}/attempts/{aid}/submit/
GET    /quizzes/{id}/attempts/{aid}/
```
Question types: `multiple_choice | true_false | short_answer | essay | matching`

### Assignments
```
GET    /assignments/{id}/
POST   /assignments/{id}/submissions/    (multipart/form-data)
GET    /assignments/{id}/submissions/{sid}/
```

### Grades
```
GET    /grades/my/
GET    /grades/courses/{cid}/users/{uid}/
```

### Forums
```
GET    /forums/
GET    /forums/{id}/discussions/
POST   /forums/{id}/discussions/
POST   /forums/{id}/discussions/{did}/posts/
```

### Messaging
```
GET    /messaging/conversations/
POST   /messaging/conversations/
GET    /messaging/conversations/{id}/
POST   /messaging/conversations/{id}/
PATCH  /messaging/conversations/{id}/read/
GET    /messaging/unread-count/
```

### Notifications
```
GET    /notifications/
PATCH  /notifications/{id}/read/
POST   /notifications/read-all/
GET    /notifications/unread-count/
GET    /notifications/preferences/
PATCH  /notifications/preferences/
```

### Certificates
```
GET    /certificates/                          (user's certs)
GET    /certificates/{id}/
GET    /certificates/{id}/download/            (PDF)
GET    /certificates/verify/{uuid}/            (public, no auth)
```

### Badges
```
GET    /badges/
GET    /badges/my/
```

### Calendar
```
GET    /calendar/events/?start_date=&end_date=&course=
```

### Analytics (teacher/admin)
```
GET    /analytics/courses/{cid}/
GET    /analytics/overview/
```

### Landing (public)
```
GET    /landing/hero/
GET    /landing/partners/
GET    /landing/testimonials/
GET    /landing/advantages/
GET    /landing/metrics/
```

OpenAPI: `/api/schema/`, Swagger: `/api/docs/`, ReDoc: `/api/redoc/`

---

## 4. Authentication

### Login Flow
1. `POST /api/v1/auth/login` with `{ "email": "...", "password": "..." }`
2. Response:
   ```json
   {
     "tokens": { "access": "<JWT>", "refresh": "<JWT>" },
     "user":  { "id": 1, "email": "...", "role": "student", ... }
   }
   ```
3. **iOS storage:** Keychain (NEVER UserDefaults).
4. **Refresh:** auto on 401 via `POST /auth/token/refresh/`.

### Tokens
- **Access:** 30 min
- **Refresh:** 7 days
- Refresh tokens are blacklisted on logout.

### Roles
`admin`, `manager`, `course_creator`, `teacher`, `assistant`, `student`, `guest`.

### Password rules
≥8 chars, digit, lowercase, uppercase, special.

---

## 5. Pages / Screens (Web → iOS mapping)

### Public
| Web | iOS Screen |
|---|---|
| `/` Landing | `LandingView` |
| `/login/` | `LoginView` |
| `/register/` | `SignUpView` |
| `/password-reset/` | `PasswordResetView` |
| `/certificates/verify/{uuid}/` | `CertificateVerifyView` |

### Authenticated
| Web | iOS Screen |
|---|---|
| `/dashboard/` | `DashboardView` |
| `/dashboard/courses/` | `CoursesListView` |
| `/dashboard/course/{slug}/` | `CourseDetailView` |
| `/dashboard/activity/{id}/` | `ActivityDetailView` (polymorphic) |
| `/dashboard/quiz/{id}/take/` | `QuizTakeView` |
| `/dashboard/quiz/{id}/results/` | `QuizResultsView` |
| `/dashboard/assignment/{id}/` | `AssignmentDetailView` |
| `/dashboard/grades/` | `GradeBookView` |
| `/dashboard/messages/` | `ConversationsListView` + `ChatThreadView` |
| `/dashboard/notifications/` | `NotificationsListView` |
| `/dashboard/profile/` | `ProfileView` + `EditProfileView` |
| `/dashboard/calendar/` | `CalendarView` |
| `/dashboard/certificates/` | `CertificateGalleryView` |

---

## 6. Design System

### Colors
| Role | Hex |
|---|---|
| Primary (Gold) | `#C6A46D` |
| Primary Hover | `#A38450` |
| Primary Light | `#D4B87E` |
| Navy (Dark) | `#1B2A4A` |
| Navy Light | `#2D4A7A` |
| Surface | `#FAFBFD` |
| Surface Alt | `#F3F4F8` |
| Border | `rgba(27,42,74,0.08)` |
| Text Main | `#1B2A4A` |
| Text Mid | `#3D5070` |
| Text Light | `#7A8BA8` |

### Typography
- **Family:** Montserrat (300–900)
- **Icons:** Material Icons Round → use **SF Symbols** on iOS

### Layout
- 8-pt spacing scale
- Generous corner radius (forms ~30pt, cards ~16pt)
- Subtle shadows on hover/press

### SwiftUI tokens (suggested `Theme.swift`)
```swift
enum Theme {
    enum Color {
        static let primary      = SwiftUI.Color(hex: 0xC6A46D)
        static let primaryHover = SwiftUI.Color(hex: 0xA38450)
        static let navy         = SwiftUI.Color(hex: 0x1B2A4A)
        static let navyLight    = SwiftUI.Color(hex: 0x2D4A7A)
        static let surface      = SwiftUI.Color(hex: 0xFAFBFD)
        static let surfaceAlt   = SwiftUI.Color(hex: 0xF3F4F8)
        static let textMid      = SwiftUI.Color(hex: 0x3D5070)
        static let textLight    = SwiftUI.Color(hex: 0x7A8BA8)
    }
    enum Radius {
        static let card: CGFloat = 16
        static let pill: CGFloat = 30
    }
}
```

---

## 7. Core User Flows

### Sign Up & First Login
1. User submits email/password/name/lang on `SignUpView`
2. `POST /auth/register` → tokens
3. Save in Keychain → navigate to dashboard

### Browse & Enroll
1. `CoursesListView` → `GET /courses/?page=1`
2. Tap card → `CourseDetailView` → `GET /courses/{slug}/`
3. Tap "Enroll" → `POST /courses/{slug}/enroll`

### Lesson & Progress
1. Select section → activities load
2. Tap activity:
   - **Resource/Folder:** show file/listing
   - **Video:** AVPlayer + resume from `videos/{id}/progress`
   - **Lesson:** render HTML
3. On done: `POST /content/activities/{id}/complete/`

### Take Quiz
1. `POST /quizzes/{id}/attempts/` → questions
2. Local autosave per answer
3. `POST /quizzes/{id}/attempts/{aid}/submit/` with `{ "answers": [...] }`
4. Show results screen

### Submit Assignment
1. `AssignmentDetailView` → file picker + text
2. `POST /assignments/{id}/submissions/` (multipart)
3. Push notification when graded

### Messaging
1. `ConversationsListView` → `GET /messaging/conversations/`
2. Tap → `ChatThreadView` → `GET /messaging/conversations/{id}/`
3. Send → `POST /messaging/conversations/{id}/`
4. **Until WS:** poll every 10s when on screen

### Earn Certificate
1. Course progress = 100% + final quiz passed
2. Backend auto-creates `IssuedCertificate`
3. iOS shows in `CertificateGalleryView`
4. Tap → preview PDF, share via `ShareLink`

---

## 8. Database Schema (key models)

### accounts.CustomUser
`id, username, email (unique), password, first_name, last_name, avatar, role, phone, city, country, timezone, language, is_active, date_joined`

### courses.Course
`id, title, slug, description, short_description, category(FK), cover_image, duration_hours, is_published, enrollment_type, max_students, format, created_by, timestamps`

### courses.Enrollment
`id, user(FK), course(FK), role, enrolled_at, completed_at, progress(0-100), is_active`  · unique(user, course)

### courses.Section
`id, course(FK), title, description, order, is_visible`

### content.Activity
`id, section(FK), activity_type(lesson|video|document|folder|resource|url|quiz|assignment|forum|glossary|h5p), title, description, order, is_visible, completion_type, due_date`

### quizzes.Quiz
`id, activity(O2O), time_limit, max_attempts, passing_grade, shuffle_questions, show_results`

### quizzes.Question
`id, quiz(FK), text, question_type, points, order, explanation`

### quizzes.Answer
`id, question(FK), text, is_correct, order`

### quizzes.QuizAttempt
`id, quiz(FK), user(FK), started_at, finished_at, score, attempt_number, state`

### quizzes.QuizResponse
`id, attempt(FK), question(FK), answer(FK), text_response, score, is_correct`  · unique(attempt, question)

### assignments.Assignment
`id, activity(O2O), max_score, allow_late, late_penalty, submission_types[], max_file_size, max_files`

### assignments.Submission
`id, assignment(FK), user(FK), submitted_at, status(draft|submitted|graded), grade, feedback, graded_by, graded_at`

### assignments.SubmissionFile
`id, submission(FK), file, original_name, uploaded_at`

### grades.Grade
`id, grade_item(FK), user(FK), grade, feedback, graded_by, timestamps`

### messaging.Conversation
`id, participants(M2M), timestamps`

### messaging.Message
`id, conversation(FK), sender(FK), content, created_at, is_read`

### notifications.Notification
`id, user(FK), notification_type(FK), title, message, is_read, created_at, link`

### certificates.IssuedCertificate
`id, template(FK), user(FK), course(FK), issued_at, certificate_number(uuid), pdf_file`

### badges.BadgeIssuance
`id, badge(FK), user(FK), issued_at, issued_by`

---

## 9. iOS Architecture Recommendations

### Stack
- **Min iOS:** 16.0 (NavigationStack, SwiftData optional)
- **UI:** SwiftUI 100%
- **Pattern:** MVVM + Combine (or async/await + `@Observable`)
- **Networking:** `URLSession` + small `APIClient` wrapper, JSON via `Codable`
- **Auth storage:** Keychain (`KeychainAccess` or hand-rolled)
- **Image cache:** `AsyncImage` + `URLCache` (or Kingfisher/Nuke)
- **Video:** `AVKit` / `AVPlayer`
- **PDF:** `PDFKit`
- **Persistence:** `SwiftData` for offline cache (courses, lessons, quiz drafts)
- **Push:** APNs via `UIApplicationDelegate`

### Folder layout
```
TCCHub/
├── App/                    # @main, AppDelegate, Root
├── Core/
│   ├── Network/            # APIClient, Endpoint, Interceptors
│   ├── Auth/               # AuthService, KeychainStore, JWT
│   ├── Storage/            # SwiftData models
│   └── Theme/              # Colors, Typography, Spacing
├── Features/
│   ├── Auth/               # Login, SignUp, Reset
│   ├── Dashboard/
│   ├── Courses/            # List, Detail, Activity, Quiz, Assignment
│   ├── Messaging/
│   ├── Notifications/
│   └── Profile/            # Profile, Grades, Certificates, Badges, Settings
├── Shared/
│   ├── Components/         # Button, Card, ProgressBar, EmptyState
│   ├── Modifiers/
│   └── Extensions/
└── Resources/
    ├── Assets.xcassets
    ├── Localizable/        # ru, kk, en
    └── Fonts/              # Montserrat
```

### Navigation
```
RootView
├── if !authed → AuthFlow (Login / SignUp)
└── if authed  → MainTabView
                 ├── Dashboard
                 ├── Courses
                 ├── Messages
                 ├── Notifications
                 └── Profile
```

---

## 10. Required Backend Additions

The Django REST API is mostly complete, but iOS will need:

1. **File download endpoints** (avoid HTML redirects)
   - `GET /api/v1/resources/{id}/download/`
   - `GET /api/v1/submissions/{id}/files/{fid}/download/`
2. **WebSocket for messaging** (optional v1, recommended v2)
   - `ws://.../ws/messages/{conversation_id}/` via Django Channels
3. **APNs push notifications**
   - `POST /api/v1/devices/register/` `{ "token": "...", "platform": "ios" }`
   - Backend sends pushes on new message / grade / certificate
4. **Stable file URLs** in JSON responses (`avatar_url`, `cover_image_url`, etc.) — already exists in serializers, just confirm.
5. **Refresh token rotation** (verify SimpleJWT setting `ROTATE_REFRESH_TOKENS=True`).

---

## 11. Roadmap

### Phase 1 — MVP (Auth + Courses)
- [ ] Project scaffold, Theme, APIClient, Keychain
- [ ] Login / SignUp / Password reset
- [ ] Dashboard (enrolled courses, deadlines)
- [ ] Courses list + detail
- [ ] Activity viewer: lesson + video + document
- [ ] Mark complete + progress
- [ ] Profile view

### Phase 2 — Assessment
- [ ] Quiz take flow (MC, T/F, short, essay)
- [ ] Quiz results
- [ ] Assignment view + submission (file picker)
- [ ] Gradebook

### Phase 3 — Social
- [ ] Messaging (poll-based)
- [ ] Notifications list + APNs registration
- [ ] Forums browse + post

### Phase 4 — Gamification & Polish
- [ ] Certificates gallery + PDF preview + share
- [ ] Badges
- [ ] Calendar
- [ ] Dark mode
- [ ] Localization (ru/kk/en)
- [ ] Offline cache via SwiftData
- [ ] Accessibility pass
- [ ] App Store assets + submission

---

## 12. Open Questions for Product

- Backend base URL for production iOS build? (assume `https://tcchub.kz/api/v1/` until told otherwise)
- Bundle identifier? (suggest `kz.tcchub.lms`)
- App Store Connect / Apple Developer account ready?
- APNs certificates / keys provisioned?
- Is sign-in-with-apple required for App Store review (it usually is if email/password sign-up exists)?

---

## 13. References

- Web source: `/home/azamat/tcchub` (Django 5.1)
- Live: https://tcchub.kz
- API docs: https://tcchub.kz/api/docs/
- Original Moodle analysis: `tcchub/ANALYSIS.md`
- Architecture: `tcchub/docs/ARCHITECTURE.md`
- API spec: `tcchub/docs/API.md`
- Deployment: `tcchub/docs/DEPLOYMENT.md`
