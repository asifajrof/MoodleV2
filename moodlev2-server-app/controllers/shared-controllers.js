const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const moment = require("moment");

const getCourseById = async (req, res, next) => {
	try {
		const courseId = req.params.course_id;
		let result = await pool.query("SELECT * FROM all_courses WHERE _id = $1", [
			courseId,
		]);
		const course = result.rows[0];
		// console.log(course);
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

const getEventDetails = async (req, res, next) => {
	try {
		const eventId = req.params.eventId;
		const uName = req.params.uId;

		let result1 = await pool.query(
			"SELECT json_agg(t) FROM get_account_type($1) as t",
			[uName]
		);
		const user = result1.rows[0].json_agg;
		const type = user[0].type;
		// console.log(eventId);
		let result = await pool.query(
			"SELECT json_agg(t) FROM  get_event_description($1) as t",
			[eventId]
		);

		const eventDetails = result.rows[0].json_agg;
		const id = eventDetails[0].eventid;
		const event_description = eventDetails[0].description;
		const event_type = eventDetails[0].eventtype;
		let endtime = eventDetails[0].subtime;
		let nowDate = new Date();
		// console.log(date_ob);
		nowDate = moment(nowDate);
		endtime = moment(endtime);
		// console.log(endtime, nowDate);
		const checkCompleted = endtime.isBefore(nowDate);
		// console.log(checkCompleted);

		let completed = false;
		if (checkCompleted) {
			completed = true;
		}

		let subDetails = null;
		if (type === "Student") {
			let result2 = await pool.query(
				"SELECT json_agg(t) FROM  get_submission_info($1, $2) as t",
				[eventId, uName]
			);

			subDetails = result2.rows[0].json_agg;
		}

		let submitted = false;
		let submission_time = 0;

		// console.log(subDetails);

		if (subDetails != null) {
			submitted = true;
			submission_time = subDetails[0].subtime;
			submission_time = moment(submission_time);
			// console.log("submitted true");
		}

		// console.log("endtime", endtime.format("YYYY-MM-DD HH:mm:ss"));
		// console.log("nowDate", nowDate.format("YYYY-MM-DD HH:mm:ss"));
		// console.log(
		//   "submission_time",
		//   submission_time.format("YYYY-MM-DD HH:mm:ss")
		// );
		const eventObj = {
			id: id,
			event_description: event_description,
			event_type: event_type,
			event_date: endtime,
			completed: completed,
			submitted: submitted,
			fileID: submitted ? subDetails[0].subid : null,
			remaining_time: completed
				? submitted
					? moment.duration(endtime - submission_time).humanize()
					: moment.duration(endtime - nowDate).humanize()
				: moment.duration(endtime - nowDate).humanize(),
		};

		// console.log(eventObj);

		if (!eventDetails) {
			res.json({ message: "Error retriving eventdetails", data: [] });
		} else {
			res.json({ message: "getCourseEventsById", data: eventObj });
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const getCourseEventsTeacher = async (req, res, next) => {
	try {
		const { userName, courseId } = req.body;
		let result = await pool.query(
			"SELECT json_agg(t) FROM  get_course_evaluations_teacher($1, $2) as t",
			[userName, courseId]
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
		// console.log(
		//   topicName,
		//   topicDescription,
		//   teacherUserName.userName,
		//   courseId
		// );
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

const addNewCourseEvent = async (req, res, next) => {
	try {
		const {
			courseId,
			eventDescription,
			eventFullMarks,
			eventSectionList,
			eventTime,
			eventType,
			teacherUserName,
		} = req.body;

		const eventTimeMoment = moment(eventTime);
		const givenTime = eventTimeMoment.format("YYYY-MM-DD HH:mm:ssZZ");
		// console.log(givenTime);
		const givenTimePlusOneHour = eventTimeMoment
			.add(1, "hours")
			.format("YYYY-MM-DD HH:mm:ssZZ");
		const currentTime = moment().format("YYYY-MM-DD HH:mm:ssZZ");
		console.log(currentTime);

		for (sec of eventSectionList) {
			let start = null;
			let end = null;
			if (eventType !== 5) {
				start = givenTime;
				end = givenTimePlusOneHour;
			} else {
				start = currentTime;
				end = givenTime;
			}
			console.log(
				eventType,
				sec,
				teacherUserName,
				null,
				start,
				end,
				eventFullMarks,
				eventDescription,
				null
			);
			let result = await pool.query(
				"select json_agg(t) FROM add_evaluation($1,$2,$3,$4,$5,$6,$7, $8, $9) as t",
				[
					eventType,
					sec,
					teacherUserName,
					null,
					start,
					end,
					eventFullMarks,
					eventDescription,
					null,
				]
			);

			// const evaluationId = result.rows[0].json_agg;
			// console.log(result);
		}

		res.json({ message: "new course event added", data: [] });
	} catch (err) {
		console.log(err);
		return next(new HttpError(err.message, 500));
	}
};

const getSubmissions = async (req, res, next) => {
	try {
		const courseId = req.params.courseId;
		const eventId = req.params.eventId;

		let result = await pool.query(
			"SELECT json_agg(t) FROM  get_submissions($1) as t",
			[eventId]
		);
		const submissions = result.rows[0].json_agg;
		let submissionList = [];
		if (submissions != null) {
			for (sub of submissions) {
				const submittedInfo = {
					studentID: sub.studentid,
					fileID: sub.subid,
				};
				submissionList.push(submittedInfo);
			}
		}
		// console.log()
		if (submissionList.length === 0) {
			res.json({ message: "No submissions yet!", data: [] });
		} else {
			res.json({ message: "getSubmissions", data: submissionList });
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const teacherGradeList = async (req, res, next) => {
	try {
		const eventId = req.params.eventId;

		let result = await pool.query(
			"SELECT json_agg(t) FROM  get_submissions($1) as t",
			[eventId]
		);
		const submissions = result.rows[0].json_agg;
		let submissionList = [];
		if (submissions != null) {
			for (sub of submissions) {
				const submittedInfo = {
					studentID: sub.studentid,
					subID: sub.subid,
					mark: sub.obtainedmarks,
					totalMark: sub.totalmarks,
				};
				submissionList.push(submittedInfo);
			}
		}
		// console.log()
		if (submissionList.length === 0) {
			res.json({ message: "No submissions yet!", data: [] });
		} else {
			res.json({ message: "getSubmissions", data: submissionList });
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

exports.teacherGradeList = teacherGradeList;
exports.addNewCourseEvent = addNewCourseEvent;
exports.getEventDetails = getEventDetails;
exports.getCourseById = getCourseById;
exports.getCourseTopicsById = getCourseTopicsById;
exports.getCourseEvents = getCourseEvents;
exports.addNewCourseTopic = addNewCourseTopic;
exports.getCourseEventsTeacher = getCourseEventsTeacher;
exports.getSubmissions = getSubmissions;
