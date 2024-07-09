const mongoose = require('mongoose'); 
const writerSchema = new mongoose.Schema({ 
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, 
  title: { type: String, required: true }, 
  content: { type: String, required: true }, 
  images: [{ type: String, required: false }], 
  accessCount: { type: Number, default: 0 } 
}, { timestamps: true }); 
module.exports = mongoose.model('Writer', writerSchema); 
