const albumRepository = require('../repositories/albumRepository'); 
exports.createAlbum = async (albumData) =
  return await albumRepository.createAlbum(albumData); 
}; 
exports.getAlbums = async (userId) =
  return await albumRepository.findAlbumsByUser(userId); 
}; 
exports.addImageToAlbum = async (albumId, image) =
  return await albumRepository.addImageToAlbum(albumId, image); 
}; 
