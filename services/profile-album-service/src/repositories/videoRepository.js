const Video = require('../models/video'); 
exports.createVideo = async (videoData) =
  const video = new Video(videoData); 
  return await video.save(); 
}; 
exports.findVideosByUser = async (userId) =
  return await Video.find({ user: userId }); 
}; 
