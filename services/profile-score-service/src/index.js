const express = require('express'); 
const mongoose = require('mongoose'); 
const dotenv = require('dotenv'); 
dotenv.config(); 
const app = express(); 
app.use(express.json()); 
const scoreRoutes = require('./routes/scoreRoutes'); 
app.use('/api/score', scoreRoutes); 
const { PORT, MONGO_URI } = process.env; 
mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) 
  .then(() =
    app.listen(PORT, () =
      console.log(`Profile Score service is running on port ${PORT}`); 
    }); 
  }) 
  .catch(err =
    console.error('Database connection error:', err); 
  }); 
