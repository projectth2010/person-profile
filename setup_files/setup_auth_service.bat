@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=auth-service
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
echo {
echo   "name": "%SERVICE_NAME%",
echo   "version": "1.0.0",
echo   "main": "src/index.js",
echo   "scripts": {
echo     "start": "node src/index.js"
echo   },
echo   "dependencies": {
echo     "express": "^4.17.1",
echo     "mongoose": "^5.11.15",
echo     "dotenv": "^8.2.0",
echo     "bcrypt": "^5.0.1",
echo     "jsonwebtoken": "^8.5.1"
echo   }
echo } > %SERVICE_DIR%\package.json

:: Create Dockerfile
echo FROM node:18 > %SERVICE_DIR%\Dockerfile
echo WORKDIR /usr/src/app >> %SERVICE_DIR%\Dockerfile
echo COPY package*.json ./ >> %SERVICE_DIR%\Dockerfile
echo RUN npm install >> %SERVICE_DIR%\Dockerfile
echo COPY . . >> %SERVICE_DIR%\Dockerfile
echo CMD ["node", "src/index.js"] >> %SERVICE_DIR%\Dockerfile

:: Create .env file
echo PORT=3001 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/auth_db >> %SERVICE_DIR%\.env
echo JWT_SECRET=your_jwt_secret_key >> %SERVICE_DIR%\.env
echo REDIS_HOST=redis >> %SERVICE_DIR%\.env
echo REDIS_PORT=6379 >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const authRoutes = require('./routes/authRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/auth', authRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Auth service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create User model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\user.js
echo const bcrypt = require('bcrypt'); >> %SERVICE_DIR%\src\models\user.js
echo const userSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\user.js
echo   username: { type: String, required: true, unique: true }, >> %SERVICE_DIR%\src\models\user.js
echo   email: { type: String, required: true, unique: true }, >> %SERVICE_DIR%\src\models\user.js
echo   password: { type: String, required: true } >> %SERVICE_DIR%\src\models\user.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\user.js
echo userSchema.pre('save', async function (next) { >> %SERVICE_DIR%\src\models\user.js
echo   if (!this.isModified('password')) return next(); >> %SERVICE_DIR%\src\models\user.js
echo   this.password = await bcrypt.hash(this.password, 10); >> %SERVICE_DIR%\src\models\user.js
echo   next(); >> %SERVICE_DIR%\src\models\user.js
echo }); >> %SERVICE_DIR%\src\models\user.js
echo userSchema.methods.comparePassword = function (password) { >> %SERVICE_DIR%\src\models\user.js
echo   return bcrypt.compare(password, this.password); >> %SERVICE_DIR%\src\models\user.js
echo }; >> %SERVICE_DIR%\src\models\user.js
echo module.exports = mongoose.model('User', userSchema); >> %SERVICE_DIR%\src\models\user.js

:: Create authController
echo const authService = require('../services/authService'); > %SERVICE_DIR%\src\controllers\authController.js
echo exports.register = async (req, res) => { >> %SERVICE_DIR%\src\controllers\authController.js
echo   try { >> %SERVICE_DIR%\src\controllers\authController.js
echo     const user = await authService.register(req.body); >> %SERVICE_DIR%\src\controllers\authController.js
echo     res.status(201).json(user); >> %SERVICE_DIR%\src\controllers\authController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\authController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\authController.js
echo   } >> %SERVICE_DIR%\src\controllers\authController.js
echo }; >> %SERVICE_DIR%\src\controllers\authController.js
echo exports.login = async (req, res) => { >> %SERVICE_DIR%\src\controllers\authController.js
echo   try { >> %SERVICE_DIR%\src\controllers\authController.js
echo     const token = await authService.login(req.body); >> %SERVICE_DIR%\src\controllers\authController.js
echo     res.json({ token }); >> %SERVICE_DIR%\src\controllers\authController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\authController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\authController.js
echo   } >> %SERVICE_DIR%\src\controllers\authController.js
echo }; >> %SERVICE_DIR%\src\controllers\authController.js

:: Create authService
echo const userRepository = require('../repositories/userRepository'); > %SERVICE_DIR%\src\services\authService.js
echo const jwt = require('jsonwebtoken'); >> %SERVICE_DIR%\src\services\authService.js
echo const { JWT_SECRET } = process.env; >> %SERVICE_DIR%\src\services\authService.js
echo exports.register = async (userData) => { >> %SERVICE_DIR%\src\services\authService.js
echo   return await userRepository.createUser(userData); >> %SERVICE_DIR%\src\services\authService.js
echo }; >> %SERVICE_DIR%\src\services\authService.js
echo exports.login = async ({ email, password }) => { >> %SERVICE_DIR%\src\services\authService.js
echo   const user = await userRepository.findByEmail(email); >> %SERVICE_DIR%\src\services\authService.js
echo   if (!user || !await user.comparePassword(password)) { >> %SERVICE_DIR%\src\services\authService.js
echo     throw new Error('Invalid email or password'); >> %SERVICE_DIR%\src\services\authService.js
echo   } >> %SERVICE_DIR%\src\services\authService.js
echo   return jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: '1h' }); >> %SERVICE_DIR%\src\services\authService.js
echo }; >> %SERVICE_DIR%\src\services\authService.js

:: Create userRepository
echo const User = require('../models/user'); > %SERVICE_DIR%\src\repositories\userRepository.js
echo exports.createUser = async (userData) => { >> %SERVICE_DIR%\src\repositories\userRepository.js
echo   const user = new User(userData); >> %SERVICE_DIR%\src\repositories\userRepository.js
echo   return await user.save(); >> %SERVICE_DIR%\src\repositories\userRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\userRepository.js
echo exports.findByEmail = async (email) => { >> %SERVICE_DIR%\src\repositories\userRepository.js
echo   return await User.findOne({ email }); >> %SERVICE_DIR%\src\repositories\userRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\userRepository.js

:: Create authRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\authRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\authRoutes.js
echo const authController = require('../controllers/authController'); >> %SERVICE_DIR%\src\routes\authRoutes.js
echo router.post('/register', authController.register); >> %SERVICE_DIR%\src\routes\authRoutes.js
echo router.post('/login', authController.login); >> %SERVICE_DIR%\src\routes\authRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\authRoutes.js

:: End of script
echo Auth service setup complete.
PAUSE
