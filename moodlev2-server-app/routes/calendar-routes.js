const express = require("express");

const calendarControllers = require("../controllers/calendar-controllers");

const calendarRoutes = express.Router();

calendarRoutes.post("/mini", calendarControllers.getMarkDateList);
calendarRoutes.post("/month", calendarControllers.getEventListMonthView);

module.exports = calendarRoutes;
