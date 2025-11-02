Auth — README

An Android / Expo-auth themed authentication demo (Email/Password, Google Sign-In, Phone OTP)

This README documents everything a reviewer or developer would expect to see for a Firebase-based authentication app: architecture, required Firebase console steps, Android & iOS setup, required files, dependencies, important config values (SHA-1, Web Client ID), how the flows work (email/password, Google, phone OTP), testing steps, and troubleshooting tips.

Table of contents

Project overview

Features

Architecture / Files of interest

Firebase Console Setup (step-by-step)

Android setup (gradle / files / SHA-1)

iOS setup (if building for iOS)

Google Sign-In details (Web client ID)

Phone OTP specifics (reCAPTCHA / number testing)

Local build & run instructions

Testing checklist

Security & rules

Troubleshooting & common errors

Screenshots & deliverables

License

Project overview

This project demonstrates a complete user authentication UX with the following flows implemented (UI + wiring to Firebase API calls):

Email / Password (signup, login, reset password)

Google sign-in (One-tap / OAuth)

Phone OTP sign-in (SMS OTP)

Simple Home screen with user info and Logout

The UI is built with React Native (Expo) / Android Jetpack Compose variants in the project — whichever build you are using. The README focuses on what is needed to connect this to Firebase so the auth flows work end-to-end.

Features

SignUp (email + password)

SignIn (email + password)

Reset password (email)

Sign in with Google

Phone number sign-in with OTP

Save minimal user record to Firestore (users/{uid})

Home screen that displays Hello <name/email> and a logout button

Architecture & files of interest

(Adjust to your project structure; these are typical file locations.)

Android (Kotlin + Compose)

app/src/main/AndroidManifest.xml

app/src/main/java/.../MainActivity.kt

app/src/main/java/.../auth/AuthViewModel.kt

app/src/main/java/.../auth/LoginScreen.kt, SignupScreen.kt, HomeScreen.kt, AppNavigation.kt

app/google-services.json (Android)

Gradle files: build.gradle.kts (project level) and app/build.gradle.kts

Expo / React Native

app/index.js (or app/Login.js, app/Home.js with Expo Router)

app/_layout.js (Expo Router)

