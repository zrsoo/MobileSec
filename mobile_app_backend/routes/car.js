const express = require("express");
const pool = require("../services/db");
const router = express.Router();
const authenticateToken = require("../middleware/authenticate_requests");

// Get all cars
router.get("/", authenticateToken, async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM cars ORDER BY year ASC");
    res.json(result.rows);
  } catch (error) {
    console.error("Error fetching cars:", error);
    res.status(500).json({ error: "Internal server error" });
  }
});

// Delete car by id
router.delete("/:id", authenticateToken, async (req, res) => {
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
router.put("/:id", authenticateToken, async (req, res) => {
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

  // Add car
router.post("/", authenticateToken, async (req, res) => {
    const { brand, model, year } = req.body;
  
    // Validate input
    if (!brand || !model || !year) {
      return res.status(400).json({ error: "All fields (brand, model, year) are required!" });
    }
  
    if (isNaN(year)) {
      return res.status(400).json({ error: "Invalid year!" });
    }
  
    try {
      // Insert into database (default condition = 100)
      const result = await pool.query(
        "INSERT INTO cars (brand, model, year, condition) VALUES ($1, $2, $3, $4) RETURNING *",
        [brand, model, year, 100]
      );
  
      res.status(201).json({ message: "Car added successfully!", car: result.rows[0] });
    } catch (error) {
      console.error("Error adding car:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  });

module.exports = router;
