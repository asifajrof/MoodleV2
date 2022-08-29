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

const addExtraClass = async (req, res, next) => {
  try {
    const { eventSectionList, eventTime, userName } = req.body;

    const eventTimeMoment = moment(eventTime);
    const givenTime = eventTimeMoment.format("YYYY-MM-DD HH:mm:ssZZ");
    // console.log(givenTime);
    const givenTimePlusOneHour = eventTimeMoment
      .add(1, "hours")
      .format("YYYY-MM-DD HH:mm:ssZZ");
    // const currentTime = moment().format("YYYY-MM-DD HH:mm:ssZZ");
    // console.log(currentTime);

    for (sec of eventSectionList) {
      let result = await pool.query(
        "select json_agg(t) FROM add_extra_class_request($1,$2,$3,$4) as t",
        [sec, userName, givenTime, givenTimePlusOneHour]
      );

      // const evaluationId = result.rows[0].json_agg;
      // console.log(result);
    }

    res.json({ message: "new extra class requested", data: [] });
  } catch (err) {
    return next(new HttpError(err.message, 500));
  }
};

const getExtraClassInfo = async (req, res, next) => {
  try {
    const { studentId, eventId } = req.body;
    console.log("GET api/reschedule/info/extra");
    let result = await pool.query(
      "SELECT json_agg(t) FROM get_extra_class_request_information($1, $2) as t",
      [studentId, eventId]
    );
    // console.log(result.rows[0].json_agg);
    const extra = result.rows[0].json_agg[0];
    // console.log("extra", extra);
    if (extra != null) {
      const obj = {
        userName: extra.teachernamr,
        eventStartTime: moment(extra.start_time).format("LLL"),
        courseName: extra.dept_shortname + " " + extra.course_code,
      };

      res.json({ message: "getExtraClassInfo", data: obj });
    } else {
      res.json({ message: "getExtraClassInfo", data: {} });
    }
  } catch (err) {
    return next(new HttpError(err.message, 500));
  }
};

const getExtraClassRescheduleInfo = async (req, res, next) => {
  try {
    const { userName, eventId } = req.body;
    console.log("GET api/reschedule/info/extra");
    let result = await pool.query(
      "SELECT json_agg(t) FROM get_extra_class_reschedule_information($1, $2) as t",
      [userName, eventId]
    );
    // console.log(result.rows[0].json_agg);
    const extra = result.rows[0].json_agg[0];
    console.log("extra", extra);
    if (extra != null) {
      const obj = {
        userName: extra.teachernamr,
        eventStartTime: moment(extra.start_time).format("LLL"),
        courseName: extra.dept_shortname + " " + extra.course_code,
        secName: extra.secname,
        secNo: extra.secno,
      };

      res.json({ message: "getExtraClassInfo", data: obj });
    } else {
      res.json({ message: "getExtraClassInfo", data: {} });
    }
  } catch (err) {
    return next(new HttpError(err.message, 500));
  }
};

const rescheduleRequest = async (req, res, next) => {
  try {
    const eventId = req.params.eventId;
    const result = await pool.query("SELECT reschedule_request($1)", [eventId]);
    res.json({ message: "rescheduleRequest", data: [] });
  } catch (err) {
    return next(new HttpError(err.message, 500));
  }
};
const confirmExtraClass = async (req, res, next) => {
  try {
    const eventId = req.params.eventId;

    const result = await pool.query("SELECT confirm_request($1)", [eventId]);
    res.json({ message: "confirmExtraClass", data: [] });
  } catch (err) {
    return next(new HttpError(err.message, 500));
  }
};

exports.getExtraClassRescheduleInfo = getExtraClassRescheduleInfo;
exports.rescheduleRequest = rescheduleRequest;
exports.confirmExtraClass = confirmExtraClass;
exports.getExtraClassInfo = getExtraClassInfo;
exports.getRescheduleEvents = getRescheduleEvents;
exports.addCancelClass = addCancelClass;
exports.addExtraClass = addExtraClass;
