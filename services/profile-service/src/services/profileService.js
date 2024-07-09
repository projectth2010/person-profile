const profileRepository = require('../repositories/profileRepository'); 
exports.createProfile = async (profileData) =
  return await profileRepository.createProfile(profileData); 
}; 
exports.getProfile = async (userId) =
  return await profileRepository.findProfileByUser(userId); 
}; 
