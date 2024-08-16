const profileService = require('../services/profileService'); 
exports.createProfile = async (req, res) =
  try { 
    const profile = await profileService.createProfile(req.body); 
    res.status(201).json(profile); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getProfile = async (req, res) =
  try { 
    const profile = await profileService.getProfile(req.params.userId); 
    res.status(200).json(profile); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
