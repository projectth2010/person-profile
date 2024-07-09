const addressService = require('../services/addressService'); 
exports.addAddress = async (req, res) =
  try { 
    const address = await addressService.addAddress(req.body); 
    res.status(201).json(address); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getAddresses = async (req, res) =
  try { 
    const addresses = await addressService.getAddresses(req.params.userId); 
    res.status(200).json(addresses); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.updateAddress = async (req, res) =
  try { 
    const address = await addressService.updateAddress(req.params.addressId, req.body); 
    res.status(200).json(address); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.deleteAddress = async (req, res) =
  try { 
    await addressService.deleteAddress(req.params.addressId); 
    res.status(204).end(); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
