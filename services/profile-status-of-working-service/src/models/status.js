const mongoose = require('mongoose'); 
const statusSchema = new mongoose.Schema({ 
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, 
  status: { type: String, enum: ['active', 'inactive', 'suspended'], required: true }, 
  updatedAt: { type: Date, default: Date.now } 
}, { timestamps: true }); 
module.exports = mongoose.model('Status', statusSchema); 
