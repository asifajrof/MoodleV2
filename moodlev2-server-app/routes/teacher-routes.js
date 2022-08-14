const express = require("express");

const teacherControllers = require("../controllers/teacher-controllers");

const teacherRoutes = express.Router();

teacherRoutes.get("/", (req, res, next) => {
  console.log("GET /student");
  res.json({ message: "it works!" });
});

// teacher home. get all current courses by teacher username
teacherRoutes.get(
  "/courses/current/:userName",
  teacherControllers.getCurrentCoursesByUsername
);
teacherRoutes.get(
  "/upcoming/:userName",
  teacherControllers.getUpcomingEventsByUsername
);

module.exports = teacherRoutes;
