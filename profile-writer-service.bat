@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=profile-writer-service
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
echo PORT=3008 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/profile_writer_db >> %SERVICE_DIR%\.env
echo JWT_SECRET=your_jwt_secret_key >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const writerRoutes = require('./routes/writerRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/writer', writerRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Profile Writer service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create Writer model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\writer.js
echo const writerSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\writer.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\writer.js
echo   title: { type: String, required: true }, >> %SERVICE_DIR%\src\models\writer.js
echo   content: { type: String, required: true }, >> %SERVICE_DIR%\src\models\writer.js
echo   images: [{ type: String, required: false }], >> %SERVICE_DIR%\src\models\writer.js
echo   accessCount: { type: Number, default: 0 } >> %SERVICE_DIR%\src\models\writer.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\writer.js
echo module.exports = mongoose.model('Writer', writerSchema); >> %SERVICE_DIR%\src\models\writer.js

:: Create writerController
echo const writerService = require('../services/writerService'); > %SERVICE_DIR%\src\controllers\writerController.js
echo exports.createStory = async (req, res) => { >> %SERVICE_DIR%\src\controllers\writerController.js
echo   try { >> %SERVICE_DIR%\src\controllers\writerController.js
echo     const story = await writerService.createStory(req.body); >> %SERVICE_DIR%\src\controllers\writerController.js
echo     res.status(201).json(story); >> %SERVICE_DIR%\src\controllers\writerController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\writerController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\writerController.js
echo   } >> %SERVICE_DIR%\src\controllers\writerController.js
echo }; >> %SERVICE_DIR%\src\controllers\writerController.js
echo exports.getStories = async (req, res) => { >> %SERVICE_DIR%\src\controllers\writerController.js
echo   try { >> %SERVICE_DIR%\src\controllers\writerController.js
echo     const stories = await writerService.getStories(req.params.userId); >> %SERVICE_DIR%\src\controllers\writerController.js
echo     res.status(200).json(stories); >> %SERVICE_DIR%\src\controllers\writerController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\writerController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\writerController.js
echo   } >> %SERVICE_DIR%\src\controllers\writerController.js
echo }; >> %SERVICE_DIR%\src\controllers\writerController.js
echo exports.getStory = async (req, res) => { >> %SERVICE_DIR%\src\controllers\writerController.js
echo   try { >> %SERVICE_DIR%\src\controllers\writerController.js
echo     const story = await writerService.getStory(req.params.storyId); >> %SERVICE_DIR%\src\controllers\writerController.js
echo     res.status(200).json(story); >> %SERVICE_DIR%\src\controllers\writerController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\writerController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\writerController.js
echo   } >> %SERVICE_DIR%\src\controllers\writerController.js
echo }; >> %SERVICE_DIR%\src\controllers\writerController.js

:: Create writerService
echo const writerRepository = require('../repositories/writerRepository'); > %SERVICE_DIR%\src\services\writerService.js
echo const profileScoreService = require('../services/profileScoreService'); >> %SERVICE_DIR%\src\services\writerService.js
echo exports.createStory = async (storyData) => { >> %SERVICE_DIR%\src\services\writerService.js
echo   const story = await writerRepository.createStory(storyData); >> %SERVICE_DIR%\src\services\writerService.js
echo   await profileScoreService.incrementScore(story.user, "นักเขียนตัวยง"); >> %SERVICE_DIR%\src\services\writerService.js
echo   return story; >> %SERVICE_DIR%\src\services\writerService.js
echo }; >> %SERVICE_DIR%\src\services\writerService.js
echo exports.getStories = async (userId) => { >> %SERVICE_DIR%\src\services\writerService.js
echo   return await writerRepository.findStoriesByUser(userId); >> %SERVICE_DIR%\src\services\writerService.js
echo }; >> %SERVICE_DIR%\src\services\writerService.js
echo exports.getStory = async (storyId) => { >> %SERVICE_DIR%\src\services\writerService.js
echo   const story = await writerRepository.findStoryById(storyId); >> %SERVICE_DIR%\src\services\writerService.js
echo   if (story) { >> %SERVICE_DIR%\src\services\writerService.js
echo     story.accessCount += 1; >> %SERVICE_DIR%\src\services\writerService.js
echo     await story.save(); >> %SERVICE_DIR%\src\services\writerService.js
echo   } >> %SERVICE_DIR%\src\services\writerService.js
echo   return story; >> %SERVICE_DIR%\src\services\writerService.js
echo }; >> %SERVICE_DIR%\src\services\writerService.js

:: Create writerRepository
echo const Writer = require('../models/writer'); > %SERVICE_DIR%\src\repositories\writerRepository.js
echo exports.createStory = async (storyData) => { >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo   const story = new Writer(storyData); >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo   return await story.save(); >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo exports.findStoriesByUser = async (userId) => { >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo   return await Writer.find({ user: userId }); >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo exports.findStoryById = async (storyId) => { >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo   return await Writer.findById(storyId); >> %SERVICE_DIR%\src\repositories\writerRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\writerRepository.js

:: Create writerRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\writerRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\writerRoutes.js
echo const writerController = require('../controllers/writerController'); >> %SERVICE_DIR%\src\routes\writerRoutes.js
echo router.post('/create', writerController.createStory); >> %SERVICE_DIR%\src\routes\writerRoutes.js
echo router.get('/user/:userId', writerController.getStories); >> %SERVICE_DIR%\src\routes\writerRoutes.js
echo router.get('/:storyId', writerController.getStory); >> %SERVICE_DIR%\src\routes\writerRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\writerRoutes.js

:: Create profileScoreService
echo const axios = require('axios'); > %SERVICE_DIR%\src\services\profileScoreService.js
echo const { PROFILE_SCORE_SERVICE_URL } = process.env; >> %SERVICE_DIR%\src\services\profileScoreService.js
echo exports.incrementScore = async (userId, projectName) => { >> %SERVICE_DIR%\src\services\profileScoreService.js
echo   try { >> %SERVICE_DIR%\src\services\profileScoreService.js
echo     await axios.post(`${PROFILE_SCORE_SERVICE_URL}/api/score/increment`, { userId, projectName }); >> %SERVICE_DIR%\src\services\profileScoreService.js
echo   } catch (error) { >> %SERVICE_DIR%\src\services\profileScoreService.js
echo     console.error('Error incrementing score:', error); >> %SERVICE_DIR%\src\services\profileScoreService.js
echo   } >> %SERVICE_DIR%\src\services\profileScoreService.js
echo }; >> %SERVICE_DIR%\src\services\profileScoreService.js

:: End of script
echo Profile Writer service setup complete.
PAUSE
