# 💊 IntelliPharma

IntelliPharma is a Flutter-based mobile application designed for pharmaceutical distributors and medical representatives, providing role-based tools to streamline daily operations and improve field efficiency.

The application supports route optimization, pharmacy visits, order management, debt tracking, promotions, targets, delivery tracking, notifications, and communication, with dedicated workflows for both medical representatives and distributors.

---

## 📱 Screenshots

> Replace the image paths below with your actual screenshots.

### Dashboard

<p align="center">
  <img src="assets/screenshots/dashboard.png" width="30%" />
  <img src="assets/screenshots/dashboard_dark.png" width="30%" />
</p>

### Inventory Management

<p align="center">
  <img src="assets/screenshots/inventory.png" width="30%" />
  <img src="assets/screenshots/medicine_details.png" width="30%" />
  <img src="assets/screenshots/add_medicine.png" width="30%" />
</p>

### Medical Representatives

<p align="center">
  <img src="assets/screenshots/representatives.png" width="30%" />
  <img src="assets/screenshots/representative_details.png" width="30%" />
</p>

### Route Optimization

<p align="center">
  <img src="assets/screenshots/routes.png" width="30%" />
  <img src="assets/screenshots/map.png" width="30%" />
</p>

### Reports & Analytics

<p align="center">
  <img src="assets/screenshots/reports.png" width="30%" />
  <img src="assets/screenshots/statistics.png" width="30%" />
</p>

---

## 🎯 Project Overview

**IntelliPharm** is an enterprise-grade cross-platform mobile application designed to digitize and optimize daily operations for pharmaceutical warehouses, sales representatives, and distributors.

The application features a robust **Role-Based Access Control (RBAC)** system that dynamically adapts the user interface and functionality depending on the logged-in user type:

### 👨‍💼 Medical Sales Representatives (المندوبين)
* **Smart Route Optimization & GPS Tracking:** Calculates optimal daily visit paths, verifies actual physical visits, and handles check-in/check-out logs.
* **Smart Sales & Orders:** Fast order creation, custom pricing logic, management of offers, bonus/gifts system, and alternative medicine suggestions.
* **Client & Financial Management:** Comprehensive pharmacy history, debt tracking, CRM features (direct call/WhatsApp integration), and custom notes.
* **Performance & Insights:** Live target tracking, real-time push notifications, and an **AI-powered Assistant Chatbot** for quick queries.

### 🚚 Medical Distributors (الموزعين)
* **Delivery Workflow:** Integrated distribution routes, real-time order tracking, and package delivery verification.
* **Financial Settlements:** Immediate collection recording, invoice updates, and full delivery history logs.

### 🌐 System & UX Capabilities
* **Multi-Language Support:** Seamless Arabic & English translation.
* **Modern UI:** Native Dark & Light mode support.

---

## ✨ Key Features

### 📍 Field Operations & Route Optimization
* **Smart Route Planning:** Optimizes daily visit itineraries for sales representatives to save time and effort.
* **Verified Visits (GPS Check-in):** Logs actual physical pharmacy visits with accurate location verification.
* **Dynamic Schedule Management:** Allows reps to adapt and modify their visit plans on the go.

### 🛒 Fast Ordering & Sales Management
* **Rapid Order Creation:** Streams the ordering process for high-speed dynamic entry during pharmacy visits.
* **Smart Product Alternatives & Offers:** Displays medicine substitutes, stock availability, dynamic pricing, and promotional bundles/bonuses.

### 💼 Financial & Performance Tracking
* **Debt & Receivable Insights:** Displays real-time pharmacy ledger balance, outstanding debts, and collection histories.
* **Target & KPI Dashboard:** Visualizes sales performance, completed visits, and target progress in real time.

### 🤖 AI Assistant & Communication
* **Smart AI Chatbot:** In-app intelligent assistant for quick medicine queries, stock checks, and guidance.
* **Direct Communication Hub:** One-touch direct calls or WhatsApp messaging with client pharmacies.

---

### ⚠️ Stock & Expiration Alerts

Real-time inventory intelligence to mitigate stockouts and minimize medicine wastage:

* **Automated Stock Monitoring:** Instant notifications for low-stock levels and out-of-stock items.
* **Batch & Expiry Tracking:** Pre-emptive alerts for near-expiry and expired pharmaceuticals.
* **Visual Status Indicators:** Color-coded inventory health metrics for fast operational decision-making.

---

### 💊 Smart Catalog & Medicine Discovery

Empowers reps with a fast, filterable product catalog during client visits:

* **Advanced Search & Filtering:** Quick search by commercial or scientific (generic) name, with filters for local/imported drugs and dosage forms (syrup, tablets, injections, etc.).
* **Detailed Drug Insights:** Displays trade name, scientific composition, concentration, price, and active batch availability.
* **Alternative Medicine Finder:** Instantly suggests in-stock substitutes and generic alternatives when a requested item is out of stock.

