const mongoose = require('mongoose'); 
const videoSchema = new mongoose.Schema({ 
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, 
  title: { type: String, required: true }, 
  videoData: { type: String, required: true }, 
  duration: { type: Number, required: true, max: 30 } 
}, { timestamps: true }); 
module.exports = mongoose.model('Video', videoSchema); 
