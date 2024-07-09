const writerRepository = require('../repositories/writerRepository'); 
const profileScoreService = require('../services/profileScoreService'); 
exports.createStory = async (storyData) =
  const story = await writerRepository.createStory(storyData); 
  await profileScoreService.incrementScore(story.user, "นักเขียนตัวยง"); 
  return story; 
}; 
exports.getStories = async (userId) =
  return await writerRepository.findStoriesByUser(userId); 
}; 
exports.getStory = async (storyId) =
  const story = await writerRepository.findStoryById(storyId); 
  if (story) { 
    story.accessCount += 1; 
    await story.save(); 
  } 
  return story; 
}; 
