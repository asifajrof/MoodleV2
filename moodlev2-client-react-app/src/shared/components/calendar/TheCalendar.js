import React, { useState } from "react";
import Calendar from "react-calendar";
import moment from "moment";
import PropTypes from "prop-types";
import "./Calendar.css";

const TheCalendar = ({ uId, markDateList, tileContent }) => {
  const [dateState, setDateState] = useState(new Date());

  const changeDate = (e) => {
    setDateState(e);
  };
  // 0 -> sunday, 1 -> monday, 2 -> tuesday, 3 -> wednesday, 4 -> thursday, 5 -> friday, 6 -> saturday
  const getDatesOfDay = (day) => {
    const dates = [];
    const date = moment(dateState);
    const firstDate = date.clone().startOf("month");
    const month = firstDate.month();
    while (firstDate.month() === month) {
      if (firstDate.day() === day) {
        dates.push(firstDate.clone());
        firstDate.add(7, "d");
      } else {
        firstDate.add(1, "d");
      }
    }
    return dates;
  };
  const allThursdays = getDatesOfDay(4);
  const allFridays = getDatesOfDay(5);

  const tileClassName = ({ date, view }) => {
    if (view === "month") {
      if (markDateList.find((x) => x === moment(date).format("DD-MM-YYYY"))) {
        return "react-calendar__month-view__highlight";
      }
      if (allThursdays.find((x) => x.isSame(date, "day"))) {
        return "react-calendar__month-view__buet__weekend";
      }
      if (allFridays.find((x) => x.isSame(date, "day"))) {
        return "react-calendar__month-view__buet__weekend";
      }
    }
  };

  return (
    <div className="calendar__container">
      <Calendar
        calendarType="Arabic"
        value={dateState}
        // showWeekNumbers
        onChange={changeDate}
        tileClassName={tileClassName}
        tileContent={tileContent}
      />
    </div>
  );
};

export default TheCalendar;

// proptypes
TheCalendar.propTypes = {
  uId: PropTypes.number.isRequired,
  markDateList: PropTypes.array,
  tileContent: PropTypes.func,
};

// default props
TheCalendar.defaultProps = {
  uId: 0,
  markDateList: [],
  tileContent: () => {},
};
