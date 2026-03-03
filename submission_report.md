# TECHNICAL REPORT: PRESUNIVGO CROSS-PLATFORM SYSTEM
## FINAL PROJECT — WIRELESS AND MOBILE PROGRAMMING

**Student Name:** Wisnu Ashar  
**Student ID:** [Your ID]  
**Faculty:** Computing  
**Subject:** Wireless and Mobile Programming  
**University:** President University  

---

## 1. ABSTRACT
This report documents the architectural design, implementation, and deployment of **PresUnivGo**, a high-fidelity professional networking application engineered exclusively for the President University ecosystem. The project leverages the **Flutter SDK** and **Firebase Serverless Infrastructure** to deliver a unified, real-time community experience. The system emphasizes **Clean Architecture**, **Reactive State Management**, and **Premium UI/UX** paradigms to solve fragmented communication challenges within the campus environment.

---

## 2. INTRODUCTION
Digital networking within academic institutions is often decentralized, relying on broad-market social media platforms that dilute professional focus. **PresUnivGo** addresses this by providing a specialized, high-security environment for President University students and alumni. This report outlines the technical solutions implemented to facilitate real-time engagement, career tracking, and community organizational management.

---

## 3. PROBLEM STATEMENT
Fragmentation of professional data and communication channels at President University leads to:
1.  **Low Visibility**: Internship and career achievements are lost in casual group chats.
2.  **Stagnant Networking**: Difficulty in identifying and connecting with peers based on specific skills or faculties.
3.  **Inefficient Information Flow**: Campus-exclusive job opportunities lack a centralized, searchable repository.

---

## 4. SYSTEM ARCHITECTURE

### 4.1. The "Clean Architecture" Pattern
The application core is developed using a multi-layered approach to maximize modularity and maintainability:
-   **Domain Layer**: Encapsulates pure business entities (e.g., `UserEntity`, `PostEntity`) and repository contracts. This layer is platform-agnostic.
-   **Data Layer**: Responsible for external data mapping. It converts Firestore JSON into typed Models and implements the repositories using `FirebaseFirestore` and `FirebaseStorage` SDKs.
-   **Presentation Layer**: Utilizes the **Riverpod** state management ecosystem. It employs `StateNotifierProvider` to observe business logic and `AsyncValue` to handle network states (Loading, Data, Error) reactively.

### 4.2. Cloud Infrastructure (MBaaS)
The system utilizes a tailored Firebase implementation:
-   **Authentication Layer**: Secure JWT-based auth with integrated Google OAuth support.
-   **NoSQL Data Tier**: Cloud Firestore handles sub-second real-time synchronization for the Feed and Messaging modules.
-   **Media Tier**: Firebase Storage utilizes optimized blob storage for user-generated content (Stories and Profiles).

---

## 5. TECHNICAL IMPLEMENTATION DETAILS

### 5.1. Premium UI/UX Engineering
-   **Wave Interaction**: Implemented custom `Bezier` math and `CustomClipper` classes to create unique transition headers, moving beyond standard Material presets.
-   **Dynamic Theming**: A central design token system (`AppColors`) governs the Dark Teal & Cream palette, ensuring global visual consistency.
-   **Responsive Layouts**: Extensive use of `Sliver` widgets and `CustomScrollView` ensures the interface adapts seamlessly between Android, iOS, and Web viewports.

### 5.2. Functional Modules
-   **Deep-Linked Identity**: A profile system that supports hierarchical data sync for Experience, Education, and Skills, utilizing Firestore's `SetOptions(merge: true)` for non-destructive updates.
-   **Real-Time Analytics Integration**: Atomic counter updates for post reactions (Likes) to prevent data race conditions during high-volume interaction.

---

## 6. VERIFICATION & DEPLOYMENT
-   **Web Distribution**: The application is deployed via **Firebase Hosting** using a multi-phase build pipeline:
    -   *Phase 1*: Flutter Release Asset Generation.
    -   *Phase 2*: CDN Edge Deployment.
-   **Live Link**: [https://puconnect-9e8fb.web.app](https://puconnect-9e8fb.web.app)

---

## 7. CONCLUSION
PresUnivGo represents a robust application of modern mobile programming principles. By combining high-performance frontend frameworks with scalable cloud backends and a strict adherence to architectural best practices, the system provides a scalable solution for institutional networking.

---

**Wisnu Ashar**  
*Wireless and Mobile Programming Final Project*  
*President University, 2026*
