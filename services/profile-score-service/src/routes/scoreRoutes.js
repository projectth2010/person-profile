const express = require('express'); 
const router = express.Router(); 
const scoreController = require('../controllers/scoreController'); 
router.post('/add', scoreController.addScore); 
router.post('/deduct', scoreController.deductScore); 
router.get('/:userId/:projectId', scoreController.getScore); 
router.get('/logs/:userId/:projectId', scoreController.getScoreLogs); 
module.exports = router; 
