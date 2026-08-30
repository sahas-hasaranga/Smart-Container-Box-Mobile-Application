<div align="center">
  
  <img src="assets/icon.png" width="120" alt="App Logo" style="border-radius:20px; margin-bottom: 20px;" />

  # 📦 Smart Container Box Mobile Application

  <p align="center">
    <strong>A next-generation IoT solution for real-time monitoring and tracking of Smart Container Boxes.</strong>
  </p>
  
  <p align="center">
    <a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" /></a>
    <a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" /></a>
    <a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" /></a>
    <a href="https://www.espressif.com/"><img src="https://img.shields.io/badge/ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white" alt="ESP32" /></a>
  </p>

  <p align="center">
    <img src="https://img.shields.io/github/repo-size/sahas-hasaranga/Smart-Container-Box-Mobile-Application?style=flat-square&color=blue" alt="Repo Size" />
    <img src="https://img.shields.io/github/stars/sahas-hasaranga/Smart-Container-Box-Mobile-Application?style=flat-square&color=yellow" alt="Stars" />
    <img src="https://img.shields.io/github/forks/sahas-hasaranga/Smart-Container-Box-Mobile-Application?style=flat-square&color=orange" alt="Forks" />
    <img src="https://img.shields.io/github/issues/sahas-hasaranga/Smart-Container-Box-Mobile-Application?style=flat-square&color=red" alt="Issues" />
    <img src="https://img.shields.io/github/license/sahas-hasaranga/Smart-Container-Box-Mobile-Application?style=flat-square&color=brightgreen" alt="License" />
  </p>

</div>

---

## 📑 Table of Contents
- [About the Project](#-about-the-project)
- [Key Features](#-key-features)
- [System Architecture](#-system-architecture)
- [Hardware Requirements](#-hardware-requirements)
- [Screenshots](#-screenshots)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 About the Project

The **Smart Container Box Mobile Application** is a professional, feature-rich Flutter application designed to interface seamlessly with IoT hardware. It provides end-users with real-time telemetry, live video surveillance, and pinpoint GPS tracking of their container boxes from anywhere in the world.

Built with performance and aesthetics in mind, the app features a responsive **Glassmorphism UI**, dynamic dark/light themes, and smooth micro-animations ensuring a premium user experience.

---

## ✨ Key Features

### 📊 Real-time Telemetry Dashboard
- Live **Weight & Fill Level** monitoring.
- Environmental tracking: **BMP/DHT Temperature**, **Humidity**, and **Pressure**.
- Safety sensors: **Gas Level (ppm)** monitoring.

### 📹 Live Camera Streaming
- Ultra-low latency video stream directly from the **ESP32-CAM** module.

### 🗺️ Live GPS Tracking
- Integrated with **OSRM** (Open Source Routing Machine) to show accurate driving routes.
- Real-time Distance and ETA calculations.

### 🔐 Secure Access
- Robust authentication powered by **Firebase Auth**.
- Secure Realtime Database rules for telemetry protection.

### 🎨 Premium UI/UX Design
- Fully responsive, animated interfaces using `flutter_animate`.
- Custom-built widgets for an immersive experience.

---

## 🏗️ System Architecture

The ecosystem relies on three main components communicating in real-time. 

```mermaid
graph TD;
    subgraph IoT Hardware
        Sensors[Sensors: Load Cell, DHT11, BMP280, MQ Gas, GPS] --> MCU[NodeMCU / ESP8266]
        Cam[ESP32-CAM] --> Stream[Live Video Stream]
    end

    subgraph Cloud Infrastructure
        MCU -- Telemetry Data --> FB_RTDB[(Firebase Realtime Database)]
        Auth[Firebase Auth]
    end

    subgraph Flutter Mobile Application
        App[Smart Container App] -- Subscribes to Data --> FB_RTDB
        App -- Authenticates --> Auth
        App -- Fetches Stream --> Stream
    end
    
    style IoT Hardware fill:#e1f5fe,stroke:#03a9f4,stroke-width:2px;
    style Cloud Infrastructure fill:#fff3e0,stroke:#ff9800,stroke-width:2px;
    style Flutter Mobile Application fill:#e8f5e9,stroke:#4caf50,stroke-width:2px;
```

---

## 🔌 Hardware Requirements

To fully utilize this application, the Smart Container Box should be equipped with:

| Component Category | Recommended Hardware | Purpose |
|--------------------|----------------------|---------|
| **Microcontrollers** | NodeMCU / ESP8266 | Main processing and data transmission. |
| **Camera Module** | ESP32-CAM | Live video surveillance streaming. |
| **Sensors** | Load Cell (with HX711) | Weight/Fill level calculation. |
| | DHT11 / DHT22 | Temperature & Humidity sensing. |
| | BMP280 | Pressure & precise Temperature sensing. |
| | MQ Series Sensor | Gas leakage / Air quality monitoring. |
| | Neo-6M GPS Module | Real-time location tracking. |

---

## 📸 Screenshots

<p align="center">
  <img src="images/screen1.jpg" width="22%" alt="Dashboard" />
  &nbsp;&nbsp;
  <img src="images/screen2.jpg" width="22%" alt="Camera Tab" />
  &nbsp;&nbsp;
  <img src="images/screen3.jpg" width="22%" alt="GPS Tracking" />
  &nbsp;&nbsp;
  <img src="images/screen4.jpg" width="22%" alt="Settings" />
</p>

---

## 🛠️ Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable version)
- [Dart SDK](https://dart.dev/get-dart)
- [Git](https://git-scm.com/)
- IDE (VS Code or Android Studio)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/sahas-hasaranga/Smart-Container-Box-Mobile-Application.git
   cd Smart-Container-Box-Mobile-Application
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Place your `google-services.json` file inside `android/app/`.
   - Update Firebase Configurations in `lib/firebase_options.dart`.

4. **Run the Application**
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
lib/
├── screens/           # UI Screens (Dashboard, Camera, GPS, Auth)
├── widgets/           # Reusable UI components (Buttons, Cards, Camera Views)
├── services/          # Business logic, API calls, and Firebase interactions
├── models/            # Data models and classes
├── main.dart          # Entry point of the application
└── firebase_options.dart # Firebase configuration file
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! 
Feel free to check the [issues page](https://github.com/sahas-hasaranga/Smart-Container-Box-Mobile-Application/issues).

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the **MIT License**. See the `LICENSE` file for more details.

<div align="center">
  <i>Developed with ❤️ using Flutter & Firebase.</i>
</div>
