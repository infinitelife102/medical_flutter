# Dr. AI - Smart Medical Assistant

A Flutter-based personal medical assistant app that combines AI consultation, hospital navigation, medical history management, and emergency support in one place.

---

## Overview

**Dr. AI** is designed to support both day-to-day health management and urgent situations with a fast, mobile-first experience.

- AI-powered medical Q&A (Gemini / ChatGPT API integration)
- Nearby hospital search and map-based navigation
- Firebase-based medical history storage and retrieval
- NFC-based medical data sharing
- Voice input and text-to-speech support

> This project is intended for educational and portfolio purposes and does not replace professional medical diagnosis.

---

## Key Features

### 1) AI Medical Assistant
- Ask symptom and health-related questions in natural language
- Store chat history locally with Hive
- Chat-first UX for quick interactions

### 2) Nearby Hospital Locator
- Discover nearby hospitals with Google Maps
- Get route and location assistance
- Designed for faster access during emergencies

### 3) Medical History Management
- Save and sync medical history with Firebase
- View and share records when needed
- Privacy controls for sensitive information

### 4) Emergency Support
- Quick emergency actions and support flows
- Minimal-step interactions for urgent scenarios

---

## Tech Stack

- **Framework**: Flutter (Dart 3.2+)
- **State Management**: BLoC (`bloc`, `flutter_bloc`)
- **Backend / Auth / DB**: Firebase (`firebase_core`, `firebase_auth`, `cloud_firestore`)
- **AI Integration**: `google_generative_ai` (+ external LLM APIs)
- **Maps / Location**: `google_maps_flutter`, `location`, `flutter_polyline_points`
- **Local Storage**: Hive (`hive`, `hive_flutter`)
- **Device Features**: NFC, Speech-to-Text, TTS, Share, File Open

---

## Screenshots

<div style="display: flex; justify-content: space-between;">
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/9ff86d3d-33aa-40aa-9145-c8d209ddf651" alt="Screenshot 1" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/f0a24cc8-4e15-4a91-9849-8b0160280fe5" alt="Screenshot 2" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/4d122648-32f2-409e-9adb-35d7aa611b23" alt="Screenshot 30" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/d539bc39-cc70-4e1b-a5c5-c3910cb44232" alt="Screenshot 3" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/d539bc39-cc70-4e1b-a5c5-c3910cb44232" alt="Screenshot 4" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/2b24fde5-43c1-448a-a52c-9b54a258edf3" alt="Screenshot 5" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/e02555d2-37b1-4ade-8d2d-0f841e2e0311" alt="Screenshot 6" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/89815d7d-aca8-46b5-bbbe-6f22dcc7a6ce" alt="Screenshot 7" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/4f1d82f9-ac77-405b-91f8-7ff87c164448" alt="Screenshot 8" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/137f65f0-9065-4b4e-8b1b-f3ec21a36b1b" alt="Screenshot 9" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/803447d9-1921-4216-9256-5b3b576c7cc2" alt="Screenshot 10" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/eef6081d-207a-4e8e-9a9e-f283be046739" alt="Screenshot 11" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/90835e2f-8e2a-4348-86a0-3df3dcf54888" alt="Screenshot 12" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/39179b28-5bcf-4869-b3df-8c79385eb12a" alt="Screenshot 13" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/eb668d8f-5cfa-495e-9eaf-da054a8d3ffa" alt="Screenshot 14" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/99ad0444-0210-4043-900e-aab34bab3112" alt="Screenshot 15" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/2e4b78ed-4228-495c-96fb-2c0e7c4f8dd5" alt="Screenshot 16" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/e54362e7-9acb-4b92-8c4d-7974a729f7be" alt="Screenshot 17" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/0a40d9a4-0fbd-443b-8215-5712555a1acc" alt="Screenshot 18" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/81387f33-b9fe-4225-bfcd-b74a15742893" alt="Screenshot 19" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/7e29406e-c350-4ac0-a7a6-a9037f1c3395" alt="Screenshot 20" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/9cf40dda-5dcf-474b-93cb-98522bb1a3e5" alt="Screenshot 21" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/3038caff-da2b-48fa-83fd-f4108fa23007" alt="Screenshot 21" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/1b0520d4-4494-48cd-8d34-4a1e14d25e92" alt="Screenshot 22" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/94343ba9-2b30-4968-ada6-bb0e3904bafe" alt="Screenshot 23" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/dd98c5f2-d1d6-4f21-ba95-0c302b35460b" alt="Screenshot 24" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/0bf3ec5f-54ad-4193-934d-2447abf389d7" alt="Screenshot 25" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/c2d1e8fa-9b75-4b0a-8a2b-679924878e56" alt="Screenshot 26" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/19226fcc-ab67-48af-a56a-fa968b7209c5" alt="Screenshot 27" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/e0700f4a-3952-4d50-9950-68f7dd0a6275" alt="Screenshot 28" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/5ede004d-dc5f-490f-bc2a-5f650caed50f" alt="Screenshot 29" style="width: 24%;"/>
  <img src="https://github.com/MAHMOUDELSAYED69/DR-AI/assets/133010029/8fa45935-e213-4c24-8c08-b0d6e43ad57a" alt="Screenshot 30" style="width: 24%;"/>
</div>

See repository assets for more screenshots.

---

## Getting Started

### 1. Clone

```bash
git clone https://github.com/infinitelife102/medical_flutter.git
cd medical_flutter
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment

Since `.env` is declared as an asset in `pubspec.yaml`, create a `.env` file in the project root.

Example:

```env
GEMINI_API_KEY=your_key_here
OPENAI_API_KEY=your_key_here
```

### 4. Firebase Setup

1. Create a Firebase project
2. Register Android/iOS apps
3. Add configuration files
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
4. Complete required Gradle/Xcode Firebase setup

### 5. Run

```bash
flutter run
```

---

## Project Structure

The project follows a standard Flutter architecture with separated UI/State/Service layers for maintainability.

- `lib/` - app source code
- `assets/images/` - image assets
- `assets/animations/` - animation assets
- `.env` - API keys and environment variables

---

## Development Notes

- Check your Flutter environment:
  ```bash
  flutter doctor
  ```
- Update packages:
  ```bash
  flutter pub upgrade --major-versions
  ```

---

## License

This project is licensed under the MIT License.
