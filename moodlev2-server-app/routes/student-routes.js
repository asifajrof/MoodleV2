const express = require('express');

const studentControllers = require('../controllers/student-controllers');

const router = express.Router();

// remember to keep order of route

router.get('/', (req, res, next) => {
    console.log('GET /student');
    res.json({message: 'it works!'});
});

// router.get('/course/:course_id', studentControllers.getCourseById);

// router.post('/', studentControllers.createCourse);

// router.patch('/course/:course_id', studentControllers.updateCourseById);
// router.delete('/course/:course_id', studentControllers.deleteCourseById);

module.exports = router;
