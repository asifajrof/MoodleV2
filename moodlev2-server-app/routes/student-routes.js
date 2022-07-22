const express = require('express');

const studentControllers = require('../controllers/student-controllers');

const studentRoutes = express.Router();

// remember to keep order of route

studentRoutes.get('/', (req, res, next) => {
    console.log('GET /student');
    res.json({message: 'it works!'});
});

studentRoutes.get('/course/:course_id', studentControllers.getCourseById);

// router.post('/', studentControllers.createCourse);

// router.patch('/course/:course_id', studentControllers.updateCourseById);
// router.delete('/course/:course_id', studentControllers.deleteCourseById);

module.exports = studentRoutes;
