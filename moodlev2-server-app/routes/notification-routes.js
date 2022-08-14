const express = require("express");

const notificationControllers = require("../controllers/notification-controllers");

const notificationRoutes = express.Router();

notificationRoutes.get(
  "/:uId",
  notificationControllers.getNotificationsByUserName
);

module.exports = notificationRoutes;
