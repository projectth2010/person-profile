const Profile = require('../models/profile'); 
exports.createProfile = async (profileData) =
  const profile = new Profile(profileData); 
  return await profile.save(); 
}; 
exports.findProfileByUser = async (userId) =
  return await Profile.findOne({ user: userId }); 
}; 
