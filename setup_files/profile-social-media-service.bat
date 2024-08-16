@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=profile-social-media-service
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
echo PORT=3006 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/profile_social_media_db >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const socialMediaRoutes = require('./routes/socialMediaRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/social-media', socialMediaRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Profile Social Media service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create Social Media model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\socialMedia.js
echo const socialMediaSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\socialMedia.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\socialMedia.js
echo   platform: { type: String, required: true }, >> %SERVICE_DIR%\src\models\socialMedia.js
echo   handle: { type: String, required: true }, >> %SERVICE_DIR%\src\models\socialMedia.js
echo   link: { type: String, required: true } >> %SERVICE_DIR%\src\models\socialMedia.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\socialMedia.js
echo module.exports = mongoose.model('SocialMedia', socialMediaSchema); >> %SERVICE_DIR%\src\models\socialMedia.js

:: Create socialMediaController
echo const socialMediaService = require('../services/socialMediaService'); > %SERVICE_DIR%\src\controllers\socialMediaController.js
echo exports.addSocialMedia = async (req, res) => { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   try { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     const socialMedia = await socialMediaService.addSocialMedia(req.body); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(201).json(socialMedia); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo }; >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo exports.getSocialMedias = async (req, res) => { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   try { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     const socialMedias = await socialMediaService.getSocialMedias(req.params.userId); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(200).json(socialMedias); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo }; >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo exports.updateSocialMedia = async (req, res) => { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   try { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     const socialMedia = await socialMediaService.updateSocialMedia(req.params.socialMediaId, req.body); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(200).json(socialMedia); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo }; >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo exports.deleteSocialMedia = async (req, res) => { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   try { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     await socialMediaService.deleteSocialMedia(req.params.socialMediaId); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(204).end(); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo   } >> %SERVICE_DIR%\src\controllers\socialMediaController.js
echo }; >> %SERVICE_DIR%\src\controllers\socialMediaController.js

:: Create socialMediaService
echo const socialMediaRepository = require('../repositories/socialMediaRepository'); > %SERVICE_DIR%\src\services\socialMediaService.js
echo exports.addSocialMedia = async (socialMediaData) => { >> %SERVICE_DIR%\src\services\socialMediaService.js
echo   return await socialMediaRepository.createSocialMedia(socialMediaData); >> %SERVICE_DIR%\src\services\socialMediaService.js
echo }; >> %SERVICE_DIR%\src\services\socialMediaService.js
echo exports.getSocialMedias = async (userId) => { >> %SERVICE_DIR%\src\services\socialMediaService.js
echo   return await socialMediaRepository.findSocialMediasByUser(userId); >> %SERVICE_DIR%\src\services\socialMediaService.js
echo }; >> %SERVICE_DIR%\src\services\socialMediaService.js
echo exports.updateSocialMedia = async (socialMediaId, socialMediaData) => { >> %SERVICE_DIR%\src\services\socialMediaService.js
echo   return await socialMediaRepository.updateSocialMedia(socialMediaId, socialMediaData); >> %SERVICE_DIR%\src\services\socialMediaService.js
echo }; >> %SERVICE_DIR%\src\services\socialMediaService.js
echo exports.deleteSocialMedia = async (socialMediaId) => { >> %SERVICE_DIR%\src\services\socialMediaService.js
echo   return await socialMediaRepository.deleteSocialMedia(socialMediaId); >> %SERVICE_DIR%\src\services\socialMediaService.js
echo }; >> %SERVICE_DIR%\src\services\socialMediaService.js

:: Create socialMediaRepository
echo const SocialMedia = require('../models/socialMedia'); > %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo exports.createSocialMedia = async (socialMediaData) => { >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo   const socialMedia = new SocialMedia(socialMediaData); >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo   return await socialMedia.save(); >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo exports.findSocialMediasByUser = async (userId) => { >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo   return await SocialMedia.find({ user: userId }); >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo exports.updateSocialMedia = async (socialMediaId, socialMediaData) => { >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo   return await SocialMedia.findByIdAndUpdate(socialMediaId, socialMediaData, { new: true }); >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo exports.deleteSocialMedia = async (socialMediaId) => { >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo   return await SocialMedia.findByIdAndDelete(socialMediaId); >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\socialMediaRepository.js

:: Create socialMediaRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\socialMediaRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\socialMediaRoutes.js
echo const socialMediaController = require('../controllers/socialMediaController'); >> %SERVICE_DIR%\src\routes\socialMediaRoutes.js
echo router.post('/add', socialMediaController.addSocialMedia); >> %SERVICE_DIR%\src\routes\socialMediaRoutes.js
echo router.get('/:userId', socialMediaController.getSocialMedias); >> %SERVICE_DIR%\src\routes\socialMediaRoutes.js
echo router.put('/:socialMediaId', socialMediaController.updateSocialMedia); >> %SERVICE_DIR%\src\routes\socialMediaRoutes.js
echo router.delete('/:socialMediaId', socialMediaController.deleteSocialMedia); >> %SERVICE_DIR%\src\routes\socialMediaRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\socialMediaRoutes.js

:: End of script
echo Profile Social Media service setup complete.
PAUSE
