const socialMediaRepository = require('../repositories/socialMediaRepository'); 
exports.addSocialMedia = async (socialMediaData) =
  return await socialMediaRepository.createSocialMedia(socialMediaData); 
}; 
exports.getSocialMedias = async (userId) =
  return await socialMediaRepository.findSocialMediasByUser(userId); 
}; 
exports.updateSocialMedia = async (socialMediaId, socialMediaData) =
  return await socialMediaRepository.updateSocialMedia(socialMediaId, socialMediaData); 
}; 
exports.deleteSocialMedia = async (socialMediaId) =
  return await socialMediaRepository.deleteSocialMedia(socialMediaId); 
}; 
