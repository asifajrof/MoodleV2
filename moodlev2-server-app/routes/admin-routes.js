const express = require('express');

const adminControllers = require('../controllers/admin-controllers');

const adminRoutes = express.Router();

// remember to keep order of route

studentRoutes.get('/', (req, res, next) => {
    console.log('GET /admin');
    res.json({message: 'it works!'});
});

// student home. get all current courses by student id
studentRoutes.get('/courses/current/:student_id', studentControllers.getCurrentCoursesByStudentId);
studentRoutes.get('/upcoming/:student_id', studentControllers.getUpcomingEventsByStudentId);

module.exports = adminRoutes;
