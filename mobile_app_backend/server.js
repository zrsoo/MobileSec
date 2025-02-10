require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');
const fs = require('fs');
const https = require('https');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// PostgreSQL Connection
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

// Test database connection
pool.connect()
  .then(() => console.log("✅ PostgreSQL Connected!"))
  .catch(err => console.error("❌ Database Connection Error:", err));

app.get("/", (req, res) => {
  res.send("Welcome to Secure API!");
});

// Import authentication routes
const authRoutes = require('./routes/auth');
app.use('/auth', authRoutes);

// Read SSL Certificate
const sslOptions = {
    key: fs.readFileSync('server.key'),
    cert: fs.readFileSync('server.cert')
  };

// Start HTTPS Server
https.createServer(sslOptions, app).listen(PORT, () => {
    console.log(`🚀 Secure server running on https://localhost:${PORT}`);
  });
