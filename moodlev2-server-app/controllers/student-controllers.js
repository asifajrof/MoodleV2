const {v4: uuid} = require('uuid');

const HttpError = require('../models/http-error');

let DUMMY_COURSES = [
    {
        course_id: '1',
        course_name: 'Course 1',
        course_num: '1',
        dept_code: '5',
        _year: '2018',
        level: '1',
        term: '1'
    }
];

const getCourseById = (req, res, next) => {
    const courseId = req.params.course_id;
    const course = DUMMY_COURSES.find(c => c.course_id === courseId);
    if(!course) {
        // console.log('Course not found');
        // res.status(404).json({message: 'Course not found'});
        // const error = new Error('Course not found');
        // error.status = 404;
        // throw error;    // does not use this in async function
        // next(error);

        next(new HttpError('Course not found', 404));
    } else {
        console.log('GET /student');
        res.json({course});
    }
};

const createCourse = (req, res, next) => {
    const {course_id, course_name, course_num, dept_code, _year, level, term} = req.body;
    const createdCourse = {
        course_id: uuid(),
        course_name,
        course_num,
        dept_code,
        _year,
        level,
        term
    };
    DUMMY_COURSES.push(createdCourse);
    res.status(201).json({course: createdCourse});
};

// sample json
/* 
{
    "course_name": "Course 2",
    "course_num": "2",
    "dept_code": "5",
    "_year": "2018",
    "level": "1",
    "term": "1"
}
*/

const updateCourseById = (req, res, next) => {
    const courseId = req.params.course_id;
    const {course_name, course_num, dept_code, _year, level, term} = req.body;

    const updatedCourse = { ...DUMMY_COURSES.find(c => c.course_id === courseId) };
    const courseIndex = DUMMY_COURSES.findIndex(c => c.course_id === courseId);
    updatedCourse.course_name = course_name || updatedCourse.course_name;
    updatedCourse.course_num = course_num || updatedCourse.course_num;
    updatedCourse.dept_code = dept_code || updatedCourse.dept_code;
    updatedCourse._year = _year || updatedCourse._year;
    updatedCourse.level = level || updatedCourse.level;
    updatedCourse.term = term || updatedCourse.term;

    DUMMY_COURSES[courseIndex] = updatedCourse;

    res.status(200).json({ course: updatedCourse });

};

const deleteCourseById = (req, res, next) => {
    const courseId = req.params.course_id;
    if(!DUMMY_COURSES.find(c => c.course_id === courseId)) {
        next(new HttpError('Could not find a course for that id.', 404));
    } else {
        DUMMY_COURSES = DUMMY_COURSES.filter(c => c.course_id !== req.params.course_id);
        res.status(200).json({ message: 'Deleted course.' });
    }
};

exports.getCourseById = getCourseById;
exports.createCourse = createCourse;
exports.updateCourseById = updateCourseById;
exports.deleteCourseById = deleteCourseById;
