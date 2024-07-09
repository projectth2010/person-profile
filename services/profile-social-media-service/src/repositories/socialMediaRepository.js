const SocialMedia = require('../models/socialMedia'); 
exports.createSocialMedia = async (socialMediaData) =
  const socialMedia = new SocialMedia(socialMediaData); 
  return await socialMedia.save(); 
}; 
exports.findSocialMediasByUser = async (userId) =
  return await SocialMedia.find({ user: userId }); 
}; 
exports.updateSocialMedia = async (socialMediaId, socialMediaData) =
  return await SocialMedia.findByIdAndUpdate(socialMediaId, socialMediaData, { new: true }); 
}; 
exports.deleteSocialMedia = async (socialMediaId) =
  return await SocialMedia.findByIdAndDelete(socialMediaId); 
}; 
