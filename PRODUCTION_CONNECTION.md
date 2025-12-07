# ProGenius Production Connection Guide

## ✅ Connection Status
Both **Student App** and **Admin App** are now connected to the live production backend.

**Live Backend URL:**
`https://progenius-backend-production.up.railway.app`

---

## 🔧 Files Updated

### 1. Student App
**File:** `lib/student/utils/Api_Services/Urls.dart`
```dart
static const baseUrls = "https://progenius-backend-production.up.railway.app/v1";
```

### 2. Admin App
**File:** `lib/utils/apiUrls.dart`
```dart
static const baseUrls = "https://progenius-backend-production.up.railway.app/v1";
```

---

## 🚀 How to Verify

### Step 1: Build Release APK
Since you are using a live HTTPS URL, it is best to test with a release build or on a real device.

```bash
# Student App
cd student-app
flutter build apk --release

# Admin App
cd admin-app
flutter build apk --release
```

### Step 2: Install and Login
1. Install the APKs on your phone.
2. Open the **Student App**.
3. Try to **Sign Up** (this will test connection to the live database).
4. If successful, the app is connected!

### Step 3: Check Admin
1. Open the **Admin App**.
2. Login with your admin credentials.
3. Verify you can see the student you just created.

---

## ⚠️ Important Notes

### 1. Image Uploads
Images uploaded will now be stored on the Railway server (or Cloudinary if configured). **Note:** Railway's ephemeral filesystem wipes files on restart unless you use a persistent volume or external storage (like AWS S3 or Cloudinary).
*Recommendation: Configure Cloudinary or AWS S3 for production file storage.*

### 2. CORS
Ensure your backend environment variables allows requests from your app (usually mobile apps are fine, but if you have a web version, check CORS).

### 3. Database
The app is now using the PRODUCTION database connected to Railway. Local data will not be visible.

---

## 🔄 Switching Back to Local
If you need to develop locally again, comment out the production URL line and uncomment the localhost line in the `Urls.dart` files.

```dart
// Production
// static const baseUrls = "https://progenius-backend-production.up.railway.app/v1";

// Local
static const baseUrls = "http://10.0.2.2:8000/v1";
```
