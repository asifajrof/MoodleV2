const express = require("express");

const fileControllers = require("../controllers/file-controllers");

const fileRoutes = express.Router();

fileRoutes.get("/:fileID", fileControllers.getFileInfo);
fileRoutes.get("/download/:fileID", fileControllers.getFile);

module.exports = fileRoutes;
