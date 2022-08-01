const express = require('express');

const adminControllers = require('../controllers/admin-controllers');

const adminRoutes = express.Router();

// remember to keep order of route

adminRoutes.get('/', (req, res, next) => {
    console.log('GET /admin');
    res.json({message: 'it works!'});
});

// admin home. get all courses
adminRoutes.get('/courses/all', adminControllers.getAllCourses);
adminRoutes.get('/dept_list', adminControllers.getDeptList);

module.exports = adminRoutes;
