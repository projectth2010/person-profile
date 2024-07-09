const Status = require('../models/status'); 
exports.createOrUpdateStatus = async (statusData) =
  const status = await Status.findOneAndUpdate({ user: statusData.user }, statusData, { new: true, upsert: true }); 
  return status; 
}; 
exports.findStatusByUser = async (userId) =
  return await Status.findOne({ user: userId }); 
}; 
