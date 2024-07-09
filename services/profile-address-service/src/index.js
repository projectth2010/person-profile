const express = require('express'); 
const mongoose = require('mongoose'); 
const dotenv = require('dotenv'); 
dotenv.config(); 
const app = express(); 
app.use(express.json()); 
const addressRoutes = require('./routes/addressRoutes'); 
app.use('/api/addresses', addressRoutes); 
const { PORT, MONGO_URI } = process.env; 
mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) 
  .then(() =
    app.listen(PORT, () =
      console.log(`Profile Address service is running on port ${PORT}`); 
    }); 
  }) 
  .catch(err =
    console.error('Database connection error:', err); 
  }); 
