const express = require("express");

const resourceControllers = require("../controllers/resource-controllers");

const resourceRoutes = express.Router();

resourceRoutes.get("/view/:courseId", resourceControllers.showResourceFiles); //

resourceRoutes.get(
	"/download/:fileID/:isStudent",
	resourceControllers.downloadResourceFile
); // --> need fileId, uploader type
resourceRoutes.get(
	"/info/:fileID/:isStudent",
	resourceControllers.getResourceFileInfo
); // --> need fileId, uploader type

resourceRoutes.post("/upload", resourceControllers.ResourceUpload); // userid, user type, courseid, title

module.exports = resourceRoutes;
