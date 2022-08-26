const express = require("express");

const adminControllers = require("../controllers/admin-controllers");

const adminRoutes = express.Router();

// remember to keep order of route

adminRoutes.get("/", (req, res, next) => {
	console.log("GET /admin");
	res.json({ message: "it works!" });
});

// admin home. get all courses
adminRoutes.get("/teachers/all", adminControllers.getAllTeachers);
adminRoutes.get("/students/all", adminControllers.getAllStudents);
adminRoutes.get("/courses/all", adminControllers.getAllCourses);
adminRoutes.get("/dept_list", adminControllers.getDeptList);
adminRoutes.post("/addcourse", adminControllers.postCourseAdd);
adminRoutes.post("/adddept", adminControllers.postDeptAdd);
adminRoutes.post("/addNewCourse", adminControllers.addNewCourse);
adminRoutes.post("/addNewTeacher", adminControllers.addNewTeacher);
adminRoutes.post("/addNewStudent", adminControllers.addNewStudent);
adminRoutes.get(
	"/course/:courseId/teachers",
	adminControllers.getAllCourseTeachers
);
adminRoutes.get(
	"/course/:courseId/students",
	adminControllers.getAllCourseStudents
);

module.exports = adminRoutes;
