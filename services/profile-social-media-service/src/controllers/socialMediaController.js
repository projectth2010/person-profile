const socialMediaService = require('../services/socialMediaService'); 
exports.addSocialMedia = async (req, res) =
  try { 
    const socialMedia = await socialMediaService.addSocialMedia(req.body); 
    res.status(201).json(socialMedia); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getSocialMedias = async (req, res) =
  try { 
    const socialMedias = await socialMediaService.getSocialMedias(req.params.userId); 
    res.status(200).json(socialMedias); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.updateSocialMedia = async (req, res) =
  try { 
    const socialMedia = await socialMediaService.updateSocialMedia(req.params.socialMediaId, req.body); 
    res.status(200).json(socialMedia); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.deleteSocialMedia = async (req, res) =
  try { 
    await socialMediaService.deleteSocialMedia(req.params.socialMediaId); 
    res.status(204).end(); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
