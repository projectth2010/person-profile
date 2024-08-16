const express = require('express'); 
const router = express.Router(); 
const albumController = require('../controllers/albumController'); 
router.post('/create', albumController.createAlbum); 
router.get('/:userId', albumController.getAlbums); 
router.post('/:albumId/addImage', albumController.addImageToAlbum); 
module.exports = router; 
