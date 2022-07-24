const pool = require('../models/db_connect');
const HttpError = require('../models/http-error');


const getCourseById = async (req, res, next) => {
    try{
        const courseId = req.params.course_id;
        let result = await pool.query('SELECT * FROM course WHERE course_id = $1', [courseId]);
        const course = result.rows[0];
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

exports.getCourseById = getCourseById;
