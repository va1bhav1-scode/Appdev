NeoAuth
NeoAuth is an Android authentication demo app built with Jetpack Compose.
It demonstrates a complete authentication flow (Email/Password, Google Sign-In, Phone OTP, password reset) and guarded navigation (login/signup vs protected home screen), integrated with Firebase Authentication and Firestore for user meta storage.
This README explains how to configure the Firebase project, prepare your Android project, run the app on a device/emulator, and troubleshoot common problems.
Features

Email / Password authentication (sign up, sign in, password reset)

Google Sign-In (One-tap / Identity SDK)

Phone OTP style screens (UI only or integrated if enabled in Firebase)

Auth state observer: app shows Auth stack vs App stack

Protected Home / Dashboard only accessible when signed in

Firestore user document creation after Google sign-in

Error handling for common auth errors (invalid email, weak password, user not found)
Project structure (high level)
app/
  src/main/java/com/example/neoauth/
    MainActivity.kt
    auth/
      AuthViewModel.kt
      AppNavigation.kt
      LoginScreen.kt
      SignupScreen.kt
      HomeScreen.kt
      ForgotPasswordScreen.kt
      OtpScreen.kt
  src/main/res/...
  google-services.json
build.gradle.kts (project-level)
app/build.gradle.kts (module-level)
README.md
Prerequisites

Android Studio (Arctic Fox / Bumblebee or later recommended; tested with Electric Eel / Giraffe)

JDK 17 (or as required by your Gradle/Android Studio)

Android SDK (compileSdk 36 recommended)

Internet connection

A physical Android device (USB debugging) or emulator with Google Play images
Firebase setup (required)

Go to the Firebase Console
 and create a new project (or use an existing one).

Add an Android app to the project:

Package name must match applicationId in your app/build.gradle.kts (e.g. com.example.neoauth or com.example.authdemoapp).

Add the debug SHA-1 (use .\gradlew signingReport in Windows PowerShell from your project root, or ./gradlew signingReport in macOS/Linux). Copy the SHA-1 from the debug variant and paste in the Firebase app registration.

Download google-services.json and place it in your Android module folder:
app/google-services.json
The Google Services plugin looks for this file in:

app/src/debug/google-services.json

app/src/google-services.json

app/google-services.json
So placing it in app/ is correct.

In Firebase Console → Build → Authentication → Sign-in method:

Enable Email/Password

(Optional) Enable Google

If enabling Google sign-in, create an OAuth 2.0 client ID (Web client ID) inside Google Cloud console for the project, and note the Web client ID — it is required for Identity SDK serverClientId / One Tap.

(Optional) Enable Phone (for OTP). Follow Firebase docs to set quotas and reCAPTCHA/Play Integrity settings.

(Optional) Firestore: enable Firestore if you want to save user metadata.

Android project setup

Project-level build.gradle.kts (example pieces you must have)

buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
    }
}


Module-level app/build.gradle.kts — important parts:

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.neoauth"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.neoauth"
        minSdk = 23
        targetSdk = 36
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }

    buildFeatures { compose = true }
}

dependencies {
    // Compose BOM & core
    implementation(platform("androidx.compose:compose-bom:2024.02.00"))
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.navigation:navigation-compose:2.7.7")

    // Firebase (BOM + Auth)
    implementation(platform("com.google.firebase:firebase-bom:33.4.0"))
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")

    // Google identity / one-tap
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}


Add the permission in AndroidManifest.xml:

<uses-permission android:name="android.permission.INTERNET"/>


Place google-services.json in app/ and sync project.

Run the app

Build and sync Gradle in Android Studio. If you get compileSdk/AAR metadata warnings, set compileSdk to the required version (36) in app/build.gradle.kts.

Run on a device/emulator:

Choose your device in Android Studio and click Run.

Or from terminal:

./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk

Screens & navigation

SplashScreen — app launch / loading

LoginScreen — Email/password fields, "Forgot password", Google Sign-In button, Phone OTP navigation

SignupScreen — create account (email/password)

ForgotPasswordScreen — send password reset email

OtpScreen — phone OTP entry (UI)

HomeScreen — protected dashboard with logout button

Auth flow: AuthStateObserver -> show login/signup stack if no user, else show home stack.

How auth flows work (implementation notes)

Email/Password: auth.createUserWithEmailAndPassword(...) and auth.signInWithEmailAndPassword(...).

Google: use Identity One Tap or GoogleSignInClient to retrieve ID token, then FirebaseAuth.getInstance().signInWithCredential(GoogleAuthProvider.getCredential(idToken, null)).

Phone: Firebase Phone Auth (if enabled) sends SMS and verifies code with PhoneAuthProvider.

Store or update user metadata in Firestore after successful sign-in.
Common errors & fixes

File google-services.json is missing: Place google-services.json into app/ (or app/src/google-services.json) and re-sync.

No matching client found for package name: Ensure package name in google-services.json's client[0].client_info.android_client_info.package_name matches applicationId in app/build.gradle.kts.

uses-sdk:minSdkVersion ... library requires ...: upgrade minSdk or use a compatible Firebase library. Recommended minSdk >= 23.

AAR metadata warnings about compileSdk: set compileSdk to at least the highest required (36).

gradlew signingReport not found on Windows: use .\gradlew signingReport from the project root.

Google SignIn missing web client ID: copy the Web client ID from Google Cloud APIs → Credentials and set in your Identity/OneTap request.

Build daemon crashes / JVM crash: check JDK version and Android Studio JBR; ensure sufficient memory and compatible Java version (JDK 17 recommended).

Testing

Create a test user in Firebase or sign up using the app UI.

Test password reset by clicking "Forgot password" and confirming reset email arrives.

Test Google Sign-In with a real Google account.

Test navigation flows: sign in → home → logout → should return to login, and back button shouldn't return to home.
