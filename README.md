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

## 📷 Screenshots

<img src="https://github.com/user-attachments/assets/ba7c0e59-9726-4a31-9047-01f87dd18ef5" width="245" height="533" />
<img src="https://github.com/user-attachments/assets/7eed6fa1-f08f-4b27-87d0-1fd2d9ba9deb" width="245" height="533" />
<img src="https://github.com/user-attachments/assets/3bd78483-c161-45f0-9a2b-fb7e3b0b85f3" width="245" height="533" />
<img src="https://github.com/user-attachments/assets/50b5d399-9c8b-4015-967d-b12b8bc945c4" width="245" height="533" />
<img src="https://github.com/user-attachments/assets/1f1ad0be-e42b-49fb-b952-2581b8ce535b" width="245" height="533" />

## 📽️ Preview

![](https://github.com/user-attachments/assets/0cf43769-56d7-438f-bf7d-b4ae77c98689)

## 📌 Features

### ✅ Multi-Step Onboarding Process

- **Step 1:** Business Details (Name, Type, Industry)
- **Step 2:** Profile & Contact Details (User Name, Role, Email, Phone)
- **Step 3:** Business Operations (Industry, Employee Count, Revenue)
- **Step 4:** Legal & Tax Information (GSTIN, Registration Number)
- **Step 5:** Review & Complete

### ✅ PAN Verification via API Integration

- Uses an external PAN verification API to validate PAN numbers.
- Users input their PAN, and the app fetches validation status from the API.
- Displays verification success/failure messages.


### ✅ Simulated Email & Phone Verification
- Email Verification:
    - A 6-digit verification code is simulated and displayed in the terminal/console.
    - Users enter the code to verify their email.
    - Resend functionality with a countdown timer.

- Phone Verification:
    - A 4-digit OTP is simulated and displayed in the terminal/console.
    - Users enter the OTP to verify their phone number.
    - Resend functionality with a countdown timer.


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
- **http** (^0.13.4) → API requests

## 🚀 Setup & Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/DJamesSmith/flutter_b2b_onboarding.git
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

---

Built with passion and precision using Flutter.