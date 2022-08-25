const express = require("express");

const fileControllers = require("../controllers/file-controllers");

const fileRoutes = express.Router();

fileRoutes.get("/:fileID", fileControllers.getFileInfo);
fileRoutes.get("/download/:fileID", fileControllers.getFile);
fileRoutes.post(
	"/upload/student/course/evaluation",
	fileControllers.StudentCourseAssignmentSubmit
);
// fileRoutes.post("/upload/student/course/resource/:fileID", fileControllers.getFile);
// fileRoutes.post("/upload/student/private/:fileID", fileControllers.getFile);
// fileRoutes.post("/upload/teacher/course/resource/:fileID", fileControllers.getFile);
// fileRoutes.post("/upload/teacher/private/:fileID", fileControllers.getFile);
// fileRoutes.post("/upload/teacher/course/evaluation/:fileID", fileControllers.getFile);
// fileRoutes.post("/upload/teacher/course/forum/:fileID", fileControllers.getFile);
// fileRoutes.post("/upload/teacher/forum/:fileID", fileControllers.getFile);

// fileRoutes.post("/download/student/course/resource", fileControllers.getFile);
// fileRoutes.post("/download/student/private", fileControllers.getFile);
// fileRoutes.post("/download/teacher/course/resource", fileControllers.getFile);
// fileRoutes.post("/download/teacher/private", fileControllers.getFile);
// fileRoutes.post("/download/teacher/course/evaluation", fileControllers.getFile);
// fileRoutes.post("/download/teacher/course/forum", fileControllers.getFile);
// fileRoutes.post("/download/teacher/forum", fileControllers.getFile);

module.exports = fileRoutes;
