const albumService = require('../services/albumService'); 
exports.createAlbum = async (req, res) =
  try { 
    const album = await albumService.createAlbum(req.body); 
    res.status(201).json(album); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.getAlbums = async (req, res) =
  try { 
    const albums = await albumService.getAlbums(req.params.userId); 
    res.status(200).json(albums); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
exports.addImageToAlbum = async (req, res) =
  try { 
    const album = await albumService.addImageToAlbum(req.params.albumId, req.body.image); 
    res.status(200).json(album); 
  } catch (err) { 
    res.status(400).json({ error: err.message }); 
  } 
}; 
