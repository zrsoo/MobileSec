const express = require("express");
const pool = require("../services/db");
const router = express.Router();

// Get all cars
router.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM cars ORDER BY year ASC");
    res.json(result.rows);
  } catch (error) {
    console.error("Error fetching cars:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

module.exports = router;
