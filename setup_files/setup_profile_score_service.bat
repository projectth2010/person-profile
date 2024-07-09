@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=profile-score-service
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
echo PORT=3003 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/profile_score_db >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const scoreRoutes = require('./routes/scoreRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/score', scoreRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Profile Score service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create Score model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\score.js
echo const scoreSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\score.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\score.js
echo   project: { type: mongoose.Schema.Types.ObjectId, ref: 'Project', required: true }, >> %SERVICE_DIR%\src\models\score.js
echo   score: { type: Number, required: true, default: 0 }, >> %SERVICE_DIR%\src\models\score.js
echo   logs: [{ >> %SERVICE_DIR%\src\models\score.js
echo     action: { type: String, enum: ['add', 'deduct'], required: true }, >> %SERVICE_DIR%\src\models\score.js
echo     score: { type: Number, required: true }, >> %SERVICE_DIR%\src\models\score.js
echo     date: { type: Date, default: Date.now } >> %SERVICE_DIR%\src\models\score.js
echo   }] >> %SERVICE_DIR%\src\models\score.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\score.js
echo module.exports = mongoose.model('Score', scoreSchema); >> %SERVICE_DIR%\src\models\score.js

:: Create scoreController
echo const scoreService = require('../services/scoreService'); > %SERVICE_DIR%\src\controllers\scoreController.js
echo exports.addScore = async (req, res) => { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   try { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     const updatedScore = await scoreService.addScore(req.body); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(200).json(updatedScore); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } >> %SERVICE_DIR%\src\controllers\scoreController.js
echo }; >> %SERVICE_DIR%\src\controllers\scoreController.js
echo exports.deductScore = async (req, res) => { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   try { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     const updatedScore = await scoreService.deductScore(req.body); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(200).json(updatedScore); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } >> %SERVICE_DIR%\src\controllers\scoreController.js
echo }; >> %SERVICE_DIR%\src\controllers\scoreController.js
echo exports.getScore = async (req, res) => { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   try { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     const score = await scoreService.getScore(req.params.userId, req.params.projectId); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(200).json(score); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } >> %SERVICE_DIR%\src\controllers\scoreController.js
echo }; >> %SERVICE_DIR%\src\controllers\scoreController.js
echo exports.getScoreLogs = async (req, res) => { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   try { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     const logs = await scoreService.getScoreLogs(req.params.userId, req.params.projectId); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(200).json(logs); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\scoreController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\scoreController.js
echo   } >> %SERVICE_DIR%\src\controllers\scoreController.js
echo }; >> %SERVICE_DIR%\src\controllers\scoreController.js

:: Create scoreService
echo const scoreRepository = require('../repositories/scoreRepository'); > %SERVICE_DIR%\src\services\scoreService.js
echo exports.addScore = async (data) => { >> %SERVICE_DIR%\src\services\scoreService.js
echo   return await scoreRepository.updateScore(data.userId, data.projectId, data.score, 'add'); >> %SERVICE_DIR%\src\services\scoreService.js
echo }; >> %SERVICE_DIR%\src\services\scoreService.js
echo exports.deductScore = async (data) => { >> %SERVICE_DIR%\src\services\scoreService.js
echo   return await scoreRepository.updateScore(data.userId, data.projectId, data.score, 'deduct'); >> %SERVICE_DIR%\src\services\scoreService.js
echo }; >> %SERVICE_DIR%\src\services\scoreService.js
echo exports.getScore = async (userId, projectId) => { >> %SERVICE_DIR%\src\services\scoreService.js
echo   return await scoreRepository.findScore(userId, projectId); >> %SERVICE_DIR%\src\services\scoreService.js
echo }; >> %SERVICE_DIR%\src\services\scoreService.js
echo exports.getScoreLogs = async (userId, projectId) => { >> %SERVICE_DIR%\src\services\scoreService.js
echo   return await scoreRepository.findScoreLogs(userId, projectId); >> %SERVICE_DIR%\src\services\scoreService.js
echo }; >> %SERVICE_DIR%\src\services\scoreService.js

:: Create scoreRepository
echo const Score = require('../models/score'); > %SERVICE_DIR%\src\repositories\scoreRepository.js
echo exports.updateScore = async (userId, projectId, score, action) => { >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   const scoreEntry = await Score.findOne({ user: userId, project: projectId }); >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   if (!scoreEntry) { >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo     const newScore = new Score({ >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo       user: userId, >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo       project: projectId, >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo       score: action === 'add' ? score : -score, >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo       logs: [{ action, score }] >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo     }); >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo     return await newScore.save(); >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   } >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   if (action === 'add') { >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo     scoreEntry.score += score; >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   } else { >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo     scoreEntry.score -= score; >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   } >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   scoreEntry.logs.push({ action, score }); >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   return await scoreEntry.save(); >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo exports.findScore = async (userId, projectId) => { >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   return await Score.findOne({ user: userId, project: projectId }); >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo exports.findScoreLogs = async (userId, projectId) => { >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   const scoreEntry = await Score.findOne({ user: userId, project: projectId }); >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo   return scoreEntry ? scoreEntry.logs : []; >> %SERVICE_DIR%\src\repositories\scoreRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\scoreRepository.js

:: Create scoreRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\scoreRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\scoreRoutes.js
echo const scoreController = require('../controllers/scoreController'); >> %SERVICE_DIR%\src\routes\scoreRoutes.js
echo router.post('/add', scoreController.addScore); >> %SERVICE_DIR%\src\routes\scoreRoutes.js
echo router.post('/deduct', scoreController.deductScore); >> %SERVICE_DIR%\src\routes\scoreRoutes.js
echo router.get('/:userId/:projectId', scoreController.getScore); >> %SERVICE_DIR%\src\routes\scoreRoutes.js
echo router.get('/logs/:userId/:projectId', scoreController.getScoreLogs); >> %SERVICE_DIR%\src\routes\scoreRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\scoreRoutes.js

:: End of script
echo Profile Score service setup complete.
PAUSE
