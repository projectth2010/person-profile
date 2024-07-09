@echo off
SETLOCAL EnableDelayedExpansion

:: Define base directories
SET BASE_DIR=%~dp0
SET SERVICE_NAME=profile-address-service
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
echo PORT=3005 > %SERVICE_DIR%\.env
echo MONGO_URI=mongodb://mongo:27017/profile_address_db >> %SERVICE_DIR%\.env

:: Create src/index.js
echo const express = require('express'); > %SERVICE_DIR%\src\index.js
echo const mongoose = require('mongoose'); >> %SERVICE_DIR%\src\index.js
echo const dotenv = require('dotenv'); >> %SERVICE_DIR%\src\index.js
echo dotenv.config(); >> %SERVICE_DIR%\src\index.js
echo const app = express(); >> %SERVICE_DIR%\src\index.js
echo app.use(express.json()); >> %SERVICE_DIR%\src\index.js
echo const addressRoutes = require('./routes/addressRoutes'); >> %SERVICE_DIR%\src\index.js
echo app.use('/api/addresses', addressRoutes); >> %SERVICE_DIR%\src\index.js
echo const { PORT, MONGO_URI } = process.env; >> %SERVICE_DIR%\src\index.js
echo mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) >> %SERVICE_DIR%\src\index.js
echo   .then(() => { >> %SERVICE_DIR%\src\index.js
echo     app.listen(PORT, () => { >> %SERVICE_DIR%\src\index.js
echo       console.log(`Profile Address service is running on port ${PORT}`); >> %SERVICE_DIR%\src\index.js
echo     }); >> %SERVICE_DIR%\src\index.js
echo   }) >> %SERVICE_DIR%\src\index.js
echo   .catch(err => { >> %SERVICE_DIR%\src\index.js
echo     console.error('Database connection error:', err); >> %SERVICE_DIR%\src\index.js
echo   }); >> %SERVICE_DIR%\src\index.js

:: Create Address model
echo const mongoose = require('mongoose'); > %SERVICE_DIR%\src\models\address.js
echo const addressSchema = new mongoose.Schema({ >> %SERVICE_DIR%\src\models\address.js
echo   user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, >> %SERVICE_DIR%\src\models\address.js
echo   street: { type: String, required: true }, >> %SERVICE_DIR%\src\models\address.js
echo   city: { type: String, required: true }, >> %SERVICE_DIR%\src\models\address.js
echo   state: { type: String, required: true }, >> %SERVICE_DIR%\src\models\address.js
echo   zip: { type: String, required: true }, >> %SERVICE_DIR%\src\models\address.js
echo   country: { type: String, required: true }, >> %SERVICE_DIR%\src\models\address.js
echo   isPrimary: { type: Boolean, default: false } >> %SERVICE_DIR%\src\models\address.js
echo }, { timestamps: true }); >> %SERVICE_DIR%\src\models\address.js
echo module.exports = mongoose.model('Address', addressSchema); >> %SERVICE_DIR%\src\models\address.js

:: Create addressController
echo const addressService = require('../services/addressService'); > %SERVICE_DIR%\src\controllers\addressController.js
echo exports.addAddress = async (req, res) => { >> %SERVICE_DIR%\src\controllers\addressController.js
echo   try { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     const address = await addressService.addAddress(req.body); >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(201).json(address); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } >> %SERVICE_DIR%\src\controllers\addressController.js
echo }; >> %SERVICE_DIR%\src\controllers\addressController.js
echo exports.getAddresses = async (req, res) => { >> %SERVICE_DIR%\src\controllers\addressController.js
echo   try { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     const addresses = await addressService.getAddresses(req.params.userId); >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(200).json(addresses); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } >> %SERVICE_DIR%\src\controllers\addressController.js
echo }; >> %SERVICE_DIR%\src\controllers\addressController.js
echo exports.updateAddress = async (req, res) => { >> %SERVICE_DIR%\src\controllers\addressController.js
echo   try { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     const address = await addressService.updateAddress(req.params.addressId, req.body); >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(200).json(address); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } >> %SERVICE_DIR%\src\controllers\addressController.js
echo }; >> %SERVICE_DIR%\src\controllers\addressController.js
echo exports.deleteAddress = async (req, res) => { >> %SERVICE_DIR%\src\controllers\addressController.js
echo   try { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     await addressService.deleteAddress(req.params.addressId); >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(204).end(); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } catch (err) { >> %SERVICE_DIR%\src\controllers\addressController.js
echo     res.status(400).json({ error: err.message }); >> %SERVICE_DIR%\src\controllers\addressController.js
echo   } >> %SERVICE_DIR%\src\controllers\addressController.js
echo }; >> %SERVICE_DIR%\src\controllers\addressController.js

