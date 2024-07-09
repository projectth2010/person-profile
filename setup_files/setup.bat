@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICES_DIR=%BASE_DIR%services

:: Create directories
mkdir %SERVICES_DIR%
mkdir %SERVICES_DIR%\auth-service
mkdir %SERVICES_DIR%\profile-service
mkdir %SERVICES_DIR%\profile-score-service
mkdir %SERVICES_DIR%\profile-album-service
mkdir %SERVICES_DIR%\profile-address-service
mkdir %SERVICES_DIR%\profile-social-media-service
mkdir %SERVICES_DIR%\profile-status-of-working-service
mkdir %SERVICES_DIR%\profile-writer-service
mkdir %BASE_DIR%nginx

:: Define common files and content
SET PACKAGE_JSON={"name": "", "version": "1.0.0", "main": "src/index.js", "scripts": {"start": "node src/index.js"}, "dependencies": {"express": "^4.17.1", "mongoose": "^5.11.15", "dotenv": "^8.2.0", "axios": "^0.21.1"}}
SET DOCKERFILE=FROM node:18\n\nWORKDIR /usr/src/app\n\nCOPY package*.json ./\n\nRUN npm install\n\nCOPY . .\n\nCMD ["node", "src/index.js"]

:: Function to create common structure
:CreateService
    SET SERVICE_NAME=%1
    SET SERVICE_PATH=%SERVICES_DIR%\%SERVICE_NAME%
    
    mkdir %SERVICE_PATH%\src
    mkdir %SERVICE_PATH%\src\controllers
    mkdir %SERVICE_PATH%\src\services
    mkdir %SERVICE_PATH%\src\repositories
    mkdir %SERVICE_PATH%\src\routes
    mkdir %SERVICE_PATH%\src\models
    mkdir %SERVICE_PATH%\src\middlewares
    mkdir %SERVICE_PATH%\src\utils
    
    echo %PACKAGE_JSON% > %SERVICE_PATH%\package.json
    echo %DOCKERFILE% > %SERVICE_PATH%\Dockerfile
    
    copy nul %SERVICE_PATH%\.env
    copy nul %SERVICE_PATH%\src\index.js
    
    goto :EOF

:: Create each service
CALL :CreateService auth-service
CALL :CreateService profile-service
CALL :CreateService profile-score-service
CALL :CreateService profile-album-service
CALL :CreateService profile-address-service
CALL :CreateService profile-social-media-service
CALL :CreateService profile-status-of-working-service
CALL :CreateService profile-writer-service

:: Write specific content to each service

:: Auth Service
echo const express = require('express'); > %SERVICES_DIR%\auth-service\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICES_DIR%\auth-service\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICES_DIR%\auth-service\src\index.js
echo dotenv.config(); >> %SERVICES_DIR%\auth-service\src\index.js
echo const app = express(); >> %SERVICES_DIR%\auth-service\src\index.js
echo app.use(express.json()); >> %SERVICES_DIR%\auth-service\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICES_DIR%\auth-service\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICES_DIR%\auth-service\src\index.js
echo   .then(() => { >> %SERVICES_DIR%\auth-service\src\index.js
echo     app.listen(PORT, () => { >> %SERVICES_DIR%\auth-service\src\index.js
echo       console.log(`Auth service is running on port ${PORT}`); >> %SERVICES_DIR%\auth-service\src\index.js
echo     }); >> %SERVICES_DIR%\auth-service\src\index.js
echo   }) >> %SERVICES_DIR%\auth-service\src\index.js
echo   .catch(err => { >> %SERVICES_DIR%\auth-service\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICES_DIR%\auth-service\src\index.js
echo   }); >> %SERVICES_DIR%\auth-service\src\index.js

:: Repeat the above process for other services (profile-service, profile-score-service, etc.)

:: Docker Compose
echo version: '3.8' > %BASE_DIR%docker-compose.yml
echo services: >> %BASE_DIR%docker-compose.yml

:: Function to add service to docker-compose.yml
:AddServiceToCompose
    SET SERVICE_NAME=%1
    SET SERVICE_PORT=%2

    echo   %SERVICE_NAME%: >> %BASE_DIR%docker-compose.yml
    echo     build: >> %BASE_DIR%docker-compose.yml
    echo       context: ./services/%SERVICE_NAME% >> %BASE_DIR%docker-compose.yml
    echo     environment: >> %BASE_DIR%docker-compose.yml
    echo       - NODE_ENV=production >> %BASE_DIR%docker-compose.yml
    echo       - REDIS_HOST=redis >> %BASE_DIR%docker-compose.yml
    echo       - MONGO_URI=mongodb://mongo:27017/%SERVICE_NAME%_db >> %BASE_DIR%docker-compose.yml
    echo     ports: >> %BASE_DIR%docker-compose.yml
    echo       - "%SERVICE_PORT%:%SERVICE_PORT%" >> %BASE_DIR%docker-compose.yml
    echo     depends_on: >> %BASE_DIR%docker-compose.yml
    echo       - redis >> %BASE_DIR%docker-compose.yml
    echo       - mongo >> %BASE_DIR%docker-compose.yml

    goto :EOF

:: Add services to docker-compose.yml
CALL :AddServiceToCompose auth-service 3001
CALL :AddServiceToCompose profile-service 3002
CALL :AddServiceToCompose profile-score-service 3003
CALL :AddServiceToCompose profile-album-service 3004
CALL :AddServiceToCompose profile-address-service 3005
CALL :AddServiceToCompose profile-social-media-service 3006
CALL :AddServiceToCompose profile-status-of-working-service 3007
CALL :AddServiceToCompose profile-writer-service 3008

:: Add redis and mongo to docker-compose.yml
echo   redis: >> %BASE_DIR%docker-compose.yml
echo     image: redis:6.2 >> %BASE_DIR%docker-compose.yml
echo     ports: >> %BASE_DIR%docker-compose.yml
echo       - "6379:6379" >> %BASE_DIR%docker-compose.yml

echo   mongo: >> %BASE_DIR%docker-compose.yml
echo     image: mongo:4.4 >> %BASE_DIR%docker-compose.yml
echo     ports: >> %BASE_DIR%docker-compose.yml
echo       - "27017:27017" >> %BASE_DIR%docker-compose.yml

:: Add nginx to docker-compose.yml
echo   nginx: >> %BASE_DIR%docker-compose.yml
echo     build: ./nginx >> %BASE_DIR%docker-compose.yml
echo     ports: >> %BASE_DIR%docker-compose.yml
echo       - "80:80" >> %BASE_DIR%docker-compose.yml
echo     depends_on: >> %BASE_DIR%docker-compose.yml
echo       - auth-service >> %BASE_DIR%docker-compose.yml
echo       - profile-service >> %BASE_DIR%docker-compose.yml
echo       - profile-score-service >> %BASE_DIR%docker-compose.yml
echo       - profile-album-service >> %BASE_DIR%docker-compose.yml
echo       - profile-address-service >> %BASE_DIR%docker-compose.yml
echo       - profile-social-media-service >> %BASE_DIR%docker-compose.yml
echo       - profile-status-of-working-service >> %BASE_DIR%docker-compose.yml
echo       - profile-writer-service >> %BASE_DIR%docker-compose.yml

:: End of script
echo Setup complete.
PAUSE
