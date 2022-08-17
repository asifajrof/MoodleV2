const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

const getCourseById = async (req, res, next) => {
  try {
    const courseId = req.params.course_id;
    let result = await pool.query(
      "SELECT * FROM current_courses WHERE _id = $1",
      [courseId]
    );
    const course = result.rows[0];
    // console.log()
    if (!course) {
      res.json({ message: "No course like that!", data: [] });
    } else {
      res.json({ message: "getCourseById", data: course });
    }
  } catch (error) {
    return next(new HttpError(error.message, 500));
  }
};

const getCourseTopicsById = async (req, res, next) => {
  try {
    const courseId = req.params.course_id;
    let result = await pool.query(
      "SELECT json_agg(t) FROM get_course_topics($1) as t",
      [courseId]
    );
    const courseTopics = result.rows[0].json_agg;
    // console.log()
    if (!courseTopics) {
      res.json({ message: "No course topics given yet!", data: [] });
    } else {
      res.json({ message: "getCourseTopicsById", data: courseTopics });
    }
  } catch (error) {
    return next(new HttpError(error.message, 500));
  }
};

const getCourseEvents = async (req, res, next) => {
  try {
    const { studentNo, courseId } = req.body;
    let result = await pool.query(
      "SELECT json_agg(t) FROM  get_course_evaluations($1, $2) as t",
      [studentNo, courseId]
    );
    const courseEvents = result.rows[0].json_agg;
    // console.log()
    if (!courseEvents) {
      res.json({ message: "No course events given yet!", data: [] });
    } else {
      res.json({ message: "getCourseEventsById", data: courseEvents });
    }
  } catch (error) {
    return next(new HttpError(error.message, 500));
  }
};

const addNewCourseTopic = async (req, res, next) => {
  try {
    const { topicName, topicDescription, teacherUserName, courseId } = req.body;
    console.log(
      topicName,
      topicDescription,
      teacherUserName.userName,
      courseId
    );
    let result = await pool.query("select add_course_topic($1,$2,$3,$4,$5);", [
      topicName,
      courseId,
      teacherUserName.userName,
      topicDescription,
      false,
    ]);

    res.json({ message: "new course topic added" });
  } catch (err) {
    console.log(err);
    return next(new HttpError(err.message, 500));
  }
};

exports.getCourseById = getCourseById;
exports.getCourseTopicsById = getCourseTopicsById;
exports.getCourseEvents = getCourseEvents;
exports.addNewCourseTopic = addNewCourseTopic;