---

### 🗺️ Smart Route Optimization

One of the core concepts of IntelliPharma is helping medical representatives organize their daily visits more efficiently.

The route planning functionality is designed to:

* Organize customer visits
* Reduce unnecessary travel
* Improve visit planning
* Prioritize locations
* Display routes on a map
* Help representatives manage their daily schedules

---

### 🔎 Search & Filtering

Quickly find relevant information through search and filtering.

Users can search and filter:

* Medicines
* Categories
* Stock status
* Customers
* Visits

---

## 🏗️ System Architecture

IntelliPharm is structured as a Flutter application with a modular architecture designed to keep the codebase maintainable and scalable.

```text
IntelliPharm
│
├── lib/
│   │
│   ├── core/
│   │   ├── constants/
│   │   ├── theme/
│   │   ├── utils/
│   │   └── services/
│   │
│   ├── models/
│   │   ├── VisitDetails/
│   │   ├── ActiveDeliveryRoute/
│   │   ├── ActiveOptimizedRouteTracking/
│   │   ├── AddOrder/
│   │   ├── AddPharmacy/
│   │   ├── Chat/
│   │   ├── PharmacyDebts/
│   │   └── PlanYourRoute/
│   │
│   │
│   ├── widgets/
│   │   ├── common/
│   │   ├── cards/
│   │   ├── charts/
│   │   └── forms/
│   │
│   └── main.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── screenshots/
│
├── android/
└── ios/
```

> The structure above represents the recommended conceptual organization. Adjust the tree to match the actual project structure if your implementation differs.

---

## 🛠️ Technology Stack

### Frontend

* **Flutter**
* **Dart**
* Material Design
* Responsive UI

### Platforms

IntelliPharma is built with Flutter and can be prepared for multiple platforms:

* Android
* iOS
* Web
* Windows
* Linux
* macOS

### Development Tools

* Flutter SDK
* Dart SDK
* Android Studio / VS Code
* Git
* GitHub

---

## 📂 Project Structure

The repository contains the standard Flutter platform directories together with the application source code and assets.

```text
.
├── android/
├── assets/
├── ios/
├── lib/
├── linux/
├── macos/
├── test/
├── web/
├── windows/
│
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

---

## 🚀 Getting Started

Follow the steps below to run IntelliPharm locally.

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or a physical Android device

Verify your Flutter installation:

```bash
flutter doctor
```

---

## 📥 Installation

### 1. Clone the repository

```bash
git clone https://github.com/Mustafa-Sharaf/IntelliPharm.git
```

### 2. Navigate to the project

```bash
cd IntelliPharm
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

---

## 🧪 Running Tests

To execute the available tests:

```bash
flutter test
```

For static analysis:

```bash
flutter analyze
```

---

## ⚙️ Configuration

Before running the application in a production environment, configure the required application services and environment-specific settings.

Recommended configuration areas include:

```text
API / Backend
Database
Authentication
Maps / Location Services
Application Keys
Environment Variables
```

> Never commit private API keys, passwords, tokens, or production credentials to the repository.

For local development, use environment-specific configuration files where appropriate.

---

## 🔐 Security Considerations

Because IntelliPharm handles pharmaceutical and operational information, security should be treated as an important part of the system.

Recommended production practices include:

* Secure authentication
* Role-based authorization
* Encrypted communication
* Secure API endpoints
* Protected credentials
* Input validation
* Secure local storage
* Audit logging
* Regular dependency updates

---

## 👥 User Roles

The system can support multiple operational roles.

### 👨‍💼 Administrator

Responsible for overall system management.

Possible permissions:

* Manage users
* Manage medicines
* Manage inventory
* Manage representatives
* View reports
* Configure system settings

### 📦 Warehouse Staff

Responsible for inventory operations.

Possible permissions:

* Add medicines
* Update stock
* Monitor inventory
* Track batches
* Monitor expiration dates

### 👨‍⚕️ Medical Representative

Responsible for field activities.

Possible permissions:

* View assigned visits
* View customers
* Manage daily routes
* Update visit status
* Track completed activities

---

## 🔄 Typical Workflow

```text
                ┌─────────────────────┐
                │       Login         │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │     Dashboard       │
                └──────────┬──────────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
     Inventory       Representatives     Reports
          │                │
          ▼                ▼
   Stock Monitoring   Customer Visits
          │                │
          └───────┬────────┘
                  ▼
           Route Planning
                  │
                  ▼
          Optimized Daily Route
```

---

## 📈 Business Benefits

IntelliPharm is designed to help pharmaceutical organizations improve operational efficiency.

### Reduced Manual Work

Centralizing inventory and representative information reduces dependency on manual processes.

### Better Inventory Visibility

Warehouse teams can quickly understand current stock conditions and identify products requiring attention.

