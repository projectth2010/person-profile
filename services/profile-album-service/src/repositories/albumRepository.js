const Album = require('../models/album'); 
exports.createAlbum = async (albumData) =
  const album = new Album(albumData); 
  return await album.save(); 
}; 
exports.findAlbumsByUser = async (userId) =
  return await Album.find({ user: userId }); 
}; 
exports.addImageToAlbum = async (albumId, image) =
  const album = await Album.findById(albumId); 
  if (album) { 
    throw new Error('Album not found'); 
  } 
  album.images.push(image); 
  return await album.save(); 
}; 
