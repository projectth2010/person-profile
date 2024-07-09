const mongoose = require('mongoose'); 
const socialMediaSchema = new mongoose.Schema({ 
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, 
  platform: { type: String, required: true }, 
  handle: { type: String, required: true }, 
  link: { type: String, required: true } 
}, { timestamps: true }); 
module.exports = mongoose.model('SocialMedia', socialMediaSchema); 
