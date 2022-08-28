const { CommandCompleteMessage } = require("pg-protocol/dist/messages");
const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const moment = require("moment");
const e = require("express");

const getRescheduleEvents = async (req, res, next) => {
	try {
		const { courseId, userName } = req.body;
		// const uId = req.params.uId;
		console.log("GET api/reschedule/view");
		let reschList = [];
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_extra_class_teacher($1, $2) as t",
			[userName, courseId]
		);
		// console.log(result.rows[0].json_agg);
		const extra = result.rows[0].json_agg;
		if (extra != null) {
			for (c of extra) {
				const obj = {
					eventType: "Extra Class",
					eventStartTime: c.start_time,
					eventEndTime: c.end_time,
					eventSectionName: c.sectionname,
					eventTeacherName: c.teachername,
				};
				reschList.push(obj);
			}
		}

		result = await pool.query(
			"SELECT json_agg(t) FROM get_cancel_class_teacher($1, $2) as t",
			[userName, courseId]
		);
		// console.log(result.rows[0].json_agg);

		const cancel = result.rows[0].json_agg;
		// console.log(result.rows[0].json_agg);

		if (cancel != null) {
			// console.log(cancel);
			for (c of cancel) {
				// console.log("==========================");
				const obj = {
					eventType: "Cancelled Class",
					eventStartTime: c.start_time,
					eventEndTime: c.end_time,
					eventSectionName: c.sectionname,
					eventTeacherName: c.teachername,
				};
				reschList.push(obj);
			}
		}
		// console.log(reschList);

		res.json({ message: "getRescheduleEvents", data: reschList });
	} catch (err) {
		return next(new HttpError(err.message, 500));
	}
};

const addCancelClass = async (req, res, next) => {
	try {
		const { userName, reschTime } = req.body;
		console.log("POST api/reschedule/add/cancel");
		const result = await pool.query("SELECT cancel_class($1, $2, $3)", [
			userName,
			moment(reschTime).format("YYYY-MM-DD"),
			moment(reschTime).format("HH:mm"),
		]);
		res.json({
			message: "addCancelClass",
			data: [],
		});
	} catch (err) {
		return next(new HttpError(err.message, 500));
	}
};
exports.getRescheduleEvents = getRescheduleEvents;
exports.addCancelClass = addCancelClass;
