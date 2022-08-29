const express = require("express");

const rescheduleControllers = require("../controllers/reschedule-controllers");

const rescheduleRoutes = express.Router();

rescheduleRoutes.post("/view", rescheduleControllers.getRescheduleEvents); //
rescheduleRoutes.post("/add/extra", rescheduleControllers.addExtraClass);
rescheduleRoutes.post("/add/cancel", rescheduleControllers.addCancelClass);
rescheduleRoutes.post("/info/extra", rescheduleControllers.getExtraClassInfo);

module.exports = rescheduleRoutes;
