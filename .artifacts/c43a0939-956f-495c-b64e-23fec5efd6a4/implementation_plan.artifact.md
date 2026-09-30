# Implementation Plan - OgaFix Multi-Device Integration & Real-Time Sync

Enhance OgaFix for robust multi-device testing (Customer & Professional physical devices), persistent auth sessions, Firestore-backed professional discovery, real-time chat, clickable phone dialer, avatar-first profile images, and mandatory onboarding for all new users.

## User Review Required

> [!IMPORTANT]
> - **Mandatory Onboarding**: All new users (email, phone OTP, or Google sign-in) without an existing Firestore profile will be forced through the `ProfileOnboardingScreen`.
> - **Persistent Sessions**: `SplashScreen` will check `FirebaseAuth.instance.currentUser` and route returning users directly to their dashboards.
> - **Firestore Live Sync**: Customer home screen will query real-time professionals from Firestore `professional_profiles`.
> - **Clickable Phone Dialer**: Phone numbers will launch the device phone dialer using `url_launcher`.

## Proposed Changes

### [Authentication & Session Persistence]
- #### [MODIFY] [splash_screen.dart](file:///C:/Users/willi/AndroidStudioProjects/ogafix/lib/screens/splash_screen.dart)
  - Check `FirebaseAuth.instance.currentUser` and Firestore profile status on startup to persist login sessions across app restarts.
- #### [MODIFY] [login_screen.dart](file:///C:/Users/willi/AndroidStudioProjects/ogafix/lib/screens/auth/login_screen.dart) & [signup_screen.dart](file:///C:/Users/willi/AndroidStudioProjects/ogafix/lib/screens/auth/signup_screen.dart)
  - Ensure Google Sign-In and email/phone authentication correctly inspect Firestore and force onboarding if profile is missing.

### [Profile & Avatar Management]
- #### [MODIFY] [user_profile_screen.dart](file:///C:/Users/willi/AndroidStudioProjects/ogafix/lib/screens/profile/user_profile_screen.dart)
  - Replace hardcoded Unsplash images with a clean avatar placeholder (`CircleAvatar` with initials or icon) until a custom profile picture is uploaded.
  - Implement clickable phone dialer (`url_launcher`).
  - Set initial job statuses to empty (`[]`), horizontally scrollable, rounded chips.

### [Real-Time Professional Discovery & Chat]
- #### [MODIFY] [customer_home_screen.dart](file:///C:/Users/willi/AndroidStudioProjects/ogafix/lib/screens/customer/customer_home_screen.dart)
  - Stream/query live professional profiles from Firestore `professional_profiles` collection so real professionals registered on other devices appear instantly.
  - Add prominent **"Chat with Professional"** button opening `ChatScreen`.

## Verification Plan

### Automated Tests
- Run `flutter analyze` to ensure zero compilation or type errors.

### Manual Verification
- Deploy to two devices (Customer & Professional):
  1. Sign up/In on Device A as Professional -> Complete onboarding.
  2. Open Device B as Customer -> See Professional appear live in discovery -> Tap profile -> Initiate real-time chat & tap phone dialer.
