const videoRepository = require('../repositories/videoRepository'); 
exports.uploadVideo = async (videoData) =
  return await videoRepository.createVideo(videoData); 
}; 
exports.getVideos = async (userId) =
  return await videoRepository.findVideosByUser(userId); 
}; 
