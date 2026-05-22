# Trainer App (Coach Console)

Flutter app for **trainers** — chat with members, approve call requests, join video sessions.

| | |
|---|---|
| **Primary color** | `#E50914` |
| **Firebase project** | `gymapp-d73bc` |
| **Package** | `com.example.trainner_app` |

> Folder name is `trainner_app` (double “n”) — keep consistent in paths and Firebase console.

## Documentation

Full monorepo guide: **[../DOCUMENTATION.md](../DOCUMENTATION.md)**

Firebase setup: **[../FIREBASE_SETUP.md](../FIREBASE_SETUP.md)** · Android SHA-1: **[../ANDROID_FIREBASE_FIX.md](../ANDROID_FIREBASE_FIX.md)**

## Run

```bash
flutter pub get
flutter run
```

Self-contained — import `package:trainner_app/app_shared.dart` for services and models.

## Main screens

| Route | Purpose |
|-------|---------|
| `/login` | Mock login as Aarav |
| `/home` | Dashboard |
| `/chats` | Member DK chat |
| `/requests` | Approve/decline calls |
| `/members` | Member list |
| `/sessions` | History |

## Default chat with member

Login connects as `trainer_aarav`. Conversation ID with member DK:

`conv_member_dk_trainer_aarav`

Member must select **Aarav** as coach in Guru onboarding for Firestore sync to match.

## App-specific code

| Path | Role |
|------|------|
| `lib/main.dart` | Startup + providers |
| `lib/core/firebase_startup.dart` | Firestore probe (local copy for IDE) |
| `lib/features/` | UI screens |

Core code: **`lib/services`**, **`lib/models`**, **`lib/providers`**.
