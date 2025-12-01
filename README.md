# ProGenius

A complete educational platform with student and admin applications, powered by a Node.js backend.

## 🏗️ Project Structure

```
progenius/
├── backend/              # Node.js/Express API server
├── student-app/          # Flutter student application  
├── admin-app/            # Flutter admin application
└── docs/                 # Documentation
```

## ✨ Features

### 🎓 Student App
- Browse free and paid courses
- Watch video lessons (YouTube integration)
- Read PDF materials
- Take quizzes
- Dark mode support
- Offline course caching
- Real-time form validation

### 👨‍💼 Admin App
- Manage courses, chapters, and lessons
- Upload videos and PDFs
- Manage student enrollments
- View analytics dashboard
- Student access control

### 🔧 Backend
- RESTful API with Express.js
- MongoDB database
- JWT authentication
- File upload handling
- Role-based access control

## 🚀 Quick Start

### Backend Setup

```bash
cd backend
npm install
cp .env.example .env
# Edit .env with your configuration
npm run dev
```

Server runs on `http://localhost:8000`

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

## 🛠️ Tech Stack

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB with Mongoose
- **Authentication**: JWT
- **File Upload**: Multer
- **Validation**: Joi

### Frontend
- **Framework**: Flutter
- **State Management**: GetX
- **HTTP Client**: Dio & HTTP
- **Caching**: GetStorage, CachedNetworkImage
- **Video Player**: youtube_player_iframe
- **PDF Viewer**: flutter_pdfview, syncfusion_flutter_pdfviewer
- **Analytics**: Firebase Analytics & Crashlytics

## 📚 Documentation

- [GitHub Setup Guide](./GITHUB_SETUP.md)
- [Railway Deployment Guide](./RAILWAY_DEPLOYMENT.md)
- [Backend README](./backend/README.md)
- [Firebase Setup](./student-app/FIREBASE_SETUP.md)
- [Security Improvements](./backend/SECURITY_IMPROVEMENTS.md)

## 🔐 Environment Variables

Create a `.env` file in the backend directory:

```env
PORT=8000
NODE_ENV=development
MONGODB_URI=mongodb://127.0.0.1:27017/progenius
ACCESS_TOKEN_SECRET=your-secret-key
SHORT_TOKEN_SECRET=your-short-secret
HASH_SECRET=your-hash-secret
SMTP_HOST=smtp.gmail.com
SMTP_SUPPORT_USER_EMAIL=your-email@gmail.com
SMTP_USER_PASS=your-app-password
```

## 🚀 Deployment

### Backend (Railway)

1. Push code to GitHub
2. Connect Railway to your repository
3. Add MongoDB database
4. Set environment variables
5. Deploy!

See [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md) for detailed instructions.

### Flutter Apps

Build release APK:

```bash
cd student-app
flutter build apk --release

cd admin-app
flutter build apk --release
```

APKs will be in `build/app/outputs/flutter-apk/`

## 📱 API Endpoints

### Authentication
- `POST /v1/customer/signup` - Register student
- `POST /v1/customer/signin` - Student login
- `POST /v1/admin/signin` - Admin login

### Courses
- `GET /v1/course/free` - Get free courses
- `GET /v1/course/paid` - Get paid courses
- `GET /v1/course/:courseId` - Get course details

### Admin
- `POST /v1/course` - Create course
- `PATCH /v1/course/:courseId` - Update course
- `DELETE /v1/course/:courseId` - Delete course

See backend documentation for complete API reference.

## 🧪 Testing

### Backend
```bash
cd backend
npm test
```

### Flutter
```bash
cd student-app
flutter test
```

## 🐛 Bug Reports

All 12 reported bugs have been fixed! ✅

See [walkthrough.md](./docs/walkthrough.md) for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

**DevSynx Official**
- GitHub: [@devsynxoffical](https://github.com/devsynxoffical)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX for state management
- Railway for easy deployment
- MongoDB for the database

## 📞 Support

For support, email support@devsynx.com or open an issue on GitHub.

---

**⭐ Star this repo if you find it helpful!**
