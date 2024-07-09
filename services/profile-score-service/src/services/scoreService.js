const scoreRepository = require('../repositories/scoreRepository'); 
exports.addScore = async (data) =
  return await scoreRepository.updateScore(data.userId, data.projectId, data.score, 'add'); 
}; 
exports.deductScore = async (data) =
  return await scoreRepository.updateScore(data.userId, data.projectId, data.score, 'deduct'); 
}; 
exports.getScore = async (userId, projectId) =
  return await scoreRepository.findScore(userId, projectId); 
}; 
exports.getScoreLogs = async (userId, projectId) =
  return await scoreRepository.findScoreLogs(userId, projectId); 
}; 
