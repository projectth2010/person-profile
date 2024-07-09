const axios = require('axios'); 
const { PROFILE_SCORE_SERVICE_URL } = process.env; 
exports.incrementScore = async (userId, projectName) =
  try { 
    await axios.post(`${PROFILE_SCORE_SERVICE_URL}/api/score/increment`, { userId, projectName }); 
  } catch (error) { 
    console.error('Error incrementing score:', error); 
  } 
}; 