:: Create addressService
echo const addressRepository = require('../repositories/addressRepository'); > %SERVICE_DIR%\src\services\addressService.js
echo exports.addAddress = async (addressData) => { >> %SERVICE_DIR%\src\services\addressService.js
echo   return await addressRepository.createAddress(addressData); >> %SERVICE_DIR%\src\services\addressService.js
echo }; >> %SERVICE_DIR%\src\services\addressService.js
echo exports.getAddresses = async (userId) => { >> %SERVICE_DIR%\src\services\addressService.js
echo   return await addressRepository.findAddressesByUser(userId); >> %SERVICE_DIR%\src\services\addressService.js
echo }; >> %SERVICE_DIR%\src\services\addressService.js
echo exports.updateAddress = async (addressId, addressData) => { >> %SERVICE_DIR%\src\services\addressService.js
echo   return await addressRepository.updateAddress(addressId, addressData); >> %SERVICE_DIR%\src\services\addressService.js
echo }; >> %SERVICE_DIR%\src\services\addressService.js
echo exports.deleteAddress = async (addressId) => { >> %SERVICE_DIR%\src\services\addressService.js
echo   return await addressRepository.deleteAddress(addressId); >> %SERVICE_DIR%\src\services\addressService.js
echo }; >> %SERVICE_DIR%\src\services\addressService.js

:: Create addressRepository
echo const Address = require('../models/address'); > %SERVICE_DIR%\src\repositories\addressRepository.js
echo exports.createAddress = async (addressData) => { >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo   const address = new Address(addressData); >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo   return await address.save(); >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo exports.findAddressesByUser = async (userId) => { >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo   return await Address.find({ user: userId }); >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo exports.updateAddress = async (addressId, addressData) => { >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo   return await Address.findByIdAndUpdate(addressId, addressData, { new: true }); >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo exports.deleteAddress = async (addressId) => { >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo   return await Address.findByIdAndDelete(addressId); >> %SERVICE_DIR%\src\repositories\addressRepository.js
echo }; >> %SERVICE_DIR%\src\repositories\addressRepository.js

:: Create addressRoutes
echo const express = require('express'); > %SERVICE_DIR%\src\routes\addressRoutes.js
echo const router = express.Router(); >> %SERVICE_DIR%\src\routes\addressRoutes.js
echo const addressController = require('../controllers/addressController'); >> %SERVICE_DIR%\src\routes\addressRoutes.js
echo router.post('/add', addressController.addAddress); >> %SERVICE_DIR%\src\routes\addressRoutes.js
echo router.get('/:userId', addressController.getAddresses); >> %SERVICE_DIR%\src\routes\addressRoutes.js
echo router.put('/:addressId', addressController.updateAddress); >> %SERVICE_DIR%\src\routes\addressRoutes.js
echo router.delete('/:addressId', addressController.deleteAddress); >> %SERVICE_DIR%\src\routes\addressRoutes.js
echo module.exports = router; >> %SERVICE_DIR%\src\routes\addressRoutes.js

:: End of script
echo Profile Address service setup complete.
PAUSE
