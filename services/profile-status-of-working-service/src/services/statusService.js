const statusRepository = require('../repositories/statusRepository'); 
exports.setStatus = async (statusData) =
  return await statusRepository.createOrUpdateStatus(statusData); 
}; 
exports.getStatus = async (userId) =
  return await statusRepository.findStatusByUser(userId); 
}; 
