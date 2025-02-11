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

// Delete car by id
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

// Update car by id
router.put("/:id", async (req, res) => {
    const carId = req.params.id;
    const { brand, model, year, condition } = req.body;
  
    try {
      // Prepare the update query dynamically
      const updates = [];
      const values = [];
      let counter = 1;
  
      if (brand) {
        updates.push(`brand = $${counter++}`);
        values.push(brand);
      }
      if (model) {
        updates.push(`model = $${counter++}`);
        values.push(model);
      }
      if (year) {
        updates.push(`year = $${counter++}`);
        values.push(year);
      }
      if (condition !== undefined) {
        updates.push(`condition = $${counter++}`);
        values.push(condition);
      }
  
      if (updates.length === 0) {
        return res.status(400).json({ error: "No fields to update." });
      }
  
      values.push(carId);
      const updateQuery = `UPDATE cars SET ${updates.join(", ")} WHERE id = $${counter} RETURNING *`;
  
      const result = await pool.query(updateQuery, values);
  
      if (result.rowCount === 0) {
        return res.status(404).json({ error: "Car not found!" });
      }
  
      res.json({ message: "Car updated successfully!", car: result.rows[0] });
    } catch (error) {
      console.error("Error updating car:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  });

module.exports = router;
