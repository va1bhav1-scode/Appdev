📋 Firestore To-Do List App
A simple and elegant task management app built with React Native and Firebase Firestore. Users can add and delete tasks in real-time, with data stored securely in the cloud.
🚀 Features
- ✅ Add tasks with a clean UI
- ✅ Delete tasks by tapping on them
- ✅ Real-time sync with Firebase Firestore
- ✅ Works on Expo (web and mobile)
- ✅ Minimal design for fast performance
📦 Installation
git clone https://github.com/your-username/firestore-todo-app.git
cd firestore-todo-app
npm install
npx expo start


💡 To run on web:
npx expo start --web


🔐 Firebase Setup
- Go to Firebase Console
- Create a new project
- Enable Firestore in the project
- Add a Web App and copy the config
- Paste the config into firebaseConfig.js
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "YOUR_PROJECT.firebaseapp.com",
  projectId: "YOUR_PROJECT_ID",
  storageBucket: "YOUR_PROJECT.appspot.com",
  messagingSenderId: "YOUR_SENDER_ID",
  appId: "YOUR_APP_ID"
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);



🔐 Firestore Rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{document=**} {
      allow read, write: if true;
    }
  }
}


✅ This allows full access for testing without authentication.
