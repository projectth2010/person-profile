const mongoose = require('mongoose'); 
const albumSchema = new mongoose.Schema({ 
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, 
  name: { type: String, required: true }, 
  images: [{ type: String, required: true }] 
}, { timestamps: true }); 
module.exports = mongoose.model('Album', albumSchema); 
