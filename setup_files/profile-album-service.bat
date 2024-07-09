@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=profile-album-service
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
echo PORT=3004 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/profile_album_db >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const albumRoutes = require('./routes/albumRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/albums', albumRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Profile Album service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create Album model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\album.js
echo const albumSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\album.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\album.js
echo   name: { type: String, required: true }, >> %SERVICE_DIR%\src\models\album.js
echo   images: [{ type: String, required: true }] >> %SERVICE_DIR%\src\models\album.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\album.js
echo module.exports = mongoose.model('Album', albumSchema); >> %SERVICE_DIR%\src\models\album.js

:: Create Video model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\video.js
echo const videoSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\video.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\video.js
echo   title: { type: String, required: true }, >> %SERVICE_DIR%\src\models\video.js
echo   videoData: { type: String, required: true }, >> %SERVICE_DIR%\src\models\video.js
echo   duration: { type: Number, required: true, max: 30 } >> %SERVICE_DIR%\src\models\video.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\video.js
echo module.exports = mongoose.model('Video', videoSchema); >> %SERVICE_DIR%\src\models\video.js

:: Create albumController
echo const albumService = require('../services/albumService'); > %SERVICE_DIR%\src\controllers\albumController.js
echo exports.createAlbum = async (req, res) => { >> %SERVICE_DIR%\src\controllers\albumController.js
echo   try { >> %SERVICE_DIR%\src\controllers\albumController.js
echo     const album = await albumService.createAlbum(req.body); >> %SERVICE_DIR%\src\controllers\albumController.js
echo     res.status(201).json(album); >> %SERVICE_DIR%\src\controllers\albumController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\albumController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\albumController.js
echo   } >> %SERVICE_DIR%\src\controllers\albumController.js
echo }; >> %SERVICE_DIR%\src\controllers\albumController.js
echo exports.getAlbums = async (req, res) => { >> %SERVICE_DIR%\src\controllers\albumController.js
echo   try { >> %SERVICE_DIR%\src\controllers\albumController.js
echo     const albums = await albumService.getAlbums(req.params.userId); >> %SERVICE_DIR%\src\controllers\albumController.js
echo     res.status(200).json(albums); >> %SERVICE_DIR%\src\controllers\albumController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\albumController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\albumController.js
echo   } >> %SERVICE_DIR%\src\controllers\albumController.js
echo }; >> %SERVICE_DIR%\src\controllers\albumController.js
echo exports.addImageToAlbum = async (req, res) => { >> %SERVICE_DIR%\src\controllers\albumController.js
echo   try { >> %SERVICE_DIR%\src\controllers\albumController.js
echo     const album = await albumService.addImageToAlbum(req.params.albumId, req.body.image); >> %SERVICE_DIR%\src\controllers\albumController.js
echo     res.status(200).json(album); >> %SERVICE_DIR%\src\controllers\albumController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\albumController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\albumController.js
echo   } >> %SERVICE_DIR%\src\controllers\albumController.js
echo }; >> %SERVICE_DIR%\src\controllers\albumController.js

:: Create videoController
echo const videoService = require('../services/videoService'); > %SERVICE_DIR%\src\controllers\videoController.js
echo exports.uploadVideo = async (req, res) => { >> %SERVICE_DIR%\src\controllers\videoController.js
echo   try { >> %SERVICE_DIR%\src\controllers\videoController.js
echo     const video = await videoService.uploadVideo(req.body); >> %SERVICE_DIR%\src\controllers\videoController.js
echo     res.status(201).json(video); >> %SERVICE_DIR%\src\controllers\videoController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\videoController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\videoController.js
echo   } >> %SERVICE_DIR%\src\controllers\videoController.js
echo }; >> %SERVICE_DIR%\src\controllers\videoController.js
echo exports.getVideos = async (req, res) => { >> %SERVICE_DIR%\src\controllers\videoController.js
echo   try { >> %SERVICE_DIR%\src\controllers\videoController.js
echo     const videos = await videoService.getVideos(req.params.userId); >> %SERVICE_DIR%\src\controllers\videoController.js
echo     res.status(200).json(videos); >> %SERVICE_DIR%\src\controllers\videoController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\videoController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\videoController.js
echo   } >> %SERVICE_DIR%\src\controllers\videoController.js
echo }; >> %SERVICE_DIR%\src\controllers\videoController.js

:: Create albumService
echo const albumRepository = require('../repositories/albumRepository'); > %SERVICE_DIR%\src\services\albumService.js
echo exports.createAlbum = async (albumData) => { >> %SERVICE_DIR%\src\services\albumService.js
echo   return await albumRepository.createAlbum(albumData); >> %SERVICE_DIR%\src\services\albumService.js
echo }; >> %SERVICE_DIR%\src\services\albumService.js
echo exports.getAlbums = async (userId) => { >> %SERVICE_DIR%\src\services\albumService.js
echo   return await albumRepository.findAlbumsByUser(userId); >> %SERVICE_DIR%\src\services\albumService.js
echo }; >> %SERVICE_DIR%\src\services\albumService.js
echo exports.addImageToAlbum = async (albumId, image) => { >> %SERVICE_DIR%\src\services\albumService.js
echo   return await albumRepository.addImageToAlbum(albumId, image); >> %SERVICE_DIR%\src\services\albumService.js
echo }; >> %SERVICE_DIR%\src\services\albumService.js

:: Create videoService
echo const videoRepository = require('../repositories/videoRepository'); > %SERVICE_DIR%\src\services\videoService.js
echo exports.uploadVideo = async (videoData) => { >> %SERVICE_DIR%\src\services\videoService.js
echo   return await videoRepository.createVideo(videoData); >> %SERVICE_DIR%\src\services\videoService.js
echo }; >> %SERVICE_DIR%\src\services\videoService.js
echo exports.getVideos = async (userId) => { >> %SERVICE_DIR%\src\services\videoService.js
echo   return await videoRepository.findVideosByUser(userId); >> %SERVICE_DIR%\src\services\videoService.js
echo }; >> %SERVICE_DIR%\src\services\videoService.js

:: Create albumRepository
echo const Album = require('../models/album'); > %SERVICE_DIR%\src\repositories\albumRepository.js
echo exports.createAlbum = async (albumData) => { >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   const album = new Album(albumData); >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   return await album.save(); >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo exports.findAlbumsByUser = async (userId) => { >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   return await Album.find({ user: userId }); >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo exports.addImageToAlbum = async (albumId, image) => { >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   const album = await Album.findById(albumId); >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   if (!album) { >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo     throw new Error('Album not found'); >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   } >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   album.images.push(image); >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo   return await album.save(); >> %SERVICE_DIR%\src\repositories\albumRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\albumRepository.js

:: Create videoRepository
echo const Video = require('../models/video'); > %SERVICE_DIR%\src\repositories\videoRepository.js
echo exports.createVideo = async (videoData) => { >> %SERVICE_DIR%\src\repositories\videoRepository.js
echo   const video = new Video(videoData); >> %SERVICE_DIR%\src\repositories\videoRepository.js
echo   return await video.save(); >> %SERVICE_DIR%\src\repositories\videoRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\videoRepository.js
echo exports.findVideosByUser = async (userId) => { >> %SERVICE_DIR%\src\repositories\videoRepository.js
echo   return await Video.find({ user: userId }); >> %SERVICE_DIR%\src\repositories\videoRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\videoRepository.js

:: Create albumRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\albumRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\albumRoutes.js
echo const albumController = require('../controllers/albumController'); >> %SERVICE_DIR%\src\routes\albumRoutes.js
echo router.post('/create', albumController.createAlbum); >> %SERVICE_DIR%\src\routes\albumRoutes.js
echo router.get('/:userId', albumController.getAlbums); >> %SERVICE_DIR%\src\routes\albumRoutes.js
echo router.post('/:albumId/addImage', albumController.addImageToAlbum); >> %SERVICE_DIR%\src\routes\albumRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\albumRoutes.js

:: Create videoRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\videoRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\videoRoutes.js
echo const videoController = require('../controllers/videoController'); >> %SERVICE_DIR%\src\routes\videoRoutes.js
echo router.post('/upload', videoController.uploadVideo); >> %SERVICE_DIR%\src\routes\videoRoutes.js
echo router.get('/:userId', videoController.getVideos); >> %SERVICE_DIR%\src\routes\videoRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\videoRoutes.js

:: End of script
echo Profile Album service setup complete.
PAUSE
