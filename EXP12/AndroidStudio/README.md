SecureAuthDemo

SecureAuthDemo is an Android app demonstrating a complete authentication flow using Firebase Authentication (Email/Password, Google Sign-In, Phone OTP). It is built with Jetpack Compose and follows a simple auth-state routing model: unauthenticated users see the auth stack (Login / Signup / Forgot / Phone OTP) and authenticated users see a protected Home screen.

Platform: Android (Jetpack Compose)
Language: Kotlin
Minimum SDK: 24+ (recommended 24+)
Architecture: Single Activity + Navigation Compose + simple ViewModel
Features

Email / Password sign up and sign in

Password reset (email)

Google Sign-In (One Tap / Identity API)

Phone number → OTP flow

Auth state handling: app shows auth screens or protected home screen based on signed-in user

Basic Firestore user document write on social sign-in

Error handling for common auth errors (invalid email, weak password, user-not-found, etc)

Simple UI built in Jetpack Compose (Login, Signup, Forgot Password, Phone, OTP, Home)

Local session management and logout
Firebase Setup (what to do in the Firebase Console)

Create a Firebase project

Go to the Firebase console and create a new project.

Register your Android app

Package name must match your app's applicationId (e.g. com.example.secureauthdemo).

Add your app nickname (optional).

Add SHA-1 and SHA-256 debug keys (for Google sign-in and One Tap).

Generate with .\gradlew signingReport in your project root (Windows PowerShell: .\gradlew signingReport) or ./gradlew signingReport on macOS/Linux.

Copy the SHA-1 value to the Firebase Android app registration.

Download google-services.json

Save it to app/google-services.json (or app/src/debug/google-services.json if you wish).

Make sure it contains the correct client entry with your package name.

Enable Authentication providers

In Firebase console: Build → Authentication → Sign-in method

Enable Email/Password

Enable Google (add your app's OAuth client ID if requested — usually automatically created after registering the Android app; for Web Client ID use for One Tap)

Enable Phone (if using phone authentication; consider reCAPTCHA settings; also enable test phone numbers for development)

(Optional) Firestore

If you want to store user profiles after sign-in, enable Firestore and create rules suitable for your app.

Android Studio / Gradle configuration

Add Google services plugin and Firebase dependencies:

Project-level build.gradle.kts (or build.gradle):

buildscript {
dependencies {
classpath("com.google.gms:google-services:4.3.15")
}
}


App-level build.gradle.kts (important parts):

plugins {
id("com.android.application")
id("org.jetbrains.kotlin.android")
id("com.google.gms.google-services")
}

android {
compileSdk = 36
defaultConfig {
applicationId = "com.example.secureauthdemo"
minSdk = 24
targetSdk = 36
}
buildFeatures { compose = true }
composeOptions { kotlinCompilerExtensionVersion = "1.5.3" }
}

dependencies {
implementation(platform("com.google.firebase:firebase-bom:33.4.0"))
implementation("com.google.firebase:firebase-auth-ktx")
implementation("com.google.firebase:firebase-firestore-ktx")

    // Google Sign In / Identity
    implementation("com.google.android.gms:play-services-auth:20.7.0")

    // Compose and Navigation
    implementation("androidx.compose.material3:material3")
    implementation("androidx.navigation:navigation-compose:2.7.6")
}
apply(plugin = "com.google.gms.google-services")


Put google-services.json in app/ folder and sync Gradle.

If you see errors about minSdkVersion vs Firebase library, ensure minSdk >= library requirement or use compatible versions. Recommended:

minSdk = 23 for recent firebase-auth versions.

How the auth flow is implemented (high level)

AuthViewModel wraps Firebase Auth calls (signInWithEmailAndPassword, createUserWithEmailAndPassword, signInWithCredential for Google, sendPasswordResetEmail, etc.). It exposes isUserLoggedIn() and current user properties.

AppNavGraph observes the auth state and routes between login/signup/forgot/phone/otp and home.

The Login screen provides:

Email/password fields

Login button (calls auth.signInWithEmailAndPassword)

"Forgot password" trigger (calls sendPasswordResetEmail)

Google Sign-In button (starts One Tap / Identity API or Google SignIn flow)

Phone button that starts phone flow (request OTP then verify)

On social sign-in success, a user document is written to Firestore collection users with basic fields.

Common error handling and how we handle them

Invalid email — Firebase returns FirebaseAuthInvalidCredentialsException; show user-friendly message such as "Invalid email format."

Weak password — for signup, Firebase returns FirebaseAuthWeakPasswordException; tell the user to choose a longer/stronger password.

User not found / wrong password — show messages like "Wrong credentials" or "No account found — sign up first."

Network errors — catch FirebaseException or general exceptions and show "Network error — try again."

All errors are surfaced to the UI and displayed using Compose Text with color = MaterialTheme.colorScheme.error.

Security considerations (recommended for real deployments)

Do not store plain-text passwords. Firebase Auth is a managed service — passwords are never returned to client apps.

Use HTTPS/TLS for all backend calls (Firebase does this for you).

Enable Firebase App Check (Play Integrity / SafetyNet) in production to ensure calls come only from legitimate app instances.

For phone auth, enforce reCAPTCHA and rate limiting to prevent abuse.

Secure Firestore rules properly so only authenticated users can access/write appropriate documents.

How to run (developer steps)

Add google-services.json to app/.

Make sure applicationId in build.gradle equals the package name used in Firebase registration.

Add debug SHA-1 in Firebase console (from ./gradlew signingReport).

Sync Gradle.

Run on an emulator or a physical device (for Google sign-in and One Tap, a physical device sometimes works better).

Test sign up / sign in / password reset / phone OTP flows.

UI & UX checklist

Input validation:

Email format checks

Minimum password length (e.g., > 6)

Phone number length checks

Disable buttons while network requests are pending

Clear and actionable error messages

Protected Home screen that requires authentication and has a clear Logout button

Display user info (display name / email) on Home or Profile screen