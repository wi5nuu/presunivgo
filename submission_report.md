# FINAL PROJECT REPORT: WIRELESS AND MOBILE PROGRAMMING

**Project Name:** PresUnivGo (Exclusively for President University)
**Subject:** Wireless and Mobile Programming
**Student Name:** Wisnu Ashar
**Student ID:** [Your ID Here]
**Email:** wisnu.ashar@student.president.ac.id
**GitHub Link:** https://github.com/wi5nuu/presunivgo.git
**Hosting URL:** https://puconnect-9e8fb.web.app

---

## 1. Project Description
**PresUnivGo** is a professional networking and community-centric mobile application designed to foster a robust ecosystem within President University. The application serves as a centralized hub where students, alumni, and faculty can interact, share professional achievements, and access campus-exclusive opportunities. 

In an era where professional networking is fragmented, PresUnivGo provides a focused environment that aligns with the academic and professional culture of President University. It integrates high-fidelity design with real-time backend services to provide a premium user experience on both mobile and web platforms.

---

## 2. Problem Statement
The President University community currently lacks a dedicated, unified platform for professional networking. Existing social media platforms are too broad, leading to professional updates being buried under casual content. Specifically:
- **Networking Gaps**: Students often find it difficult to connect with alumni for career guidance.
- **Fragmented Information**: Job opportunities and club activities are shared through various unmanaged groups (WhatsApp, Telegram), making them easy to miss.
- **Static Profiles**: Standard campus portals do not allow students to showcase their dynamic skill sets or real-time professional progress.

---

## 3. Proposed Solution
PresUnivGo addresses these challenges by implementing:
- **Centralized Campus Feed**: A dedicated professional stream for President University members only.
- **Dynamic Skill Tracking**: A profile system that allows real-time updates of Experience, Education, and Skills, synchronized across all devices via Firestore.
- **Real-Time Story System**: A visual storytelling feature for sharing immediate professional or campus-related updates.
- **Exclusive Marketplace**: Dedicated modules for Student Clubs and Job Opportunities, ensuring information reaches the target audience effectively.

---

## 4. Technical Specifications

### 4.1. Frontend Architecture
The application is built using **Flutter** and the **Dart** programming language. It leverages **Riverpod** for state management, following the **Clean Architecture** pattern:
- **Domain Layer**: Pure business logic and entity definitions.
- **Data Layer**: Implementation of repository patterns and data sources (Firebase).
- **Presentation Layer**: UI components using Material 3 and custom design tokens.

### 4.2. Backend Infrastructure
- **Authentication**: Firebase Auth (Email/Password and Google Sign-In integration).
- **NoSQL Database**: Cloud Firestore for real-time data persistence and synchronization.
- **Cloud Storage**: Firebase Storage for media-rich content (Profile images, story uploads).
- **Hosting**: Firebase Hosting for the web distribution of the cross-platform application.

---

## 5. Key Features & Implementation
- **Premium Wave UI**: Custom-designed login and onboarding screens using advanced `CustomClipper` Bezier paths.
- **Real-Time Messaging**: A high-fidelity chat system connecting all participants.
- **Faculty-Specific Logic**: A hierarchical major selection system covering all PU faculties (Business, Engineering, Computing, Social Sciences, Art & Design, Law, and Medicine).
- **Interactive Posts**: Support for rich reactions (Likes) and threaded conversations (Comments) using atomic Firestore updates.

---

## 6. Screenshots & Results
The application successfully delivers a premium "Dark Teal & Cream" aesthetic across all key modules:
(Please refer to the screenshots provided in the submission folder or the README.md)

---

## 7. Conclusion
PresUnivGo demonstrates the successful integration of modern mobile development frameworks with scalable cloud services. It fulfills the requirements for the Wireless and Mobile Programming course by providing a functional, cross-platform solution to a real-world campus problem, emphasizing high-fidelity design and technical robustness.
