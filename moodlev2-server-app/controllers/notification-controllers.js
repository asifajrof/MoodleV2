const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

const getNotificationsByUserName = async (req, res, next) => {
  // console.log("getNotificationsByUserName");
  try {
    const uId = req.params.uId;
    // console.log("uid " + uId);
    // let result = await pool.query(
    //   "SELECT json_agg(t) FROM get_course_topics($1) as t",
    //   [uId]
    // );
    // const notificationList = result.rows[0].json_agg;
    // console.log()
    const notificationList = [
      {
        id: 1,
        item: "notification item 1",
      },
      {
        id: 2,
        item: "notification item 2",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 1,
        item: "notification item 1",
      },
      {
        id: 2,
        item: "notification item 2",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
      {
        id: 3,
        item: "notification item 3",
      },
    ];
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
