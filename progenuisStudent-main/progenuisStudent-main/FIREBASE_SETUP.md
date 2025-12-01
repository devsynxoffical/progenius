# Firebase Setup Instructions

## Prerequisites
You need to create a Firebase project and add the configuration files.

## Steps to Enable Firebase

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Enter project name: "ProGenius"
4. Follow the setup wizard

### 2. Add Android App
1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.student.progenuis`
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### 3. Update Android Configuration

Add to `android/build.gradle`:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

Add to `android/app/build.gradle`:
```gradle
plugins {
    id 'com.google.gms.google-services'
}
```

### 4. Enable Crashlytics
1. In Firebase Console, go to Crashlytics
2. Click "Enable Crashlytics"
3. Follow setup instructions

### 5. Test Firebase
Run the app and check Firebase Console for:
- Analytics events
- Crash reports (force a test crash)

## If Firebase is Not Available
If you don't have `google-services.json`, the app will still work!
The Firebase initialization is wrapped in a try-catch block and will gracefully fail.

## Current Status
- ✅ Firebase dependencies added to `pubspec.yaml`
- ✅ Firebase initialization code added to `main.dart`
- ⏳ Waiting for `google-services.json` file
