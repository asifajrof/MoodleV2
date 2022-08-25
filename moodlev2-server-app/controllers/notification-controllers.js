const { CommandCompleteMessage } = require("pg-protocol/dist/messages");
const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

const getNotificationsByUserName = async (req, res, next) => {
	// console.log("getNotificationsByUserName");
	try {
		const uId = req.params.uId;
		console.log("uid " + uId);

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
		if (uType == "Student") {
			result2 = await pool.query(
				"select json_agg(t) FROM get_evaluation_notifications($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
		} else if (uType == "Teacher") {
			result2 = await pool.query(
				"select json_agg(t) FROM get_evaluation_notifications_teacher($1) as t",
				[uId]
			);
			notificationList = result2.rows[0].json_agg;
		} else if (uType == "Admin") {
			notificationList = null;
		}

		// console.log(result2);

		// console.log(notificationList);
		// const notificationList = [
		//   {
		//     id: 1,
		//     item: "notification item 1",
		//   },
		//   {
		//     id: 2,
		//     item: "notification item 2",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 1,
		//     item: "notification item 1",
		//   },
		//   {
		//     id: 2,
		//     item: "notification item 2",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		//   {
		//     id: 3,
		//     item: "notification item 3",
		//   },
		// ];
		if (!notificationList) {
			res.json({ message: "No notifications yet!", data: [] });
		} else {
			res.json({
				message: "getNotificationsByUserName",
				data: notificationList,
			});
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};
exports.getNotificationsByUserName = getNotificationsByUserName;
