📱 Stylish Calculator App with Firebase
A modern Flutter calculator app that performs basic arithmetic operations and saves each calculation to Firebase Firestore. Includes a history screen to view past calculations in real time.
🚀 Features
- Elegant calculator UI with custom-styled buttons
- Supports addition, subtraction, multiplication, and division
- Saves each calculation to Firebase Firestore
- Displays calculation history with timestamps
- Integrated with Firebase Analytics for usage tracking
- Responsive layout for Android devices
📦 Dependencies
firebase_core: ^2.27.0
cloud_firestore: ^4.15.0
firebase_analytics: ^10.7.0
math_expressions: ^2.4.0
cupertino_icons: ^1.0.8
🛠️ Setup Instructions
- Clone the repo
git clone https://github.com/your-username/app_calculator.git
cd app_calculator
- Install dependencies
flutter pub get
- Connect Firebase
- Create a Firebase project
- Register your Android app
- Download google-services.json and place it in android/app/
- Update build.gradle.kts files with Firebase plugin
- Run the app
flutter run
📊 Firebase Integration
- Firestore stores each calculation with:
- input: the expression entered
- result: the evaluated output
- timestamp: server time of calculation
- Analytics logs:
- app_started when the app launches
- (You can add more events like button taps or screen views)
