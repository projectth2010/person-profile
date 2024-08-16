const mongoose = require('mongoose'); 
const profileSchema = new mongoose.Schema({ 
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, 
  firstName: { type: String, required: true }, 
  lastName: { type: String, required: true }, 
  age: { type: Number, required: true }, 
  address: { 
    street: { type: String, required: true }, 
    city: { type: String, required: true }, 
    state: { type: String, required: true }, 
    zip: { type: String, required: true } 
  }, 
  profileImage: { type: String, required: false } 
}, { timestamps: true }); 
module.exports = mongoose.model('Profile', profileSchema); 
