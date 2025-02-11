const { Pool } = require("pg");
require("dotenv").config();

// PostgreSQL connection pool
const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASS,
  port: process.env.DB_PORT,
});

pool.connect()
  .then(() => console.log("✅ PostgreSQL Connected!"))
  .catch(err => console.error("❌ Database Connection Error:", err));

module.exports = pool;
