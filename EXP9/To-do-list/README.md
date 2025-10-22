📘 README: React Native To-Do App with SQLite History
📝 Overview
This is a simple React Native to-do list app built with Expo SDK 53. It uses SQLite for persistent storage of completed tasks, allowing users to track their task history even after restarting the app.
🚀 Features
- Add and remove tasks
- Tap to mark tasks as completed
- Completed tasks are saved in SQLite
- History tab shows all previously completed tasks
- Native build support for Android (expo run:android)
🛠️ Technologies Used
- Expo SDK 53
- React Native
- expo-sqlite
- TypeScript
📦 Installation
- Clone the repository or create a new Expo project:
npx create-expo-app to-do-list --template blank
cd to-do-list
- Install SQLite:
npx expo install expo-sqlite
- Paste the app code into App.tsx (create this file if it doesn't exist).
- Ensure index.ts loads App.tsx:
import { registerRootComponent } from 'expo';
import App from './App';

registerRootComponent(App);
📱 Running the App
SQLite only works in native builds — not in Expo Go.

- Connect your Android device via USB
- Enable Developer Mode and USB Debugging
- Run the app:
npx expo run:android
