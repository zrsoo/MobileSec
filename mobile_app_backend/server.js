require("dotenv").config();
const fs = require("fs");
const https = require("https");
const express = require("express");
const cors = require("cors");

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Import Routes
const authRoutes = require("./routes/auth");
const carRoutes = require("./routes/car");

// Register Routes
app.use("/auth", authRoutes);
app.use("/cars", carRoutes);

app.get("/", (req, res) => {
  res.send("Welcome to Secure API!");
});

// Load SSL Certificates for HTTPS
const sslOptions = {
  key: fs.readFileSync("server.key"),
  cert: fs.readFileSync("server.cert"),
};

// Start Secure HTTPS Server
https.createServer(sslOptions, app).listen(PORT, () => {
  console.log(`🚀 Secure server running on https://localhost:${PORT}`);
});
