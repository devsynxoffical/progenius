# Railway Deployment Guide for ProGenius Backend

## 🚂 What is Railway?

Railway is a modern platform for deploying applications with:
- Automatic deployments from GitHub
- Built-in MongoDB database
- Environment variable management
- Free tier available ($5 credit/month)

---

## 📋 Prerequisites

1. GitHub account with ProGenius repository
2. Railway account (sign up at https://railway.app)
3. Backend code pushed to GitHub

---

## 🚀 Step-by-Step Deployment

### Step 1: Sign Up for Railway

1. Go to https://railway.app
2. Click "Login" → "Login with GitHub"
3. Authorize Railway to access your GitHub

### Step 2: Create New Project

1. Click "New Project"
2. Select "Deploy from GitHub repo"
3. Choose `devsynxoffical/progenius`
4. Select the `backend` folder as the root directory

### Step 3: Add MongoDB Database

1. In your Railway project, click "New"
2. Select "Database" → "Add MongoDB"
3. Railway will create a MongoDB instance
4. Copy the connection string (you'll need this)

### Step 4: Configure Environment Variables

1. Click on your backend service
2. Go to "Variables" tab
3. Add these variables:

```env
PORT=8000
NODE_ENV=production

# MongoDB (from Railway MongoDB service)
MONGODB_URI=mongodb://mongo:XXXXX@containers-us-west-XXX.railway.app:XXXX

# JWT Secrets (generate random strings)
ACCESS_TOKEN_SECRET=your-super-secret-access-token-key-here
SHORT_TOKEN_SECRET=your-short-token-secret-here
HASH_SECRET=your-hash-secret-here

# SMTP (for email - use your email service)
SMTP_HOST=smtp.gmail.com
SMTP_SUPPORT_USER_EMAIL=your-email@gmail.com
SMTP_USER_PASS=your-app-password

# Frontend URL (update after deployment)
FRONTEND_URL=https://yourdomain.com
```

### Step 5: Configure Build Settings

1. Go to "Settings" tab
2. Set "Root Directory" to `backend`
3. Set "Build Command": `npm install`
4. Set "Start Command": `npm start`

### Step 6: Deploy

1. Click "Deploy"
2. Railway will automatically build and deploy
3. Wait for deployment to complete (2-5 minutes)

### Step 7: Get Your Backend URL

1. Go to "Settings" → "Domains"
2. Click "Generate Domain"
3. You'll get a URL like: `https://progenius-backend-production.up.railway.app`

---

## 🔧 Railway Configuration Files

### Create `railway.json` in backend folder:

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "npm start",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### Update `package.json`:

Make sure you have:

```json
{
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

---

## 🔗 Connecting MongoDB

Railway provides a MongoDB connection string. Update your code to use it:

### Option 1: Use Railway's Internal URL

Railway provides an internal MongoDB URL. Use the `MONGODB_URI` from Railway variables.

### Option 2: Use MongoDB Atlas (Recommended for Production)

1. Create free account at https://www.mongodb.com/cloud/atlas
2. Create a cluster
3. Get connection string
4. Add to Railway environment variables

---

## 📱 Update Flutter Apps

After deployment, update your Flutter apps:

### Student App

Edit `lib/student/utils/Api_Services/Urls.dart`:

```dart
static const baseUrls = "https://your-railway-url.up.railway.app/v1";
```

### Admin App

Edit `lib/utils/apiUrls.dart`:

```dart
static const baseUrls = "https://your-railway-url.up.railway.app/v1";
```

---

## 🔒 Security Checklist

### 1. Update CORS in `index.js`:

```javascript
const allowedUrls = [
  "https://your-frontend-domain.com",
  process.env.FRONTEND_URL
];

app.use(cors({
  origin: allowedUrls,
  credentials: true,
}));
```

### 2. Add Security Headers

Already done if you implemented `SECURITY_IMPROVEMENTS.md`

### 3. Enable HTTPS

Railway automatically provides HTTPS ✅

---

## 📊 Monitoring & Logs

### View Logs

1. Go to your Railway project
2. Click on backend service
3. Click "Deployments" tab
4. Click on latest deployment
5. View real-time logs

### Monitor Resources

1. Go to "Metrics" tab
2. View CPU, Memory, Network usage

---

## 💰 Pricing

### Free Tier
- $5 credit/month
- Good for development/testing
- Sleeps after 30 minutes of inactivity

### Paid Plans
- $5/month for Hobby plan
- $20/month for Pro plan
- No sleep, better resources

---

## 🔄 Automatic Deployments

Railway automatically deploys when you push to GitHub:

```powershell
git add .
git commit -m "Update backend"
git push origin main
# Railway automatically deploys! 🚀
```

---

## 🐛 Troubleshooting

### Deployment Failed

1. Check build logs in Railway
2. Verify `package.json` has correct scripts
3. Check environment variables

### Database Connection Error

1. Verify `MONGODB_URI` is correct
2. Check MongoDB service is running
3. Test connection locally first

### App Not Starting

1. Check start command: `npm start`
2. Verify `index.js` exists
3. Check logs for errors

---

## 📝 Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `PORT` | Server port | `8000` |
| `NODE_ENV` | Environment | `production` |
| `MONGODB_URI` | MongoDB connection | `mongodb://...` |
| `ACCESS_TOKEN_SECRET` | JWT secret | Random string |
| `SHORT_TOKEN_SECRET` | Short token secret | Random string |
| `HASH_SECRET` | Hash secret | Random string |
| `SMTP_HOST` | Email server | `smtp.gmail.com` |
| `SMTP_SUPPORT_USER_EMAIL` | Email address | `your@email.com` |
| `SMTP_USER_PASS` | Email password | App password |
| `FRONTEND_URL` | Frontend URL | `https://yourdomain.com` |

---

## 🎯 Post-Deployment Checklist

- [ ] Backend deployed successfully
- [ ] MongoDB connected
- [ ] Environment variables set
- [ ] CORS configured
- [ ] Flutter apps updated with new URL
- [ ] Test all API endpoints
- [ ] Monitor logs for errors
- [ ] Set up custom domain (optional)

---

## 🌐 Custom Domain (Optional)

1. Buy domain from Namecheap/GoDaddy
2. In Railway, go to Settings → Domains
3. Click "Custom Domain"
4. Add your domain
5. Update DNS records as instructed
6. Wait for DNS propagation (24-48 hours)

---

## 📚 Additional Resources

- Railway Docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway
- MongoDB Atlas: https://www.mongodb.com/cloud/atlas

---

## ✅ Success!

Your backend is now live on Railway! 🎉

**Next Steps:**
1. Test all endpoints
2. Update Flutter apps
3. Build and release APKs
4. Monitor performance
