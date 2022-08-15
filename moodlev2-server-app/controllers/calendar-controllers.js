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

const markList = ["01-08-2022", "02-08-2022"];

// amar kotha shunte paish na????

const getMarkDateList = async (req, res, next) => {
  console.log("getMarkDateList");
  try {
    const { uId, month, year } = req.body;
    console.log("uid " + uId, "month " + month, "year " + year);
    res.json({
      message: "getMarkDateList",
      markDateList: markList,
    });
  } catch (error) {
    console.log("getMarkDateList error");
    return next(new HttpError(error.message, 500));
  }
};
exports.getMarkDateList = getMarkDateList;
