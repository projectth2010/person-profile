const express = require('express'); 
const router = express.Router(); 
const statusController = require('../controllers/statusController'); 
router.post('/set', statusController.setStatus); 
router.get('/:userId', statusController.getStatus); 
module.exports = router; 
