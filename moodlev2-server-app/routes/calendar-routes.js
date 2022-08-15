const express = require("express");

const calendarControllers = require("../controllers/calendar-controllers");

const calendarRoutes = express.Router();

calendarRoutes.post("/mini", calendarControllers.getMarkDateList);

module.exports = calendarRoutes;
