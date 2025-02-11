# B2B Multi-Step Onboarding & Dashboard App

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

A Flutter-based B2B application with a multi-step onboarding process and a dynamic dashboard for
business users. The app ensures smooth user onboarding and provides a visually engaging experience
with animations and step-by-step data collection.

## 📌 Features

### ✅ Multi-Step Onboarding Process

- **Step 1:** Business Details (Name, Type, Industry)
- **Step 2:** Profile & Contact Details (User Name, Role, Email, Phone)
- **Step 3:** Business Operations (Industry, Employee Count, Revenue)
- **Step 4:** Legal & Tax Information (GSTIN, Registration Number)
- **Step 5:** Review & Complete

### ✅ Local Data Storage

- Utilizes **Shared Preferences** for storing user and business details.

### ✅ Interactive Dashboard

- Displays business profile details.
- Uses animations for a modern UI experience.
- Shows real-time profile and business data.

### ✅ UI Enhancements

- **Shimmer Effect** for loading states.
- **Lottie Animations** for dynamic visuals.

## 📂 Project Structure

```
lib/
  ├── config/               # App configurations (colors, themes)
  ├── constants/            # App-wide constants
  ├── controller/           # GetX controllers for state management
  ├── model/                # Data models for Business & User Profile
  ├── screens/              # All app screens (Onboarding, Dashboard, Profile)
  ├── widgets/              # Reusable UI components
  ├── main.dart             # App entry point
```

## 🛠 Dependencies Used

- **easy_stepper** (^0.8.5+1) → Multi-step
  indicator: [easy_stepper](https://pub.dev/packages/easy_stepper)
- **lottie** (^3.3.1) → Animated assets: [lottie](https://pub.dev/packages/lottie)
- **shimmer** (^3.0.0) → Loading effect: [shimmer](https://pub.dev/packages/shimmer)
- **shared_preferences** (^2.2.2) → Local data storage
- **get** (^4.6.6) → State management

## 🚀 Setup & Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo-url.git
   cd your-project-folder
   ```
2. Install dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

## 📷 Screenshots

<img src="" data-canonical-src="https://github.com/user-attachments/assets/7a4eafbe-59ba-4203-b822-c5c83169ed68" width="245" height="533" />
<img src="" data-canonical-src="https://github.com/user-attachments/assets/b660db23-9d88-4c94-98e9-35084b9334b1" width="245" height="533" />
<img src="" data-canonical-src="https://github.com/user-attachments/assets/50b5d399-9c8b-4015-967d-b12b8bc945c4" width="245" height="533" />
<img src="" data-canonical-src="https://github.com/user-attachments/assets/1f1ad0be-e42b-49fb-b952-2581b8ce535b" width="245" height="533" />

## 📽️ Preview

![](https://github.com/user-attachments/assets/d461d58f-1a97-4ab9-80f4-1a0da5818252)

---

Developed with ❤️ using Flutter.

