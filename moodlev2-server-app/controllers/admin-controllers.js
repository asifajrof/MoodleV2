const { v4: uuid } = require("uuid");

const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

const addNewCourse = async (req, res, next) => {
  try {
    console.log("POST api/admin/addNewCourse");

    const {
      courseName,
      courseNum,
      courseLevel,
      courseTerm,
      courseBatch,
      courseYear,
      deptOffered,
      deptOffering,
    } = req.body;

    console.log(
      typeof courseName,
      typeof courseNum,
      typeof courseLevel,
      typeof courseTerm,
      typeof courseBatch,
      typeof courseYear,
      typeof deptOffered,
      typeof deptOffering
    );

    // console.log(
    //   "do $$ begin execute add_course($1,$2,$3,$4,$5,$6,$7,$8); end; $$;",
    //   [
    //     courseName,
    //     courseNum,
    //     deptOffering,
    //     deptOffered,
    //     courseBatch,
    //     courseYear,
    //     courseLevel,
    //     courseTerm,
    //   ]
    // );
    let result = await pool.query(
      // "do $$ begin execute add_course($1,$2,$3,$4,$5,$6,$7,$8); end; $$;",
      "insert into course (course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) values($1,$2,$3,$4,$5,$6,$7,$8);",
      [
        courseName,
        courseNum,
        deptOffering,
        deptOffered,
        courseBatch,
        courseYear,
        courseLevel,
        courseTerm,
      ]
    );

    res.json({ message: "new course added" });
  } catch (err) {
    console.log(err);
    return next(new HttpError(err.message, 500));
  }
};
const getAllCourses = async (req, res, next) => {
  try {
    console.log("GET api/admin/courses/all");
    let result = await pool.query("Select * from current_courses");
    const courses = result.rows;
    console.log(courses);
    console.log(result);
    if (!courses) {
      next(new HttpError("Courses not found", 404));
    } else {
      res.json({ message: "getAllCourses", data: courses });
    }
  } catch (err) {
    return next(new HttpError(error.message, 500));
  }
};

const getDeptList = async (req, res, next) => {
  try {
    console.log("GET api/admin/dept_list");
    let result = await pool.query(
      "SELECT json_agg(t) FROM get_dept_list() as t"
    );
    const courses = result.rows[0].json_agg;
    console.log(courses);
    console.log(result);
    if (!courses) {
      next(new HttpError("Courses not found", 404));
    } else {
      res.json({ message: "getAllCourses", data: courses });
    }
  } catch (err) {
    return next(new HttpError(error.message, 500));
  }
};

const postCourseAdd = async (req, res, next) => {
  try {
    const { data } = req.body;
    console.log(data);
    res.json({ message: "course added" });
  } catch (err) {
    return next(new HttpError(error.message, 500));
  }
};

const postDeptAdd = async (req, res, next) => {
  try {
    console.log(req.body);
    const { deptName, deptShortName, deptCode } = req.body;
    queryRes = await pool.query("insert into department values ($1,$2,$3)", [
      deptCode,
      deptName,
      deptShortName,
    ]);
    res.json({ message: "new dept added" });
  } catch (error) {
    return next(new HttpError(error.message, 500));
  }
};

exports.getAllCourses = getAllCourses;
exports.getDeptList = getDeptList;
exports.postCourseAdd = postCourseAdd;
exports.postDeptAdd = postDeptAdd;
exports.addNewCourse = addNewCourse;
