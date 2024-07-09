const writerService = require('../services/writerService'); 
exports.createStory = async (req, res) =
  try { 
    const story = await writerService.createStory(req.body); 
    res.status(201).json(story); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getStories = async (req, res) =
  try { 
    const stories = await writerService.getStories(req.params.userId); 
    res.status(200).json(stories); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getStory = async (req, res) =
  try { 
    const story = await writerService.getStory(req.params.storyId); 
    res.status(200).json(story); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
