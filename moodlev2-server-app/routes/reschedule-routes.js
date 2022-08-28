const express = require("express");

const rescheduleControllers = require("../controllers/reschedule-controllers");

const rescheduleRoutes = express.Router();

rescheduleRoutes.post("/view", rescheduleControllers.getRescheduleEvents); //

module.exports = rescheduleRoutes;
