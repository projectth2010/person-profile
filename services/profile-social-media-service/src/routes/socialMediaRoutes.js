const express = require('express'); 
const router = express.Router(); 
const socialMediaController = require('../controllers/socialMediaController'); 
router.post('/add', socialMediaController.addSocialMedia); 
router.get('/:userId', socialMediaController.getSocialMedias); 
router.put('/:socialMediaId', socialMediaController.updateSocialMedia); 
router.delete('/:socialMediaId', socialMediaController.deleteSocialMedia); 
module.exports = router; 
