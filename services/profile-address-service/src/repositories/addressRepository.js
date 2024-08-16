const Address = require('../models/address'); 
exports.createAddress = async (addressData) =
  const address = new Address(addressData); 
  return await address.save(); 
}; 
exports.findAddressesByUser = async (userId) =
  return await Address.find({ user: userId }); 
}; 
exports.updateAddress = async (addressId, addressData) =
  return await Address.findByIdAndUpdate(addressId, addressData, { new: true }); 
}; 
exports.deleteAddress = async (addressId) =
  return await Address.findByIdAndDelete(addressId); 
}; 
