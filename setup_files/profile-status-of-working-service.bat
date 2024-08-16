@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=profile-status-of-working-service
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
echo PORT=3007 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/profile_status_of_working_db >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const statusRoutes = require('./routes/statusRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/status', statusRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Profile Status of Working service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create Status model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\status.js
echo const statusSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\status.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\status.js
echo   status: { type: String, enum: ['active', 'inactive', 'suspended'], required: true }, >> %SERVICE_DIR%\src\models\status.js
echo   updatedAt: { type: Date, default: Date.now } >> %SERVICE_DIR%\src\models\status.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\status.js
echo module.exports = mongoose.model('Status', statusSchema); >> %SERVICE_DIR%\src\models\status.js

:: Create statusController
echo const statusService = require('../services/statusService'); > %SERVICE_DIR%\src\controllers\statusController.js
echo exports.setStatus = async (req, res) => { >> %SERVICE_DIR%\src\controllers\statusController.js
echo   try { >> %SERVICE_DIR%\src\controllers\statusController.js
echo     const status = await statusService.setStatus(req.body); >> %SERVICE_DIR%\src\controllers\statusController.js
echo     res.status(201).json(status); >> %SERVICE_DIR%\src\controllers\statusController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\statusController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\statusController.js
echo   } >> %SERVICE_DIR%\src\controllers\statusController.js
echo }; >> %SERVICE_DIR%\src\controllers\statusController.js
echo exports.getStatus = async (req, res) => { >> %SERVICE_DIR%\src\controllers\statusController.js
echo   try { >> %SERVICE_DIR%\src\controllers\statusController.js
echo     const status = await statusService.getStatus(req.params.userId); >> %SERVICE_DIR%\src\controllers\statusController.js
echo     res.status(200).json(status); >> %SERVICE_DIR%\src\controllers\statusController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\statusController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\statusController.js
echo   } >> %SERVICE_DIR%\src\controllers\statusController.js
echo }; >> %SERVICE_DIR%\src\controllers\statusController.js

:: Create statusService
echo const statusRepository = require('../repositories/statusRepository'); > %SERVICE_DIR%\src\services\statusService.js
echo exports.setStatus = async (statusData) => { >> %SERVICE_DIR%\src\services\statusService.js
echo   return await statusRepository.createOrUpdateStatus(statusData); >> %SERVICE_DIR%\src\services\statusService.js
echo }; >> %SERVICE_DIR%\src\services\statusService.js
echo exports.getStatus = async (userId) => { >> %SERVICE_DIR%\src\services\statusService.js
echo   return await statusRepository.findStatusByUser(userId); >> %SERVICE_DIR%\src\services\statusService.js
echo }; >> %SERVICE_DIR%\src\services\statusService.js

:: Create statusRepository
echo const Status = require('../models/status'); > %SERVICE_DIR%\src\repositories\statusRepository.js
echo exports.createOrUpdateStatus = async (statusData) => { >> %SERVICE_DIR%\src\repositories\statusRepository.js
echo   const status = await Status.findOneAndUpdate({ user: statusData.user }, statusData, { new: true, upsert: true }); >> %SERVICE_DIR%\src\repositories\statusRepository.js
echo   return status; >> %SERVICE_DIR%\src\repositories\statusRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\statusRepository.js
echo exports.findStatusByUser = async (userId) => { >> %SERVICE_DIR%\src\repositories\statusRepository.js
echo   return await Status.findOne({ user: userId }); >> %SERVICE_DIR%\src\repositories\statusRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\statusRepository.js

:: Create statusRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\statusRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\statusRoutes.js
echo const statusController = require('../controllers/statusController'); >> %SERVICE_DIR%\src\routes\statusRoutes.js
echo router.post('/set', statusController.setStatus); >> %SERVICE_DIR%\src\routes\statusRoutes.js
echo router.get('/:userId', statusController.getStatus); >> %SERVICE_DIR%\src\routes\statusRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\statusRoutes.js

:: End of script
echo Profile Status of Working service setup complete.
PAUSE
