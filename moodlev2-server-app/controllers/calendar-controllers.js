const moment = require("moment");
const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

// const mark = [
//   { month: 8, year: 2022, dates: [1, 13, 15, 18, 31] },
//   { month: 9, year: 2022, dates: [5, 32, 2] },
//   { month: 10, year: 2022, dates: [2, 1, 10] },
// ];
// const markPerMonth = (month, year) => {
//   const markList = [];
//   mark.forEach((x) => {
//     if (x.month === month && x.year === year) {
//       x.dates.forEach((y) => {
//         // push in format DD-MM-YYYY
//         const pushDate = moment(`${y}-${month}-${year}`, "DD-MM-YYYY").format(
//           "DD-MM-YYYY"
//         );
//         if (pushDate !== "Invalid date") {
//           markList.push(pushDate);
//         }
//       });
//     }
//   });
//   return markList;
// };

// const markList = ["01-08-2022", "02-08-2022"];
function getIdEvent(event) {
  if (event == "Class") return 1;
  else if (event == "Extra Class") return 2;
  else if (event == "Assignment") return 3;
  else if (event == "Lab Test") return 4;
  else if (event == "Lab Quiz") return 5;
  else if (event == "Class Test") return 6;
  else if (event == "Online Evaluation") return 7;
}

const getAllDaysInMonth = (year, month) => {
  const dateList = [];
  const date = moment(new Date(year, month, 1));
  const currentMonth = date.month();
  while (date.month() === currentMonth) {
    dateList.push(date.clone());
    date.add(1, "d");
  }
  return dateList;
};

const getMarkDate = async (uId, uType, date) => {
  // console.log(uId, date.format("MM-DD-YYYY"));
  // console.log(typeof uId, typeof date.format("MM-DD-YYYY"));
  let result = null;
  if (uType === "Student") {
    result = await pool.query(
      "SELECT json_agg(t) FROM get_day_events($1,$2) as t",
      [uId, date.format("MM-DD-YYYY")]
    );
  } else if (uType === "Teacher") {
    // console.log("teacher mini calendar");
    result = await pool.query(
      "SELECT json_agg(t) FROM get_day_events_teacher($1,$2) as t",
      [uId, date.format("MM-DD-YYYY")]
    );
  }

  const resultNew = result.rows[0].json_agg;
  return resultNew;
};

const getMarkDateList = async (req, res, next) => {
  const markList = [];
  // console.log("getMarkDateList");
  // const uType = "Student";
  try {
    const { uId, uType, month, year } = req.body;
    // console.log("uid " + uId, "month " + month, "year " + year);
    const dateList = getAllDaysInMonth(year, month);
    // console.log(dateList);
    for (const date of dateList) {
      const result = await getMarkDate(uId, uType, date);
      // console.log(result);
      if (result) {
        for (let e of result) {
          // console.log(e.event_type);
          if (e.event_type !== "Class") {
            markList.push(moment(date).format("DD-MM-YYYY"));
            break;
          }
        }
      }
    }

    res.json({
      message: "getMarkDateList",
      markDateList: markList,
    });
  } catch (error) {
    // console.log("getMarkDateList error");
    return next(new HttpError(error.message, 500));
  }
};

// const events = [
//   {
//     date: "18-08-2022",
//     title: "CSE409 Class",
//     type: 0,
//   },
//   {
//     date: "01-08-2022",
//     title: "CSE423 CT",
//     type: 1,
//   },
// ];

const getEventListMonthView = async (req, res, next) => {
  // console.log("getEventListMonthView");
  try {
    const { uId, date, month, year, uType } = req.body;
    console.log("utype ", uType);

    let result = null;
    const givenDate = moment(new Date(year, month, date));

    if (uType === "Student") {
      result = await pool.query(
        "SELECT json_agg(t) FROM get_day_events($1,$2) as t",
        [uId, givenDate.format("MM-DD-YYYY")]
      );
    } else if (uType === "Teacher") {
      console.log("teacher month req");
      result = await pool.query(
        "SELECT json_agg(t) FROM get_day_events_teacher($1,$2) as t",
        [uId, givenDate.format("MM-DD-YYYY")]
      );
    }
    //console.log("uid " + uId, "date " + date, "month " + month, "year " + year);
    const events = result.rows[0].json_agg;
    const eventList = [];

    if (events) {
      for (const e of events) {
        e.event_id = getIdEvent(e.event_type);
        if (e.event_type !== "Class") {
          eventList.push(e);
        }
      }
    }

    // console.log(eventList);

    res.json({
      message: "getEventListMonthView",
      eventList: eventList,
    });
  } catch (error) {
    // console.log("getEventListMonthView error");
    return next(new HttpError(error.message, 500));
  }
};

exports.getMarkDateList = getMarkDateList;
exports.getEventListMonthView = getEventListMonthView;
