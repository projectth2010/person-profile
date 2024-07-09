# Profile Management System

## Overview

This project consists of multiple microservices for managing user profiles, including authentication, profile information, profile scores, albums, addresses, social media contacts, status of working, and writer content.

## Microservices

- `auth-service`: Handles user authentication.
- `profile-service`: Manages user profile information.
- `profile-score-service`: Tracks profile scores.
- `profile-album-service`: Manages profile albums.
- `profile-address-service`: Manages contact addresses.
- `profile-social-media-service`: Manages social media contacts.
- `profile-status-of-working-service`: Manages working status.
- `profile-writer-service`: Manages writer content.

## Setup and Run

### Prerequisites

- Docker
- Docker Compose

### Directory Structure
```
project-root/
├── services/
│ ├── auth-service/
│ ├── profile-service/
│ ├── profile-score-service/
│ ├── profile-album-service/
│ ├── profile-address-service/
│ ├── profile-social-media-service/
│ ├── profile-status-of-working-service/
│ ├── profile-writer-service/
├── nginx/
├── docker-compose.yml
└── README.md
```

### Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/your-repo/profile-management-system.git
   cd profile-management-system
   
2. Create the directory structure and generate source code for auth-service:

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
echo     "dotenv": "^8.2.0", >> %SERVICE_DIR%\package.json
echo     "bcrypt": "^5.0.1", >> %SERVICE_DIR%\package.json
echo     "jsonwebtoken": "^8.5.1" >> %SERVICE_DIR%\package.json
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
```

3. Create a docker-compose.yml file in the root directory:

```
version: '3.8'
services:
  auth-service:
    build:
      context: ./services/auth-service
    environment:
      - NODE_ENV=production
      - REDIS_HOST=redis
      - MONGO_URI=mongodb://mongo:27017/auth_db
    ports:
      - "3001:3001"
    depends_on:
      - redis
      - mongo

  redis:
    image: redis:6.2
    ports:
      - "6379:6379"

  mongo:
    image: mongo:4.4
    ports:
      - "27017:27017"

  nginx:
    build: ./nginx
    ports:
      - "80:80"
    depends_on:
      - auth-service
```

4. Create an nginx directory and an nginx.conf file inside it:

```
user  nginx;
worker_processes  auto;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout  65;

    upstream auth_service {
        server auth-service:3001;
    }

    server {
        listen       80;
        server_name  localhost;

        location /api/auth {
            proxy_pass http://auth_service;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

### Running the Solution

1. Build and start the services using Docker Compose:
```
docker-compose up --build
```

2. The services should now be running, and you can access the authentication service at http://localhost/api/auth.

### Additional Services
Follow similar steps to create the other microservices (profile-service, profile-score-service, etc.) and add them to the docker-compose.yml file.

License
This project is licensed under the MIT License.


