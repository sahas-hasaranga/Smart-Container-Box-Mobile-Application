# 📦 Smart Container Box Mobile Application

A professional, feature-rich Flutter mobile application designed to monitor and manage a Smart Container Box in real-time. This application interfaces with an ESP32-CAM and a suite of IoT sensors via Firebase, providing live telemetry, video streaming, and GPS tracking.

## ✨ Key Features

- **📊 Real-time Dashboard**: Monitor critical container metrics instantly including:
  - Weight and Bin Fill Level
  - BMP & DHT Temperatures
  - Humidity & Pressure
  - Gas Levels (ppm)
- **📹 Live Camera Feed**: Directly view the live video stream from the integrated ESP32-CAM.
- **🗺️ Live GPS Tracking**: Track the container's live location with actual driving route, road distance, and ETA calculation powered by **OSRM**.
- **🔐 Secure Authentication**: Firebase-backed user authentication system for secure access.
- **🎨 Premium UI/UX**: Designed with modern aesthetics, fully responsive Dark/Light modes, glassmorphism elements, and smooth micro-animations.

## 🛠️ Technology Stack

- **Frontend**: Flutter & Dart
- **Backend & Database**: Firebase Authentication & Realtime Database
- **Hardware Integration**: ESP32-CAM, DHT/BMP Sensors, GPS Module, Load Cells
- **Routing API**: Open Source Routing Machine (OSRM)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sahas-hasaranga/Smart-Container-Box-Mobile-Application.git
   ```

2. **Navigate to the project directory:**
   ```bash
   cd Smart-Container-Box-Mobile-Application
   ```

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

## 📸 Screenshots
*(Add screenshots of your application here)*

## 📄 License
This project is licensed under the MIT License.
