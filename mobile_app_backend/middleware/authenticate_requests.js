const jwt = require("jsonwebtoken");
require("dotenv").config();

function authenticateToken(req, res, next) {
  const authHeader = req.header("Authorization");
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Access denied." });
  }

  const token = authHeader.split(" ")[1]; // Extract the token

  try {
    const verified = jwt.verify(token, process.env.JWT_SECRET);
    req.user = verified; // Attach decoded user to request object
    next(); // Continue to the next middleware/route
  } catch (err) {
    return res.status(403).json({ error: "Access denied." });
  }
}

module.exports = authenticateToken;
