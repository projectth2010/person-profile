const mongoose = require('mongoose'); 
const scoreSchema = new mongoose.Schema({ 
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, 
  project: { type: mongoose.Schema.Types.ObjectId, ref: 'Project', required: true }, 
  score: { type: Number, required: true, default: 0 }, 
  logs: [{ 
    action: { type: String, enum: ['add', 'deduct'], required: true }, 
    score: { type: Number, required: true }, 
    date: { type: Date, default: Date.now } 
  }] 
}, { timestamps: true }); 
module.exports = mongoose.model('Score', scoreSchema); 
