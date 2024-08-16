const express = require('express'); 
const router = express.Router(); 
const writerController = require('../controllers/writerController'); 
router.post('/create', writerController.createStory); 
router.get('/user/:userId', writerController.getStories); 
router.get('/:storyId', writerController.getStory); 
module.exports = router; 
