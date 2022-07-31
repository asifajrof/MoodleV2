const pool = require('../models/db_connect');
const HttpError = require('../models/http-error');


const getCourseById = async (req, res, next) => {
    try{
        const courseId = req.params.course_id;
        let result = await pool.query('SELECT * FROM current_courses WHERE _id = $1', [courseId]);
        const course = result.rows[0];
        // console.log()
        if(!course) {
            next(new HttpError('Course not found', 404));
        }
        else{
            res.json({message:'getCourseById', data: course});
        }
    } catch(error) {
        return next(new HttpError(error.message, 500));
    }
};

const getCourseTopicsById = async (req, res, next) => {
    try{
        const courseId = req.params.course_id;
        let result = await pool.query('SELECT json_agg(t) FROM get_course_topics($1) as t', [courseId]);
        const courseTopics = result.rows[0].json_agg;
        // console.log()
        if(!courseTopics) {
            next(new HttpError('Course not found', 404));
        }
        else{
            res.json({message:'getCourseTopicsById', data: courseTopics});
        }
    } catch(error) {
        return next(new HttpError(error.message, 500));
    }
};

exports.getCourseById = getCourseById;
exports.getCourseTopicsById = getCourseTopicsById;
