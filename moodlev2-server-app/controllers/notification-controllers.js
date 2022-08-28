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
			//---------------------------------------------------eval noti-------------------------------------------------------------------
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
						" : " +
						n.teachernamr +
						" posted a " +
						n.eventtypename +
						" on " +
						// moment(n.scheduleddate).calendar();
						moment(n.scheduleddate).format("LLL");
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/event/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------------cancel class noti------------------------------------------------------------
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
						" : " +
						n.teachernamr +
						" Cancelled a class on " +
						// moment(n.scheduleddate).calendar();
						moment(n.scheduleddate).format("LLL");
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			// console.log(notificationListFinal);
			//-----------------------------------------------------extra class noti-----------------------------------------------------------------
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
						" : " +
						n.teachernamr +
						" Added a " +
						n.eventtypename +
						" on " +
						// moment(n.scheduleddate).calendar();
						moment(n.scheduleddate).format("LLL");
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//-----------------------------------------------------------site news noti-----------------------------------------------------------
			// site news

			result2 = await pool.query(
				"select json_agg(t) FROM get_site_news_notifications() as t"
			);
			// console.log("here");
			notificationList = result2.rows[0].json_agg;
			// console.log(notificationList);
			if (notificationList != null) {
				for (n of notificationList) {
					let msg = n.postername + " Posted on " + n.eventtypename;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/sitenews/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//------------------------------------------------------------course post noti----------------------------------------------------------
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
						" : " +
						n.postername +
						" Posted on " +
						n.eventtypename;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/forum/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//------------------------------------------------------------get grade noti----------------------------------------------------------
			// grading

			result2 = await pool.query(
				"select json_agg(t) FROM get_grading_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.eventtypename +
						" by " +
						n.teachernamr;

					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/grades`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//--------------------------------------------------------xtra class req noti----------------------------------------------------------
			//extra class req noti

			result2 = await pool.query(
				"select json_agg(t) FROM get_extra_class_request_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.eventtypename +
						" by " +
						n.teachernamr +
						" on " +
						moment(n.scheduleddate).format("LLL");

					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------student s resource---------------------------------------------
			// student s resource
			result2 = await pool.query(
				"select json_agg(t) FROM get_sresource_notifications_student($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.eventtypename +
						"  " +
						n.uploadername +
						" on " +
						n.scheduleddate;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/resources`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------studebt t resource---------------------------------------------
			result2 = await pool.query(
				"select json_agg(t) FROM get_tresource_notifications_student($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.eventtypename +
						"  " +
						n.uploadername +
						" on " +
						n.scheduleddate;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/resources`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//-----------------------------------------------------------course announcement noti-----------------------------------------------------------

			//=============================================teacher=======================================================================
			// console.log("here");
		} else if (uType == "Teacher") {
			// for course evaluation events
			//-------------------------------------------------eval event teacher---------------------------------------------------------------------
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
						" : " +
						n.teachernamr +
						" posted a " +
						n.eventtypename +
						" on " +
						// moment(n.scheduleddate).calendar();
						moment(n.scheduleddate).format("LLL");
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/event/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//-------------------------------------------------cancel clss teacher---------------------------------------------------------------------
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
						" : " +
						n.teachernamr +
						" Cancelled a class on " +
						// moment(n.scheduleddate).calendar();
						moment(n.scheduleddate).format("LLL");
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//---------------------------------------------------extra class teacher-------------------------------------------------------------------
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
						" : " +
						n.teachernamr +
						" Added a " +
						n.eventtypename +
						" on " +
						// moment(n.scheduleddate).calendar();
						moment(n.scheduleddate).format("LLL");
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------site news teacher------------------------------------------------------------------
			// site news

			result2 = await pool.query(
				"select json_agg(t) FROM get_site_news_notifications_official($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg = n.postername + " Posted on " + n.eventtypename;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/sitenews/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------course post teacher------------------------------------------------------------------
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
						" : " +
						n.postername +
						" Posted on " +
						n.eventtypename;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/forum/${n.eventno}`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------extra_class_reschedule_noti---------------------------------------------
			// extra class reschedule
			result2 = await pool.query(
				"select json_agg(t) FROM get_extra_class_reschedule_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.crname +
						" has requested to reschedule the extra class requested on " +
						n.scheduleddate;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/rescedule`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------extra_class_confitm noti---------------------------------------------
			// extra class confirm
			result2 = await pool.query(
				"select json_agg(t) FROM get_extra_class_confirm_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.crname +
						" confirmed the extra class requested on " +
						n.scheduleddate;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/reschedule`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------teacher s resource---------------------------------------------
			// teacher s resource
			result2 = await pool.query(
				"select json_agg(t) FROM get_sresource_notifications_teacher($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.eventtypename +
						"  " +
						n.uploadername +
						" on " +
						n.scheduleddate;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/resources`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//----------------------------------------------------teacher t resource---------------------------------------------
			result2 = await pool.query(
				"select json_agg(t) FROM get_tresource_notifications_teacher($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
			if (notificationList != null) {
				for (n of notificationList) {
					let msg =
						n.dept_shortname +
						n.course_code +
						" : " +
						n.eventtypename +
						"  " +
						n.uploadername +
						" on " +
						n.scheduleddate;
					let nTime = moment(n.notificationtime).format("LLL");
					let link = `/course/${n.courseid}/resources`;

					const notObj = {
						notificationMsg: msg,
						notificationLink: link,
						notificationTime: nTime,
					};
					notificationListFinal.push(notObj);
				}
			}
			//===========================================================end==================================================
		} else if (uType == "Admin") {
			notificationList = null;
		}

		// console.log(notificationListFinal);
		if (notificationListFinal.length === 0) {
			res.json({ message: "No notifications yet!", data: [] });
		} else {
			notificationListFinal.sort(function (a, b) {
				return (
					moment(b.notificationTime, "LLL") - moment(a.notificationTime, "LLL")
				);
			});
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
