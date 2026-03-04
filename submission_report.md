# TECHNICAL REPORT: PRESUNIVGO CROSS-PLATFORM SYSTEM
## FINAL PROJECT — WIRELESS AND MOBILE PROGRAMMING

**Student Name:** Wisnu Alfian Nur Ashar  
**Student ID:** 001202400138
**Faculty:** Faculty of Computing  
**Subject:** Wireless and Mobile Programming  
**University:** President University  

---

## 1. ABSTRACT
This report documents the architectural design, implementation, and deployment of **PresUnivGo**, a high-fidelity professional networking application engineered exclusively for the President University ecosystem. The project leverages the **Flutter SDK**, **Firebase Serverless Infrastructure**, and **Generative AI** to deliver a unified, real-time community experience. The system emphasizes **Clean Architecture**, **Reactive State Management**, and a **Premium Magenta & White UI/UX** paradigm to solve fragmented communication and career guidance challenges within the campus environment.

---

## 2. INTRODUCTION
Digital networking within academic institutions is often decentralized, relying on broad-market social media platforms that dilute professional focus. **PresUnivGo** addresses this by providing a specialized, high-security environment for President University students and alumni. This report outlines the technical solutions implemented to facilitate real-time engagement, career tracking, automated mentorship, and community organizational management.

---

## 3. PROBLEM STATEMENT
Fragmentation of professional data and communication channels at President University leads to:
1.  **Low Visibility**: Internship and career achievements are lost in casual group chats.
2.  **Career Guidance Gap**: Students often lack clear, milestone-based roadmaps for their specific majors.
3.  **Inefficient Information Flow**: Campus-exclusive job opportunities and student clubs lack a centralized, searchable, and interactive repository.

---

## 4. SYSTEM ARCHITECTURE

### 4.1. The "Clean Architecture" Pattern
The application core is developed using a multi-layered approach to maximize modularity and maintainability:
-   **Domain Layer**: Encapsulates pure business entities (e.g., `UserEntity`, `PostEntity`) and repository contracts. This layer is platform-agnostic.
-   **Data Layer**: Responsible for external data mapping. It converts Firestore JSON into typed Models and implements the repositories using `FirebaseFirestore` and `FirebaseStorage` SDKs.
-   **Presentation Layer**: Utilizes the **Riverpod** state management ecosystem. It employs `StateNotifierProvider` to observe business logic and `AsyncValue` to handle network states (Loading, Data, Error) reactively.

### 4.2. Cloud Infrastructure (MBaaS)
The system utilizes a tailored Firebase implementation:
-   **Authentication Layer**: Secure JWT-based auth with integrated **Google OAuth** support.
-   **NoSQL Data Tier**: Cloud Firestore handles sub-second real-time synchronization for the Feed and Messaging modules.
-   **Media Tier**: Firebase Storage utilizes optimized blob storage for user-generated content (Stories and Profiles).
-   **Hosting**: Globally distributed CDN for the web-based high-fidelity dashboard.

---

## 5. TECHNICAL IMPLEMENTATION DETAILS

### 5.1. Premium UI/UX Engineering
-   **Vibrant Magenta Theme**: A central design token system (`AppColors`) governs the "Radiant Magenta & White" palette, ensuring global visual consistency and a premium first impression.
-   **Wave Interaction**: Implemented custom `Bezier` math and `CustomClipper` classes to create unique transition headers, moving beyond standard Material presets.
-   **Micro-Animations**: Extensive use of the `flutter_animate` library for staggered loading effects and tactile interaction feedback.

### 5.2. AI Career Mentor Module
A standout feature of PresUnivGo is the AI-driven mentorship suite:
-   **Roadmap Generation**: Algorithms that parse user faculty/major data to generate professional milestones.
-   **CV/Cover Letter Review**: Integration of AI prompts to analyze and provide feedback on professional documentation.

### 5.3. Functional Audit & Reliability
To ensure 100% reliability for Professor review, the application underwent a comprehensive **Functional Audit**, verifying:
-   Full navigation flow across Home, Jobs, Clubs, and Profile modules.
-   Search functionality correctness for faculty-specific content.
-   Google Sign-In integration reliability on web and mobile.

---

## 6. VERIFICATION & DEPLOYMENT
-   **Web Distribution**: The application is deployed via **Firebase Hosting** using a multi-phase build pipeline.
-   **Live Link**: [https://puconnect-9e8fb.web.app](https://puconnect-9e8fb.web.app)
-   **Source Code**: [https://github.com/wi5nuu/presunivgo.git](https://github.com/wi5nuu/presunivgo.git)

---

## 7. CONCLUSION
PresUnivGo represents a robust application of modern mobile programming principles. By combining high-performance frontend frameworks with scalable cloud backends, AI-driven features, and a strict adherence to architectural best practices, the system provides a scalable solution for institutional networking.

---

**Wisnu Alfian Nur Ashar**  
*Wireless and Mobile Programming Project*  
*President University, 2026*
