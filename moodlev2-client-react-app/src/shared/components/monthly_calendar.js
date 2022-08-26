import React, { useState, useEffect } from "react";
import Calendar from "react-calendar";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import "./monthly_calendar.css";
import "./calendar/Calendar.css";
import TileContent from "./calendar/TileContent";

const MonthlyCalendar = ({ uId, uType }) => {
  const [dateState, setDateState] = useState(new Date());
  const [markDateList, setMarkDateList] = useState([]);
  const changeDate = (e) => {
    setDateState(e);
  };
  const month = dateState.getMonth(); // aug -> 8
  const year = dateState.getFullYear(); // 2022

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
        // console.log(jsonData);
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
    fetchData({ uId, uType, month, year });
  }, [dateState]);

  const tileContent = ({ date, view }) => {
    return (
      <div className="calendar__monthly__event__container">
        <TileContent uId={uId} date={date} view={view} uType={uType} />
      </div>
    );
  };

  const tileClassName = ({ date, view }) => {
    if (view === "month") {
      let returnStr = "";
      const dateMoment = moment(date);
      if (markDateList.find((x) => x === dateMoment.format("DD-MM-YYYY"))) {
        returnStr += " react-calendar__month-view__highlight__box";
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
    <div className="calendar__monthly__container">
      <Calendar
        calendarType="Arabic"
        value={dateState}
        onChange={changeDate}
        tileClassName={tileClassName}
        tileContent={tileContent}
      />
    </div>
  );
};

export default MonthlyCalendar;
