const { CommandCompleteMessage } = require("pg-protocol/dist/messages");
const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const moment = require("moment");

const getNotificationsByUserName = async (req, res, next) => {
	// console.log("getNotificationsByUserName");
	try {
		const uId = req.params.uId;
		// console.log("uid " + uId);

		let result1 = await pool.query(
			"SELECT json_agg(t) FROM get_account_type($1) as t",
			[uId]
		);
		const user = result1.rows[0].json_agg;
		uType = user[0].type;
		// console.log(uType);
		// console.log("no notifications");
		let result2 = null;
		let notificationList = null;
		let notificationListFinal = [];
		if (uType == "Student") {
			// for course evaluation events
			result2 = await pool.query(
				"select json_agg(t) FROM get_evaluation_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;

			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.teachernamr +
						" posted a " +
						n.eventtypename +
						" on " +
						moment(n.scheduleddate).add(10, "days").calendar() +
						" " +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/event/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}

			// cancel class
			result2 = await pool.query(
				"select json_agg(t) FROM get_cancel_class_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			// console.log(notificationList);
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.teachernamr +
						" Cancelled a " +
						n.eventtypename +
						" on " +
						moment(n.scheduleddate).add(10, "days").calendar() +
						" " +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule/cancel/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}
			// console.log(notificationListFinal);
			// extra class

			result2 = await pool.query(
				"select json_agg(t) FROM get_extra_class_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;

			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.teachernamr +
						" Added a " +
						n.eventtypename +
						" on " +
						moment(n.scheduleddate).add(10, "days").calendar() +
						" " +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule/extra/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}

			// site news

			result2 = await pool.query(
				"select json_agg(t) FROM get_site_news_notifications() as t"
			);
			// console.log("here");
			notificationList = result2.rows[0].json_agg;
			// console.log(notificationList);
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.postername +
						" Posted on " +
						n.eventtypename +
						moment(n.notificationtime).format("LLL");
					let link = `/sitenews/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}

			// course post
			result2 = await pool.query(
				"select json_agg(t) FROM get_course_post_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.postername +
						" Posted on " +
						n.eventtypename +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/forum/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}

			// console.log("here");
		} else if (uType == "Teacher") {
			// for course evaluation events
			result2 = await pool.query(
				"select json_agg(t) FROM get_evaluation_notifications_teacher($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.teachernamr +
						" posted a " +
						n.eventtypename +
						" on " +
						moment(n.scheduleddate).add(10, "days").calendar() +
						" " +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/event/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}

			// cancel class
			result2 = await pool.query(
				"select json_agg(t) FROM get_cancel_class_notifications_teacher($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.teachernamr +
						" Cancelled a " +
						n.eventtypename +
						" on " +
						moment(n.scheduleddate).add(10, "days").calendar() +
						" " +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule/cancel/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}

			// extra class

			result2 = await pool.query(
				"select json_agg(t) FROM get_extra_class_notifications_teacher($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.teachernamr +
						" Added a " +
						n.eventtypename +
						" on " +
						moment(n.scheduleddate).add(10, "days").calendar() +
						" " +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule/extra/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}
			// site news

			result2 = await pool.query(
				"select json_agg(t) FROM get_site_news_notifications_official($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.postername +
						" Posted on " +
						n.eventtypename +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/sitenews/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}

			// course post
			result2 = await pool.query(
				"select json_agg(t) FROM get_course_post_notifications_teacher($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" " +
						n.postername +
						" Posted on " +
						n.eventtypename +
						moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/forum/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
					};
					notificationListFinal.push(notObj);
				}
			}
		} else if (uType == "Admin") {
			notificationList = null;
		}

		// console.log(notificationListFinal);
		if (notificationListFinal.length === 0) {
			res.json({ message: "No notifications yet!", data: [] });
		} else {
			res.json({
				message: "getNotificationsByUserName",
				data: notificationListFinal,
			});
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};
exports.getNotificationsByUserName = getNotificationsByUserName;
