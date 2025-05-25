# MobileSec 🔒 🚗

A secure car management mobile application built with Flutter and Node.js, focusing on robust security practices and cross-platform functionality.

## Overview 📱

MobileSec is a comprehensive car management system that demonstrates modern mobile security practices. The application allows users to securely register, log in, and manage their car information while implementing various security measures like JWT authentication, HTTPS communication, and secure data storage.

The project consists of two main components:
- A Flutter-based mobile frontend with cross-platform support
- A Node.js/Express backend with secure API endpoints

Whether you're interested in mobile security implementation or looking for a template to build secure Flutter applications, this project showcases practical security patterns for mobile development.

## Features 🌟

- **Secure Authentication** 🔐
  - JWT-based authentication flow
  - Input validation on registration
  - Secure token storage

- **Car Management** 🚙
  - View all cars in a list format
  - Add new cars with details
  - Update car information

- **Theme Customization** 🎨
  - Persistent theme settings via SQLite
  - Color picker for UI customization

- **Cross-Platform Support** 📊
  - Android and iOS primary targets
  - Additional support for web, desktop platforms

## Technical Implementation 💻

### Frontend Architecture

The mobile application is built with Flutter/Dart and follows a structured architecture:

```
mobile_app/
├── lib/
│   ├── models/       # Data models
│   ├── screens/      # UI screens
│   ├── services/     # API and storage services
│   ├── widgets/      # Reusable UI components
│   └── main.dart     # Application entry point
└── [platform folders]
```

Key technical aspects:

- **State Management**: Flutter's built-in StatefulWidget pattern
- **API Communication**: Custom HTTP client with JWT authentication
- **Local Storage**: SQLite for configuration persistence
- **UI Components**: Custom widgets for car display and forms

### Backend Architecture

The backend is built with Node.js and Express, providing a RESTful API:

```
mobile_app_backend/
├── middleware/       # Express middleware
├── routes/          # API endpoints
├── services/        # Backend services
└── server.js        # Server entry point
```

Key technical aspects:

- **Authentication**: JWT generation and validation
- **API Security**: HTTPS with SSL certificates
- **Middleware**: Request validation and authentication checks
- **Routing**: Organized endpoint structure

### Security Features

The application implements several security best practices:

1. **Transport Security** 🔒
   - HTTPS communication with SSL certificates
   - Custom HTTP client handling for certificate validation

2. **Authentication** 👤
   - JWT tokens for stateless authentication
   - Secure token storage on the client
   - Authorization header for API requests

3. **Data Validation** ✓
   - Frontend input validation
   - Backend request validation

4. **Local Storage Security** 💾
   - Secure configuration storage using SQLite

## Setup and Usage 🚀

### Prerequisites

- Flutter SDK (latest stable version)
- Node.js (v14+)
- npm or yarn

### Frontend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/zrsoo/MobileSec.git
   ```

2. Navigate to the mobile app directory:
   ```bash
   cd MobileSec/mobile_app
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd MobileSec/mobile_app_backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the server:
   ```bash
   npm start
   ```

## Architecture Decisions 🏗️

### Why Flutter?

Flutter was chosen for its cross-platform capabilities, allowing the application to run on multiple platforms from a single codebase. This is particularly valuable for security applications where consistent behavior across platforms is essential.

### Why Node.js/Express?

The backend uses Node.js with Express for its lightweight nature and ease of implementing RESTful APIs. The asynchronous nature of Node.js makes it well-suited for handling multiple concurrent requests efficiently.

### Security-First Approach

The project name "MobileSec" reflects its primary focus on implementing mobile security best practices. Every architectural decision was made with security in mind, from the authentication flow to data storage.

## Future Improvements 🔮

- Implement biometric authentication
- Add end-to-end encryption for sensitive data
- Enhance offline capabilities with secure local storage
- Implement certificate pinning for additional HTTPS security
- Add comprehensive unit and integration tests

## Technologies Used 🛠️

### Frontend
- Flutter/Dart
- HTTP package
- SQLite
- Flutter Color Picker

### Backend
- Node.js
- Express
- CORS
- HTTPS/SSL
- JWT
