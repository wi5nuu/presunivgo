# 🌊 PresUnivGo — High-Fidelity Professional Networking for President University

**PresUnivGo** is an elite, cross-platform professional networking solution engineered specifically for the **President University** ecosystem. This project implements modern mobile development paradigms, including **Clean Architecture**, **Reactive State Management**, and **AI-Driven Personalization**.

🚀 **Live Deployment:** [https://puconnect-9e8fb.web.app](https://puconnect-9e8fb.web.app)

---

## 🎨 Radiant Design System

The application features a bespoke design system centered around a vibrant **"Radiant Magenta & Pristine White"** palette, optimized for professional aesthetics and elite visual clarity.

-   **Glassmorphism & Depth**: Utilizes `GlassContainer` widgets with high blur (15-20) and low opacity (0.7-0.8) for a premium, modern feel.
-   **Wave UI Design**: Implemented custom `Bezier` curves for fluid onboarding and authentication flows.
-   **Micro-Animations**: Leverages `flutter_animate` for staggered entrance effects and interactive typing indicators.
-   **Elite Typography**: Uses modern variable fonts (Outfit & Inter) for maximum readability.

---

## 🧠 AI Career Mentor Suite (Powered by Gemini)

A core technical differentiator, PresUnivGo integrates an AI Assistant suite to bridge the gap between education and industry:

-   **AI Career Roadmap**: Milestone-based roadmaps for custom tech and business roles.
-   **AI CV Reviewer**: Structural analysis and actionable feedback for resumes.
-   **AI Cover Letter Builder**: Tailored letters based on experience and job targeting.
-   **AI Smart Post Suggestions**: Intelligent content ideation based on the student's academic major and profile history.
-   **MentorBot**: Real-time interactive guidance for career and campus queries.

---

## 🏗️ Technical Architecture

### ⚡ Real-Time Ecosystem
-   **Instant Search**: High-performance Firestore prefix search with a 300ms debounce and multi-category filtering (People, Jobs, Posts).
-   **Networking Engine**: Real-time connection management (Connect/Disconnect) with instant Firestore synchronization.
-   **Typing Indicators**: Reactive three-dot animated feedback in chat channels using Firestore state flags.
-   **Career Analytics**: A dynamic dashboard featuring profile strength metrics, activity graphs, and real-time impression tracking.

### 🧩 Advanced State Management
-   **Plain Riverpod Implementation**: Refactored from code-gen `@riverpod` to standard `FutureProvider` and `StreamProvider` families, reducing build complexity and increasing maintainability.
-   **Reactive Snapshots**: Real-time data streams for Admin statistics, Chat messages, and Network suggested profiles.

### 🏗️ Domain-Driven Design (DDD)
The codebase is strictly partitioned into three layers:
1.  **Domain Layer**: Pure Dart entities and abstract repository definitions.
2.  **Data Layer**: Models (extending entities) and Remote Data Sources.
3.  **Presentation Layer**: Feature-based modular structure (Auth, Jobs, Chat, AI, Profile, Dashboard).

---

## 🛠️ Tech Stack & Dependencies

-   **Framework**: Flutter 3.24 (Channel Stable)
-   **Backend**: 
    -   **Firebase Auth**: Secure OAuth2 and Role-Based Access Control (RBAC).
    -   **Cloud Firestore**: Real-time NoSQL document store.
    -   **Firebase Storage**: Scalable media and document storage.
-   **State Management**: `flutter_riverpod` (v2.x)
-   **Navigation**: `go_router` (v13.x) with deep-linking and state preservation.
-   **Animations**: `flutter_animate` & `shimmer`.
-   **Core Utilities**: `uuid`, `intl`, `timeago`, `file_picker`.

---

## 🛡️ Admin & Control
The system includes a secure **Admin Dashboard** with:
-   **Live User Management**: Activate/Deactivate student accounts instantly.
-   **Content Moderation**: Real-time post deletion and monitoring.
-   **Real-Time Analytics**: Live counters for Users, Jobs, Posts, and Clubs.

---

## 📜 Academic Integrity & License
This project was developed by **Wisnu Ashar** as the **Final Project for Wireless and Mobile Programming (FINPROTION)** at President University.

Published under the **MIT License**.

---

Developed with ❤️ by **Wisnu Alfian Nur Ashar**
