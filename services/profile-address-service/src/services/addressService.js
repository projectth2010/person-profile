const addressRepository = require('../repositories/addressRepository'); 
exports.addAddress = async (addressData) =
  return await addressRepository.createAddress(addressData); 
}; 
exports.getAddresses = async (userId) =
  return await addressRepository.findAddressesByUser(userId); 
}; 
exports.updateAddress = async (addressId, addressData) =
  return await addressRepository.updateAddress(addressId, addressData); 
}; 
exports.deleteAddress = async (addressId) =
  return await addressRepository.deleteAddress(addressId); 
}; 
