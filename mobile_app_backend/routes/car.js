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

// Delete a car by ID
router.delete("/:id", async (req, res) => {
    const carId = req.params.id;
  
    try {
      const result = await pool.query("DELETE FROM cars WHERE id = $1", [carId]);
  
      if (result.rowCount === 0) {
        return res.status(404).json({ error: "Car not found!" });
      }
  
      res.json({ message: "Car deleted successfully!" });
    } catch (error) {
      console.error("Error deleting car:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  });

module.exports = router;
