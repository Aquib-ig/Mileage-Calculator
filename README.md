# mileage_calculator

Setup Instructions
1) Clone the repository

git clone https://github.com/your-username/mileage-calculator.git
cd mileage-calculator

2) Install dependencies

flutter pub get

3️)Configure Firebase

Create a Firebase project at Firebase Console.

Enable Authentication (e.g., Email/Password or Anonymous).

Enable Cloud Firestore.

Download the google-services.json (for Android) and/or GoogleService-Info.plist (for iOS) and place them:

Android: android/app/google-services.json

iOS: ios/Runner/GoogleService-Info.plist

4️) Run the app

Tools & Packages Used

firebase_core — Firebase initialization
firebase_auth — Authentication
cloud_firestore — Firestore database
intl — Date formatting
provider — State management
logger — Logging
