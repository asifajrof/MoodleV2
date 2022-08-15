const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

// const courses = [
//   {
//     id: 1,
//     term: "January",
//     _year: 2022,
//     dept_shortname: "CSE",
//     course_code: "405",
//     course_name: "Computer Security",
//   },
//   {
//     id: 2,
//     term: "January",
//     _year: 2022,
//     dept_shortname: "CSE",
//     course_code: "406",
//     course_name: "Computer Security Sessional",
//   },
//   {
//     id: 3,
//     term: "January",
//     _year: 2022,
//     dept_shortname: "CSE",
//     course_code: "408",
//     course_name: "Software Development Sessional",
//   },
//   {
//     id: 4,
//     term: "January",
//     _year: 2022,
//     dept_shortname: "CSE",
//     course_code: "409",
//     course_name: "Computer Graphics",
//   },
//   {
//     id: 5,
//     term: "January",
//     _year: 2022,
//     dept_shortname: "CSE",
//     course_code: "423",
//     course_name: "FTS",
//   },
// ];
const getCurrentCoursesByUsername = async (req, res, next) => {
  try {
    // console.log('GET api/student/courses/current/:student_id');
    const userName = req.params.userName;
    let result = await pool.query(
      "select json_agg(t) from get_current_course_teacher($1) as t",
      [userName]
    );
    const courses = result.rows[0].json_agg;
    if (!courses) {
      res.json({ message: "No course assigned yet!", data: [] });
    } else {
      res.json({ message: "getCurrentCoursesByuserName", data: courses });
    }
  } catch (error) {
    next(new HttpError(error.message, 500));
  }
};

const getUpcomingEventsByUsername = async (req, res, next) => {
  try {
    // console.log('GET api/student/upcoming/:student_id');
    // const studentId = req.params.userName;
    // let result = await pool.query(
    //   "SELECT json_agg(t) FROM get_upcoming_events($1) as t",
    //   [userName]
    // );
    // const upcomingEvents = result.rows[0].json_agg;
    // // console.log(upcomingEvents)
    // if (!upcomingEvents) {
    //   // next(new HttpError('Upcoming Events not found', 404));
    res.json({ message: "No upcoming events yet!", data: [] });
    // } else {
    //   res.json({
    //     message: "getUpcomingEventsByStudentId",
    //     data: upcomingEvents,
    //   });
    // }
  } catch (error) {
    next(new HttpError(error.message, 500));
  }
};

exports.getCurrentCoursesByUsername = getCurrentCoursesByUsername;
exports.getUpcomingEventsByUsername = getUpcomingEventsByUsername;