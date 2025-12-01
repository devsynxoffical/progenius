# ProGenius - GitHub Repository Setup Guide

## 📁 Repository Structure

Your repository should be organized like this:

```
progenius/
├── backend/              # Node.js/Express backend
├── student-app/          # Flutter student app
├── admin-app/            # Flutter admin app
├── README.md            # Main project README
└── .gitignore           # Git ignore file
```

---

## 🚀 Step-by-Step Upload Guide

### Step 1: Prepare Your Local Repository

Open PowerShell in your project directory:

```powershell
cd "d:\DEVSYNX- Projects\Progenius"
```

### Step 2: Initialize Git (if not already done)

```powershell
git init
```

### Step 3: Create .gitignore

Create a `.gitignore` file in the root directory:

```gitignore
# Backend
backend/node_modules/
backend/.env
backend/uploads/
backend/package-lock.json

# Flutter Student App
student-app/.dart_tool/
student-app/.flutter-plugins
student-app/.flutter-plugins-dependencies
student-app/.packages
student-app/build/
student-app/pubspec.lock
student-app/android/app/google-services.json
student-app/ios/Runner/GoogleService-Info.plist

# Flutter Admin App
admin-app/.dart_tool/
admin-app/.flutter-plugins
admin-app/.flutter-plugins-dependencies
admin-app/.packages
admin-app/build/
admin-app/pubspec.lock
admin-app/android/app/google-services.json
admin-app/ios/Runner/GoogleService-Info.plist

# IDE
.vscode/
.idea/
*.iml

# OS
.DS_Store
Thumbs.db
```

### Step 4: Rename Folders

```powershell
# Rename folders for cleaner structure
Rename-Item -Path "progenuisStudent-main\progenuisStudent-main" -NewName "student-app"
Rename-Item -Path "progenuisAdmin-main\progenuisAdmin-main" -NewName "admin-app"
```

Or manually rename:
- `progenuisStudent-main/progenuisStudent-main` → `student-app`
- `progenuisAdmin-main/progenuisAdmin-main` → `admin-app`

### Step 5: Add Remote Repository

```powershell
git remote add origin https://github.com/devsynxoffical/progenius.git
```

### Step 6: Stage All Files

```powershell
git add .
```

### Step 7: Create Initial Commit

```powershell
git commit -m "Initial commit: ProGenius - Student App, Admin App, and Backend"
```

### Step 8: Push to GitHub

```powershell
# Push to main branch
git branch -M main
git push -u origin main
```

---

## 📝 Create Main README.md

Create a `README.md` in the root directory:

```markdown
# ProGenius - Educational Platform

A complete educational platform with student and admin applications, powered by a Node.js backend.

## 🏗️ Project Structure

- **backend/** - Node.js/Express API server
- **student-app/** - Flutter student application
- **admin-app/** - Flutter admin application

## 🚀 Quick Start

### Backend Setup
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

### Student App Setup
```bash
cd student-app
flutter pub get
flutter run
```

### Admin App Setup
```bash
cd admin-app
flutter pub get
flutter run
```

## 📚 Documentation

- [Backend README](./backend/README.md)
- [Firebase Setup](./student-app/FIREBASE_SETUP.md)
- [Security Improvements](./backend/SECURITY_IMPROVEMENTS.md)

## 🛠️ Tech Stack

### Backend
- Node.js + Express
- MongoDB
- JWT Authentication
- Multer (File uploads)

### Frontend (Student & Admin)
- Flutter
- GetX (State management)
- Firebase (Analytics & Crashlytics)
- Cached Network Image

## 🔐 Environment Variables

See `.env.example` in the backend directory for required environment variables.

## 📱 Features

### Student App
- Course browsing (Free & Paid)
- Video lessons
- PDF viewer
- Quiz module
- Dark mode
- Offline support

### Admin App
- Course management
- Student management
- Chapter & lesson creation
- Analytics dashboard

## 🚀 Deployment

### Backend
Deploy to Railway (see [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md))

### Frontend
Build APK:
```bash
flutter build apk --release
```

## 📄 License

MIT License

## 👥 Contributors

- DevSynx Official
```

---

## ⚠️ Important Notes

### Before Pushing:

1. **Remove Sensitive Data**
   - Make sure `.env` is in `.gitignore`
   - Don't commit `google-services.json`
   - Don't commit API keys

2. **Clean Build Folders**
   ```powershell
   # Clean Flutter build folders
   cd student-app
   flutter clean
   cd ../admin-app
   flutter clean
   ```

3. **Verify .gitignore**
   ```powershell
   git status
   # Make sure no sensitive files are listed
   ```

---

## 🔄 Updating Repository

After making changes:

```powershell
git add .
git commit -m "Your commit message"
git push origin main
```

---

## 🌿 Branch Strategy (Optional)

For better organization:

```powershell
# Create development branch
git checkout -b development

# Create feature branches
git checkout -b feature/quiz-module
git checkout -b fix/video-player

# Merge to main when ready
git checkout main
git merge development
git push origin main
```

---

## 📊 Repository Settings

On GitHub:

1. Go to repository settings
2. Add description: "Educational platform with Flutter apps and Node.js backend"
3. Add topics: `flutter`, `nodejs`, `education`, `mongodb`, `express`
4. Enable Issues for bug tracking
5. Enable Discussions for community

---

## ✅ Verification

After pushing, verify on GitHub:
- All folders are present
- No sensitive files (.env, google-services.json)
- README displays correctly
- .gitignore is working

---

## 🎉 Done!

Your repository is now live at:
https://github.com/devsynxoffical/progenius
