const express = require('express'); 
const mongoose = require('mongoose'); 
const dotenv = require('dotenv'); 
dotenv.config(); 
const app = express(); 
app.use(express.json()); 
const writerRoutes = require('./routes/writerRoutes'); 
app.use('/api/writer', writerRoutes); 
const { PORT, MONGO_URI } = process.env; 
mongoose.connect(MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }) 
  .then(() =
    app.listen(PORT, () =
      console.log(`Profile Writer service is running on port ${PORT}`); 
    }); 
  }) 
  .catch(err =
    console.error('Database connection error:', err); 
  }); 
