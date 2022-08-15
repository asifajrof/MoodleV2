import React, { useState } from "react";
import Calendar from "react-calendar";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import "./monthly_calendar.css";
import "./calendar/Calendar.css";
import TileContent from "./calendar/TileContent";

const MonthlyCalendar = ({ uId, uType }) => {
  const [dateState, setDateState] = useState(new Date());
  const markDateList = [];
  const changeDate = (e) => {
    setDateState(e);
  };
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
