const {v4: uuid} = require('uuid');

const pool = require('../models/db_connect');
const HttpError = require('../models/http-error');


const getAllCourses = async (req, res, next) => {
    try{
        console.log('GET api/admin/courses/all');
        let result = await pool.query('Select * from current_courses');
        const courses = result.rows;
        console.log(courses);
        console.log(result);
        if(!courses) {
            next(new HttpError('Courses not found', 404));
        } else {
            res.json({message:'getAllCourses', data: courses});
        }
    } catch(err) {
        return next(new HttpError(error.message, 500));
    }
};

const getDeptList = async (req, res, next) => {
    try{
        console.log('GET api/admin/dept_list');
        let result = await pool.query('SELECT json_agg(t) FROM get_dept_list() as t');
        const courses = result.rows[0].json_agg;
        console.log(courses);
        console.log(result);
        if(!courses) {
            next(new HttpError('Courses not found', 404));
        } else {
            res.json({message:'getAllCourses', data: courses});
        }
    } catch(err) {
        return next(new HttpError(error.message, 500));
    }
};

const postCourseAdd = async (req, res, next) => {
    try{
        const {data} = req.body;
        console.log(data);
        res.json({message:'course added'});
    } catch(err) {
        return next(new HttpError(error.message, 500));
    }
};

exports.getAllCourses = getAllCourses;
exports.getDeptList = getDeptList;
exports.postCourseAdd = postCourseAdd;
