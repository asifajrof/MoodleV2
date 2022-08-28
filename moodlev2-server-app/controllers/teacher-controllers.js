const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

const getCurrentCoursesByUsername = async (req, res, next) => {
	try {
		// console.log("GET api/teacher/courses/current/:username");

		const userName = req.params.userName;
		// console.log(typeof userName);
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

const getAllCoursesByUsername = async (req, res, next) => {
	try {
		// console.log("GET api/teacher/courses/all/:username");

		const userName = req.params.userName;
		// console.log(typeof userName);
		let result = await pool.query(
			"select json_agg(t) from get_all_course_teacher($1) as t",
			[userName]
		);
		const courses = result.rows[0].json_agg;
		if (!courses) {
			res.json({ message: "No course assigned yet!", data: [] });
		} else {
			res.json({ message: "getAllCoursesByuserName", data: courses });
		}
	} catch (error) {
		next(new HttpError(error.message, 500));
	}
};

const getUpcomingEventsByUsername = async (req, res, next) => {
	try {
		console.log("GET api/teacher/upcoming/:username");
		const userName = req.params.userName;
		// console.log(typeof userName);
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_upcoming_events_teacher($1) as t",
			[userName]
		);
		const upcomingEvents = result.rows[0].json_agg;
		// console.log(upcomingEvents);
		if (!upcomingEvents) {
			// next(new HttpError('Upcoming Events not found', 404));
			res.json({ message: "No upcoming events yet!", data: [] });
		} else {
			res.json({
				message: "getUpcomingEventsByUsername",
				data: upcomingEvents,
			});
		}
	} catch (error) {
		next(new HttpError(error.message, 500));
	}
};

const updateGrade = async (req, res, next) => {
	try {
		// const { studentId, subId, mark, totalMark, tUserName, courseId } = req.body;
		// console.log(req.body);
		const arr = req.body;

		if (arr.length !== 0 && arr != null) {
			for (obj of arr) {
				console.log(
					obj.subId,
					obj.tUserName,
					obj.courseId,
					obj.totalMark,
					obj.mark
				);
				let result = await pool.query(
					"select grade_submission($1, $2, $3, $4, $5, null)",
					[obj.subId, obj.tUserName, obj.courseId, obj.totalMark, obj.mark]
				);
				const courses = result.rows[0].json_agg;
			}
		}

		res.json({ message: `Grade Updated!`, data: [] });
	} catch (error) {
		next(new HttpError(error.message, 500));
	}
};

exports.updateGrade = updateGrade;
exports.getCurrentCoursesByUsername = getCurrentCoursesByUsername;
exports.getUpcomingEventsByUsername = getUpcomingEventsByUsername;
exports.getAllCoursesByUsername = getAllCoursesByUsername;
