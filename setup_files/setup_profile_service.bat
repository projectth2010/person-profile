@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=profile-service
SET SERVICE_DIR=%BASE_DIR%services\%SERVICE_NAME%

:: Create directories
mkdir %BASE_DIR%services
mkdir %SERVICE_DIR%
mkdir %SERVICE_DIR%\src
mkdir %SERVICE_DIR%\src\controllers
mkdir %SERVICE_DIR%\src\services
mkdir %SERVICE_DIR%\src\repositories
mkdir %SERVICE_DIR%\src\routes
mkdir %SERVICE_DIR%\src\models
mkdir %SERVICE_DIR%\src\middlewares
mkdir %SERVICE_DIR%\src\utils

:: Create package.json
echo { > %SERVICE_DIR%\package.json
echo   "name": "%SERVICE_NAME%", >> %SERVICE_DIR%\package.json
echo   "version": "1.0.0", >> %SERVICE_DIR%\package.json
echo   "main": "src/index.js", >> %SERVICE_DIR%\package.json
echo   "scripts": { >> %SERVICE_DIR%\package.json
echo     "start": "node src/index.js" >> %SERVICE_DIR%\package.json
echo   }, >> %SERVICE_DIR%\package.json
echo   "dependencies": { >> %SERVICE_DIR%\package.json
echo     "express": "^4.17.1", >> %SERVICE_DIR%\package.json
echo     "mongoose": "^5.11.15", >> %SERVICE_DIR%\package.json
echo     "dotenv": "^8.2.0" >> %SERVICE_DIR%\package.json
echo   } >> %SERVICE_DIR%\package.json
echo } >> %SERVICE_DIR%\package.json

:: Create Dockerfile
echo FROM node:18 > %SERVICE_DIR%\Dockerfile
echo WORKDIR /usr/src/app >> %SERVICE_DIR%\Dockerfile
echo COPY package*.json ./ >> %SERVICE_DIR%\Dockerfile
echo RUN npm install >> %SERVICE_DIR%\Dockerfile
echo COPY . . >> %SERVICE_DIR%\Dockerfile
echo CMD ["node", "src/index.js"] >> %SERVICE_DIR%\Dockerfile

:: Create .env file
echo PORT=3002 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/profile_db >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const profileRoutes = require('./routes/profileRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/profile', profileRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Profile service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create Profile model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\profile.js
echo const profileSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\profile.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\profile.js
echo   firstName: { type: String, required: true }, >> %SERVICE_DIR%\src\models\profile.js
echo   lastName: { type: String, required: true }, >> %SERVICE_DIR%\src\models\profile.js
echo   age: { type: Number, required: true }, >> %SERVICE_DIR%\src\models\profile.js
echo   address: { >> %SERVICE_DIR%\src\models\profile.js
echo     street: { type: String, required: true }, >> %SERVICE_DIR%\src\models\profile.js
echo     city: { type: String, required: true }, >> %SERVICE_DIR%\src\models\profile.js
echo     state: { type: String, required: true }, >> %SERVICE_DIR%\src\models\profile.js
echo     zip: { type: String, required: true } >> %SERVICE_DIR%\src\models\profile.js
echo   }, >> %SERVICE_DIR%\src\models\profile.js
echo   profileImage: { type: String, required: false } >> %SERVICE_DIR%\src\models\profile.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\profile.js
echo module.exports = mongoose.model('Profile', profileSchema); >> %SERVICE_DIR%\src\models\profile.js

:: Create profileController
echo const profileService = require('../services/profileService'); > %SERVICE_DIR%\src\controllers\profileController.js
echo exports.createProfile = async (req, res) => { >> %SERVICE_DIR%\src\controllers\profileController.js
echo   try { >> %SERVICE_DIR%\src\controllers\profileController.js
echo     const profile = await profileService.createProfile(req.body); >> %SERVICE_DIR%\src\controllers\profileController.js
echo     res.status(201).json(profile); >> %SERVICE_DIR%\src\controllers\profileController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\profileController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\profileController.js
echo   } >> %SERVICE_DIR%\src\controllers\profileController.js
echo }; >> %SERVICE_DIR%\src\controllers\profileController.js
echo exports.getProfile = async (req, res) => { >> %SERVICE_DIR%\src\controllers\profileController.js
echo   try { >> %SERVICE_DIR%\src\controllers\profileController.js
echo     const profile = await profileService.getProfile(req.params.userId); >> %SERVICE_DIR%\src\controllers\profileController.js
echo     res.status(200).json(profile); >> %SERVICE_DIR%\src\controllers\profileController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\profileController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\profileController.js
echo   } >> %SERVICE_DIR%\src\controllers\profileController.js
echo }; >> %SERVICE_DIR%\src\controllers\profileController.js

:: Create profileService
echo const profileRepository = require('../repositories/profileRepository'); > %SERVICE_DIR%\src\services\profileService.js
echo exports.createProfile = async (profileData) => { >> %SERVICE_DIR%\src\services\profileService.js
echo   return await profileRepository.createProfile(profileData); >> %SERVICE_DIR%\src\services\profileService.js
echo }; >> %SERVICE_DIR%\src\services\profileService.js
echo exports.getProfile = async (userId) => { >> %SERVICE_DIR%\src\services\profileService.js
echo   return await profileRepository.findProfileByUser(userId); >> %SERVICE_DIR%\src\services\profileService.js
echo }; >> %SERVICE_DIR%\src\services\profileService.js

:: Create profileRepository
echo const Profile = require('../models/profile'); > %SERVICE_DIR%\src\repositories\profileRepository.js
echo exports.createProfile = async (profileData) => { >> %SERVICE_DIR%\src\repositories\profileRepository.js
echo   const profile = new Profile(profileData); >> %SERVICE_DIR%\src\repositories\profileRepository.js
echo   return await profile.save(); >> %SERVICE_DIR%\src\repositories\profileRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\profileRepository.js
echo exports.findProfileByUser = async (userId) => { >> %SERVICE_DIR%\src\repositories\profileRepository.js
echo   return await Profile.findOne({ user: userId }); >> %SERVICE_DIR%\src\repositories\profileRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\profileRepository.js

:: Create profileRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\profileRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\profileRoutes.js
echo const profileController = require('../controllers/profileController'); >> %SERVICE_DIR%\src\routes\profileRoutes.js
echo router.post('/create', profileController.createProfile); >> %SERVICE_DIR%\src\routes\profileRoutes.js
echo router.get('/:userId', profileController.getProfile); >> %SERVICE_DIR%\src\routes\profileRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\profileRoutes.js

:: End of script
echo Profile service setup complete.
PAUSE