### Improved Expiration Management

Expiration-date monitoring helps reduce the risk of medicines remaining unnoticed until they expire.

### More Efficient Field Operations

Route planning can help medical representatives organize their daily visits and reduce unnecessary travel.

### Centralized Information

Important pharmaceutical and operational information can be accessed through a single system.

---

## 🧩 Future Improvements

The project can be extended with additional enterprise-level functionality.

### 🔮 Planned / Possible Features

* [ ] Backend API integration
* [ ] Cloud database
* [ ] Role-based authentication
* [ ] Advanced inventory forecasting
* [ ] Automatic stock replenishment suggestions
* [ ] Barcode / QR code scanning
* [ ] Prescription management
* [ ] Purchase and sales management
* [ ] Supplier management
* [ ] Customer management
* [ ] Advanced analytics dashboard
* [ ] PDF report generation
* [ ] Excel export
* [ ] Push notifications
* [ ] Expiration alerts
* [ ] Low-stock notifications
* [ ] GPS-based representative tracking
* [ ] Advanced route optimization
* [ ] Offline-first functionality
* [ ] Multi-language support
* [ ] Dark mode
* [ ] Cloud synchronization

---

## 📊 Example Dashboard Metrics

A production deployment could provide metrics such as:

```text
┌─────────────────────────────────────────────┐
│                IntelliPharm                 │
├──────────────┬──────────────┬───────────────┤
│ Total Drugs  │ Low Stock    │ Expiring Soon │
│     1,250    │      34      │       18      │
├──────────────┼──────────────┼───────────────┤
│ Representatives │ Today's Visits │ Routes   │
│       24         │       67       │    12    │
└─────────────────┴────────────────┴───────────┘
```

---

## 🖼️ Assets & Screenshots

Recommended screenshot structure:

```text
assets/
└── screenshots/
    ├── splash.png
    ├── login.png
    ├── dashboard.png
    ├── inventory.png
    ├── medicine_details.png
    ├── add_medicine.png
    ├── representatives.png
    ├── representative_details.png
    ├── routes.png
    ├── map.png
    ├── reports.png
    └── settings.png
```

You can replace the placeholder images in this README with screenshots from the actual application.

---

## 🎥 Demo

### Application Demo

Add your demo video or GIF here:

```markdown
[![IntelliPharm Demo](assets/screenshots/demo-preview.png)](YOUR_DEMO_URL)
```

Or add a GIF directly:

```markdown
![IntelliPharm Demo](assets/demo/intellipharm-demo.gif)
```

---

## 🌐 Supported Platforms

| Platform | Status |
| -------- | ------ |
| Android  | ✅      |
| iOS      | ✅      |
| Web      | ✅      |
| Windows  | ✅      |
| Linux    | ✅      |
| macOS    | ✅      |

> Platform availability may depend on the application's current implementation and platform-specific integrations.

---

## 📌 Project Status

**IntelliPharm is an actively developed project.**

The application is designed as a foundation for a real-world pharmaceutical warehouse and medical representative management system, with additional enterprise features planned for future iterations.

---

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

### 1. Fork the repository

```bash
git fork https://github.com/Mustafa-Sharaf/IntelliPharm.git
```

### 2. Create a feature branch

```bash
git checkout -b feature/your-feature
```

### 3. Commit your changes

```bash
git commit -m "feat: add your feature"
```

### 4. Push the branch

```bash
git push origin feature/your-feature
```

### 5. Open a Pull Request

Please provide a clear description of the changes and explain why the feature or improvement is useful.

---

## 🐛 Reporting Issues

If you discover a bug or have a feature request, please open an issue in the GitHub repository.

When reporting a bug, include:

* Description of the problem
* Steps to reproduce
* Expected behavior
* Actual behavior
* Screenshots if applicable
* Device / operating system
* Flutter version

---

## 📄 License

This project is currently maintained by **Mustafa Sharaf**.

If you plan to publish IntelliPharm as an open-source project, consider adding an appropriate license such as MIT, Apache 2.0, or another license that matches your intended usage.

---

## 👨‍💻 Author

### Mustafa Sharaf

Flutter Developer interested in building practical software solutions for real-world business and healthcare workflows.

### Project

**IntelliPharm — Smart Pharmaceutical Management System**

GitHub Repository:

[Mustafa-Sharaf/IntelliPharm](https://github.com/Mustafa-Sharaf/IntelliPharm?utm_source=chatgpt.com)

---

## ⭐ Support the Project

If you find IntelliPharm useful or interesting:

* ⭐ Star the repository
* 🍴 Fork the project
* 🐛 Report issues
* 💡 Suggest improvements
* 🤝 Contribute to the project

---

<p align="center">
  <strong>IntelliPharm</strong>
  <br />
  Smart technology for smarter pharmaceutical operations.
</p>


