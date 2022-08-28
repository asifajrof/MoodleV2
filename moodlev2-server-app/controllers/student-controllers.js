const { v4: uuid } = require("uuid");

const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

const createCourse = (req, res, next) => {
	const { course_id, course_name, course_num, dept_code, _year, level, term } =
		req.body;
	const createdCourse = {
		course_id: uuid(),
		course_name,
		course_num,
		dept_code,
		_year,
		level,
		term,
	};
	DUMMY_COURSES.push(createdCourse);
	res.status(201).json({ course: createdCourse });
};

const deleteCourseById = (req, res, next) => {
	const courseId = req.params.course_id;
	if (!DUMMY_COURSES.find((c) => c.course_id === courseId)) {
		next(new HttpError("Could not find a course for that id.", 404));
	} else {
		DUMMY_COURSES = DUMMY_COURSES.filter(
			(c) => c.course_id !== req.params.course_id
		);
		res.status(200).json({ message: "Deleted course." });
	}
};

const getCurrentCoursesByStudentId = async (req, res, next) => {
	try {
		// console.log('GET api/student/courses/current/:student_id');
		const studentId = req.params.student_id;
		// console.log(typeof studentId);
		// console.log(studentId);
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_current_course($1) as t",
			[studentId]
		);
		const courses = result.rows[0].json_agg;
		if (!courses) {
			next(new HttpError("Courses not found", 404));
		} else {
			res.json({ message: "getCurrentCoursesByStudentId", data: courses });
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const getAllCoursesByStudentId = async (req, res, next) => {
	try {
		// console.log('GET api/student/courses/current/:student_id');
		const studentId = req.params.student_id;
		// console.log(typeof studentId);
		// console.log(studentId);
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_all_course($1) as t",
			[studentId]
		);
		// console.log(result);
		const courses = result.rows[0].json_agg;
		if (!courses) {
			next(new HttpError("Courses not found", 404));
		} else {
			res.json({ message: "getAllCoursesByUserName", data: courses });
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const getUpcomingEventsByStudentId = async (req, res, next) => {
	try {
		// console.log('GET api/student/upcoming/:student_id');
		const studentId = req.params.student_id;
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_upcoming_events($1) as t",
			[studentId]
		);
		const upcomingEvents = result.rows[0].json_agg;
		// console.log(upcomingEvents);
		if (!upcomingEvents) {
			// next(new HttpError('Upcoming Events not found', 404));
			res.json({ message: "getUpcomingEventsByStudentId", data: [] });
		} else {
			res.json({
				message: "getUpcomingEventsByStudentId",
				data: upcomingEvents,
			});
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const getEventGrade = async (req, res, next) => {
	try {
		const { courseId, studentId } = req.body;
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_grading_student($1, $2) as t",
			[studentId, courseId]
		);
		const all_event_grades = result.rows[0].json_agg;
		let grade_list = [];
		if (all_event_grades != null) {
			for (e of all_event_grades) {
				const obj = {
					eventName: e.eventname,
					event_ended: e.event_ended,
					totalMarks: e.totalMarks,
					marks: e.obtainedMarks,
				};
				grade_list.push(obj);
			}
		}
		res.json({ message: "getEventGradeStudent", data: grade_list });
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

exports.getEventGrade = getEventGrade;
exports.createCourse = createCourse;
exports.deleteCourseById = deleteCourseById;
exports.getCurrentCoursesByStudentId = getCurrentCoursesByStudentId;
exports.getUpcomingEventsByStudentId = getUpcomingEventsByStudentId;
exports.getAllCoursesByStudentId = getAllCoursesByStudentId;
