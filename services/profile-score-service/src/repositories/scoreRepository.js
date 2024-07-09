const Score = require('../models/score'); 
exports.updateScore = async (userId, projectId, score, action) =
  const scoreEntry = await Score.findOne({ user: userId, project: projectId }); 
  if (scoreEntry) { 
    const newScore = new Score({ 
      user: userId, 
      project: projectId, 
      score: action === 'add' ? score : -score, 
      logs: [{ action, score }] 
    }); 
    return await newScore.save(); 
  } 
  if (action === 'add') { 
    scoreEntry.score += score; 
  } else { 
    scoreEntry.score -= score; 
  } 
  scoreEntry.logs.push({ action, score }); 
  return await scoreEntry.save(); 
}; 
exports.findScore = async (userId, projectId) =
  return await Score.findOne({ user: userId, project: projectId }); 
}; 
exports.findScoreLogs = async (userId, projectId) =
  const scoreEntry = await Score.findOne({ user: userId, project: projectId }); 
  return scoreEntry ? scoreEntry.logs : []; 
}; 
