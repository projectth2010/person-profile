const Writer = require('../models/writer'); 
exports.createStory = async (storyData) =
  const story = new Writer(storyData); 
  return await story.save(); 
}; 
exports.findStoriesByUser = async (userId) =
  return await Writer.find({ user: userId }); 
}; 
exports.findStoryById = async (storyId) =
  return await Writer.findById(storyId); 
}; 
