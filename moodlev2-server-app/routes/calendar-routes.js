const express = require("express");

const calendarControllers = require("../controllers/calendar-controllers");

const calendarRoutes = express.Router();

calendarRoutes.post("/mini", calendarControllers.getMarkDateList);
calendarRoutes.post(
	"/getSectionSchedule",
	calendarControllers.getSectionSchedule
);
calendarRoutes.post("/month", calendarControllers.getEventListMonthView);
calendarRoutes.get("/event_type", calendarControllers.getEventType);
calendarRoutes.get(
	"/section_list/:courseId",
	calendarControllers.getSectionList
);

module.exports = calendarRoutes;
