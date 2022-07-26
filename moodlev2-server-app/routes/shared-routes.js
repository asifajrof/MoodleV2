const express = require("express");

const sharedControllers = require("../controllers/shared-controllers");

const sharedRoutes = express.Router();

// remember to keep order of route

sharedRoutes.get("/", (req, res, next) => {
	console.log("GET /shared");
	res.json({ message: "it works!" });
});

sharedRoutes.get("/event/:eventId/:uId", sharedControllers.getEventDetails);
sharedRoutes.get("/topics/:course_id", sharedControllers.getCourseTopicsById);
sharedRoutes.get("/:course_id", sharedControllers.getCourseById);
sharedRoutes.post("/events", sharedControllers.getCourseEvents);
sharedRoutes.post("/events_teacher", sharedControllers.getCourseEventsTeacher);
sharedRoutes.post("/addNewCourseTopic", sharedControllers.addNewCourseTopic);
sharedRoutes.post("/addNewEvent", sharedControllers.addNewCourseEvent);
sharedRoutes.get("/getSubmissions/:eventId", sharedControllers.getSubmissions);
sharedRoutes.get("/grade/:eventId", sharedControllers.teacherGradeList);
module.exports = sharedRoutes;