app/screens/* (Login, Signup, Forgot, OTP, Home)

google-services.json (Android), GoogleService-Info.plist (iOS) placed in respective platform folders

package.json (with firebase dependency if using web SDK in React Native web + Firebase JS SDK)

Firebase

Auth (Email/Password, Google, Phone)

Firestore (light user profile storage)

Cloud rules as in firestore.rules (simple secure rules shown below)

Firebase Console Setup (step-by-step)

Create Firebase Project

Console → Add project → give it a name → follow steps (Analytics optional).

Register app(s)

For Android: Add Android app and enter your package name (e.g. com.example.authapp).

You will get google-services.json to download.

Add SHA-1 (see below).

For iOS (optional): Add iOS app, bundle id, download GoogleService-Info.plist.

Enable Authentication Providers

Authentication → Sign-in method:

Email/Password → enable

Google → enable (you will need Web client ID for some flows)

Phone → enable (for production requires reCAPTCHA setup for web; Android/iOS have specific requirements)

Create OAuth client (if needed)

For Google sign-in you may need a Web client OAuth credential from Google Cloud Console linked to Firebase. Use it as the server/web client ID in the sign-in configuration (One-Tap / GoogleIdToken request uses the Web client ID).

Firestore

Create a Firestore database (test mode for dev). Document structure: users/{uid}.

Add simple rules for authenticated users (example later).

Download config files

Save google-services.json to app/ (Android) or relevant path.

Save GoogleService-Info.plist to iOS project.

Android setup (Gradle / Files / SHA-1)

1. Place google-services.json:

app/google-services.json


Gradle plugin checks these locations:

app/src/google-services.json

app/google-services.json

app/src/debug/google-services.json

2. Add SHA-1 (required for Phone auth & Google)

Generate debug SHA-1:

Using Gradle: ./gradlew signingReport from project root (or .\gradlew signingReport on Windows PowerShell).

Or use keytool on your debug keystore (typically at ~/.android/debug.keystore):

keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android


Copy the SHA-1 value into Firebase Console → Project settings → Your apps → Add fingerprint.

3. Gradle setup (app-level)

Apply Google services plugin and the Firebase BoM + auth dependencies.

Example app/build.gradle.kts (Kotlin DSL) snippet:

plugins {
    id("com.android.application")
    kotlin("android")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.authapp"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.authapp"
        minSdk = 23
        targetSdk = 36
        // ...
    }
    // ...
}

dependencies {
    // Firebase BoM: keeps compatible versions
    implementation(platform("com.google.firebase:firebase-bom:33.4.0"))

    // Firebase Auth (no explicit version when using BOM)
    implementation("com.google.firebase:firebase-auth-ktx")

    // Firestore
    implementation("com.google.firebase:firebase-firestore-ktx")

    // Play Services (Google sign-in)
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}


Also build.gradle (project-level) must include:

buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.3.15")
    }
}


(or in plugins DSL: id("com.google.gms.google-services"))

4. AndroidManifest

Ensure INTERNET permission:

<uses-permission android:name="android.permission.INTERNET" />


5. Firebase initialization
If using firebase-auth-ktx the plugin reads google-services.json automatically. No manual init is required in most modern setups, but you can initialize explicitly:

// in Application onCreate
FirebaseApp.initializeApp(this)

iOS setup (if building for iOS)

Add GoogleService-Info.plist to Xcode project.

Enable Push Notifications or necessary entitlements when using Phone auth features on iOS (if needed).

CocoaPods: pod install in ios/ after adding Firebase pods.

Google Sign-In details (Web client ID)

In Google Cloud Console → Credentials → create OAuth 2.0 Client IDs:

Web application: gives you a Web client ID (required for OneTap / ID token flow).

Android: create an OAuth client with your package name & SHA-1.

Copy the Web client ID into your OneTap / BeginSignInRequest builder:

BeginSignInRequest.GoogleIdTokenRequestOptions.builder()
    .setSupported(true)
    .setServerClientId("YOUR_WEB_CLIENT_ID.apps.googleusercontent.com")


In Firebase Console → Authentication → Sign-in method → Google, paste the Web client ID if requested.

Phone OTP specifics (Android)

Add SHA-1 to Firebase (Phone auth on Android requires it).

Use test phone numbers in Firebase Console for development (so you don't use real SMS).

If using SafetyNet / reCAPTCHA fallback, ensure those configurations are set in Google Cloud Console for web flows. On Android the client SDK handles reCAPTCHA/phone verification automatically if SHA-1 is present.

Local build & run instructions

Android (native Kotlin Compose)

Put google-services.json in app/.

Ensure minSdk >= required (Firebase Auth may require minSdk 23 depending on versions).

Run:

./gradlew clean
./gradlew assembleDebug


or run from Android Studio Run ▶️.

Expo / React Native

Place google-services.json (Android) and GoogleService-Info.plist (iOS) in correct places if you plan to use native Firebase SDKs. For Expo Go (pure JS based), you typically use firebase JS SDK (web) and not the native google-services files unless using EAS build / Bare workflow.

Start dev server:

npx expo start -c

Testing checklist

 Email signup: create new account → verify user created in Firebase Console

 Email login: sign in → home screen shows user email/name

 Reset password: UI calls sendPasswordResetEmail() → receive reset mail (or validate console)

 Google sign-in: sign-in → UID appears in Firebase Auth users and Firestore user doc

 Phone OTP: test OTP flow with Firebase test numbers → verify sign-in

 Logout: sign out clears UI and returns to login screen

Firestore security rules (example)

Save as firestore.rules in repo:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Allow a signed-in user to read/write their own profile
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Default deny all
    match /{document=**} {
      allow read, write: if false;
    }
  }
}

Troubleshooting & common errors

No matching client found for package name 'com.example.xxx'

Make sure google-services.json has a client entry with the exact package name (applicationId) you use in Gradle. If not, register the correct package name in Firebase console and download the new google-services.json.

File google-services.json is missing

Place the file at app/google-services.json and re-run sync.

uses-sdk:minSdkVersion 21 cannot be smaller than version 23 declared in library firebase-auth

Increase minSdk to the required value in app/build.gradle (e.g., minSdk = 23) or choose a compatible firebase-auth version.

Gradle AAR metadata: compileSdk mismatch

Update compileSdk to the recommended value (e.g., 36) in android block.

Google Sign-In token validation fails

Use correct Web client ID (not the Android client ID) for ID token verification on server / Google OneTap flows.

Phone auth SMS not delivered

Use Firebase Console test phone numbers for local testing.

Ensure SHA-1 fingerprint is added.

Gradle / daemon crashes

Ensure JDK and Android Studio are compatible. Use JDK 17 for modern Android Studio builds; clear Gradle daemon / caches if needed.

Example code snippets

Sign up (Kotlin):

FirebaseAuth.getInstance()
    .createUserWithEmailAndPassword(email, password)
    .addOnSuccessListener { authResult ->
        val user = authResult.user
        // Save to Firestore if needed
    }
    .addOnFailureListener { exc -> /* show message */ }


Login (Kotlin):

FirebaseAuth.getInstance()
    .signInWithEmailAndPassword(email, password)
    .addOnSuccessListener { /* navigate to home */ }
    .addOnFailureListener { /* show error */ }


Send password reset:

FirebaseAuth.getInstance().sendPasswordResetEmail(email)


Handle Google ID token sign-in (Kotlin):

val credential = GoogleAuthProvider.getCredential(idToken, null)
FirebaseAuth.getInstance().signInWithCredential(credential)
    .addOnCompleteListener { task -> /* handle success/failure */ }


Phone auth (Kotlin, simplified):

PhoneAuthProvider.verifyPhoneNumber(
    PhoneAuthOptions.newBuilder(FirebaseAuth.getInstance())
        .setPhoneNumber(phone)
        .setTimeout(60L, TimeUnit.SECONDS)
        .setActivity(activity)
        .setCallbacks(callbacks)
        .build()

