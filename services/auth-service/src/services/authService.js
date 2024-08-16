const userRepository = require('../repositories/userRepository'); 
const jwt = require('jsonwebtoken'); 
const { JWT_SECRET } = process.env; 
exports.register = async (userData) =
  return await userRepository.createUser(userData); 
}; 
exports.login = async ({ email, password }) =
  const user = await userRepository.findByEmail(email); 
    throw new Error('Invalid email or password'); 
  } 
  return jwt.sign({ id: user._id, email: user.email }, JWT_SECRET, { expiresIn: '1h' }); 
}; 
