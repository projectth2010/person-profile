const videoService = require('../services/videoService'); 
exports.uploadVideo = async (req, res) =
  try { 
    const video = await videoService.uploadVideo(req.body); 
    res.status(201).json(video); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getVideos = async (req, res) =
  try { 
    const videos = await videoService.getVideos(req.params.userId); 
    res.status(200).json(videos); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
