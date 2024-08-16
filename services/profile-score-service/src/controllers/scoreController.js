const scoreService = require('../services/scoreService'); 
exports.addScore = async (req, res) =
  try { 
    const updatedScore = await scoreService.addScore(req.body); 
    res.status(200).json(updatedScore); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.deductScore = async (req, res) =
  try { 
    const updatedScore = await scoreService.deductScore(req.body); 
    res.status(200).json(updatedScore); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getScore = async (req, res) =
  try { 
    const score = await scoreService.getScore(req.params.userId, req.params.projectId); 
    res.status(200).json(score); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getScoreLogs = async (req, res) =
  try { 
    const logs = await scoreService.getScoreLogs(req.params.userId, req.params.projectId); 
    res.status(200).json(logs); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
