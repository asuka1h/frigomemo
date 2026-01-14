# Firebase Setup Instructions

## Database Information

**Current Database:** The app now uses **Firebase Firestore** (cloud database) instead of UserDefaults (local storage).

- **Firestore**: A NoSQL cloud database that stores data in collections and documents
- **Firebase Authentication**: Handles user login/signup securely
- **Data Structure**: Each user's food items are stored in `users/{userId}/foodItems/{itemId}`

## Setup Steps

### 1. Add Firebase to Your Xcode Project

1. Open your project in Xcode
2. Go to **File → Add Package Dependencies...**
3. Enter this URL: `https://github.com/firebase/firebase-ios-sdk`
4. Click **Add Package**
5. Select these products:
   - ✅ **FirebaseAuth**
   - ✅ **FirebaseFirestore**
   - ✅ **FirebaseCore**
6. Click **Add Package**

### 2. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project** (or select existing project)
3. Follow the setup wizard
4. Register your iOS app:
   - Bundle ID: `com.asuka1h.Frigomemo` (check your project settings)
   - App nickname: Frigomemo
   - Download `GoogleService-Info.plist`

### 3. Add GoogleService-Info.plist

1. Drag the downloaded `GoogleService-Info.plist` file into your Xcode project
2. Make sure it's added to the **Frigomemo** target
3. Place it in the `Frigomemo` folder (same level as other Swift files)

### 4. Enable Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Enable **Email/Password** sign-in method
4. Click **Save**

### 5. Set Up Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click **Create Database**
3. Choose **Start in test mode** (for development)
4. Select a location (choose closest to your users)
5. Click **Enable**

### 6. (Optional) Set Up Security Rules

For production, update Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/foodItems/{itemId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Features Added

✅ **User Authentication**
- Email/password sign up
- Email/password sign in
- Secure logout

✅ **Cloud Database**
- Food items sync across all devices
- Real-time updates
- Data persists even if app is deleted

✅ **Data Structure**
- Each user has their own collection of food items
- Items are automatically synced when added/updated/deleted

## Testing

1. Build and run the app
2. You'll see the login screen first
3. Tap "Sign Up" to create an account
4. After signing in, your food items will sync to the cloud
5. Logout and login again - your data will be there!

## Troubleshooting

- **Build errors**: Make sure all Firebase packages are added correctly
- **Authentication errors**: Check that Email/Password is enabled in Firebase Console
- **Database errors**: Verify Firestore is created and rules allow authenticated users
