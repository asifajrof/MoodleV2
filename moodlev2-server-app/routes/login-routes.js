const express = require("express");

const loginControllers = require("../controllers/login-controllers");

const loginRoutes = express.Router();

loginRoutes.post("/", loginControllers.loginAuthenticate);

module.exports = loginRoutes;
