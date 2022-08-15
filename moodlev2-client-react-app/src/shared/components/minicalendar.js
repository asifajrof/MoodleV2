import React, { useEffect, useState } from "react";
import moment from "moment";
import Calendar from "react-calendar";
// import TheCalendar from "./calendar/TheCalendar";
import "./calendar/Calendar.css";

const MiniCalendar = ({ uId }) => {
  const [dateState, setDateState] = useState(new Date());
  const [markDateList, setMarkDateList] = useState([]);
  const changeDate = (e) => {
    setDateState(e);
  };

  const month = dateState.getMonth() + 1; // aug -> 8
  const year = dateState.getFullYear(); // 2022

  // query here
  // setMarkDateList(...);
  useEffect(() => {
    const fetchData = async (calendarPostBody) => {
      // calendarPostBody -> uId, month, year
      try {
        const res = await fetch(`/api/calendar/mini`, {
          method: "POST",
          headers: {
            "Content-type": "application/json",
          },
          body: JSON.stringify(calendarPostBody),
        });
        const jsonData = await res.json();
        console.log(jsonData);
        // console.log(res.status);
        if (res.status === 200) {
          setMarkDateList(jsonData.markDateList);
        } else {
          alert(jsonData.message);
        }
      } catch (err) {
        // console.log(err);
        alert(err);
      }
    };
    fetchData({ uId, month, year });
  }, []);

  // const markDateList = markPerMonth(month, year);

  // weekend buet
  // 0 -> sunday, 1 -> monday, 2 -> tuesday, 3 -> wednesday, 4 -> thursday, 5 -> friday, 6 -> saturday

  const tileClassName = ({ date, view }) => {
    if (view === "month") {
      let returnStr = "";
      const dateMoment = moment(date);
      if (markDateList.find((x) => x === dateMoment.format("DD-MM-YYYY"))) {
        returnStr += " react-calendar__month-view__highlight";
      }
      const day = dateMoment.day();
      if (day === 4) {
        // thursday
        returnStr += " react-calendar__month-view__buet__weekend";
      } else if (day === 5) {
        // friday
        returnStr += " react-calendar__month-view__buet__weekend";
      }
      return returnStr;
    }
  };

  return (
    <div className="calendar__container">
      <Calendar
        calendarType="Arabic"
        value={dateState}
        onChange={changeDate}
        tileClassName={tileClassName}
      />
    </div>
  );
};

export default MiniCalendar;
