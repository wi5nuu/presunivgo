# 🌊 PresUnivGo — High-Fidelity Professional Networking for President University

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State-Riverpod-blueviolet?style=for-the-badge)](https://riverpod.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-teal.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**PresUnivGo** is a premium, cross-platform professional networking solution engineered specifically for the **President University** ecosystem. This project demonstrates the implementation of modern mobile development paradigms, including **Clean Architecture**, **Reactive State Management**, and **Serverless Infrastructure**.

🚀 **Live Deployment:** [https://puconnect-9e8fb.web.app](https://puconnect-9e8fb.web.app)

---

## 🎨 Premium Design System

The application features a bespoke design system centered around a **"Dark Teal & Cream"** palette, optimized for professional aesthetics and high-readability.

- **Wave UI Design**: Implements custom `Bezier` curves and `CustomClipper` logic for fluid onboarding and authentication flows.
- **Glassmorphic Components**: Strategically utilized to provide depth and modern layering in the UI.
- **Micro-Animations**: Leverages `flutter_animate` for staggered entrance effects, providing a "premium" tactile feel.
- **Hierarchical Logic**: An intelligent multi-step selection system for 7+ President University faculties and their respective majors.

---

## 🔥 Technical Highlights

### ⚡ Real-Time Data Synchronization
- **Atomic Operations**: Utilizes Firestore `arrayUnion` and `arrayRemove` for performant, race-condition-free interaction tracking (Likes/Views).
- **Stream-Based Messaging**: Reactive chat implementation using Firestore Snapshots, providing sub-second latency for message delivery.
- **Story Persistence**: Integrated Firebase Storage with real-time metadata mapping for visual status updates.

### 🧩 Advanced State Management
- **Riverpod Architecture**: Decouples UI logic from state using `StateNotifier` and `AsyncValue`, ensuring predictable state transitions and robust error handling.
- **Auto-Disposal Logic**: Implements efficient memory management by automatically disposing of observers when screens are popped.

### 🏗️ Clean Architecture (Domain-Driven Design)
The codebase is partitioned into three distinct layers to ensure maximum testability and separation of concerns:

1.  **Domain Layer**: Pure Dart entities and abstract repository definitions. No external dependencies.
2.  **Data Layer**: Models (extending entities with `toJson`/`fromJson`) and Remote Data Sources implementing the repository interfaces.
3.  **Presentation Layer**: Feature-based screens, reusable shared widgets, and Riverpod controllers.

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: Flutter 3.24 (Channel Stable)
- **Backend (MBaaS)**: 
  - **Firebase Authentication**: OAuth2 & Google Sign-In support.
  - **Cloud Firestore**: Real-time NoSQL document database.
  - **Firebase Storage**: Object storage for high-resolution media.
- **Key Libraries**:
  - `flutter_riverpod`: Reactive state management.
  - `go_router`: Declarative routing with deep-link support.
  - `cached_network_image`: Optimized image delivery and caching.
  - `timeago`: Dynamic relative time formatting.
  - `shimmer`: Skeleton loading UI for enhanced UX.

---

## 📸 Core Modules

| **Auth & Onboarding** | **Real-Time Feed** | **Pro Profile Sync** |
| :---: | :---: | :---: |
| ![Auth](https://raw.githubusercontent.com/wi5nuu/presunivgo/main/screenshots/login.png) | ![Home](https://raw.githubusercontent.com/wi5nuu/presunivgo/main/screenshots/home.png) | ![Profile](https://raw.githubusercontent.com/wi5nuu/presunivgo/main/screenshots/profile.png) |

---

## 🚀 Installation & Build

### Development Setup
1. **Clone & Fetch**
   ```bash
   git clone https://github.com/wi5nuu/presunivgo.git
   flutter pub get
   ```
2. **Firebase Configuration**
   Invoke the Flutterfire CLI to generate `lib/firebase_options.dart`:
   ```bash
   flutterfire configure
   ```

### Build Release
- **Web**: `flutter build web --release`
- **Android**: `flutter build apk --release`

---

## 📜 Academic Integrity & License
This project was developed by **Wisnu Ashar** as the **Final Project for Wireless and Mobile Programming (FINPROTION)** at President University.

Published under the **MIT License**.

---

Developed with ❤️ by **Wisnu Ashar** • **President University**
