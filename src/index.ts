import { Request, Response, NextFunction } from "express";
import router from "./routes/routes";

const dotenv = require("dotenv");
const cors = require("cors");

const express = require("express");
const app = express();

app.use(express.json());

// load environment variables
dotenv.config();

const PORT = process.env.PORT || 5000;

app.get("/", (req: Request, res: Response) => {
  res.json({ status: "API is running on /api" });
});

// setup cors
app.use(cors());
app.use(router);

app.listen(PORT, () =>
  console.log(`REST API server ready at: http://localhost:${PORT}`)
);

app.use((req: Request, res: Response, next: NextFunction) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, DELETE, UPDATE"
  );
  res.setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization");
  next();
  res.status(404);
  return res.json({
    success: false,
    message: `API SAYS: Endpoint not found for path: ${req.path}`,
  });
});
