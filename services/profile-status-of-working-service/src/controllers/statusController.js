const statusService = require('../services/statusService'); 
exports.setStatus = async (req, res) =
  try { 
    const status = await statusService.setStatus(req.body); 
    res.status(201).json(status); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getStatus = async (req, res) =
  try { 
    const status = await statusService.getStatus(req.params.userId); 
    res.status(200).json(status); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
