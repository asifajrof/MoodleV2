import React, { useState } from "react";
import Calendar from "react-calendar";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import "./monthly_calendar.css";
// import TheCalendar from "./calendar/TheCalendar";
import "./calendar/Calendar.css";

const events = [
  {
    date: "18-08-2022",
    title: "CSE409 Class",
    type: 0,
  },
  {
    date: "01-08-2022",
    title: "CSE423 CT",
    type: 1,
  },
];

const eventColors = ["#e6ffe5", "#ffe5e5"];

const MonthlyCalendar = ({ uId }) => {
  const [dateState, setDateState] = useState(new Date());
  const markDateList = [];
  const changeDate = (e) => {
    setDateState(e);
  };
  const tileContent = ({ date, view }) => {
    let tileElement = null;
    if (view === "month") {
      let eventCount = 0;
      const maxEventCount = 1;
      tileElement = (
        <div className="calendar__monthly__event__container">
          <br></br>
          <br></br>
          <br></br>
          <br></br>
          <br></br>
        </div>
      );
      // map over events and check if the date matches the date of the tile
      events.map((event) => {
        if (moment(date).format("DD-MM-YYYY") === event.date) {
          eventCount++;
          if (eventCount < maxEventCount) {
            // if the date matches, add the event to the tile
            tileElement = (
              <div
                className="calendar__monthly__event"
                style={{ backgroundColor: eventColors[event.type] }}
              >
                <div className="event__title">{event.title}</div>
                <div className="event__type">:aro kisu lekha</div>
              </div>
            );
          } else if (eventCount === maxEventCount) {
            tileElement = (
              <div
                className="calendar__monthly__event"
                style={{ backgroundColor: eventColors[event.type] }}
              >
                <div className="event__title">{event.title}</div>
                <div className="event__type">:aro kisu lekha</div>
                <AddCircleIcon />
              </div>
            );
          }
        }
      });
    } else {
      tileElement = <div></div>;
    }
    return tileElement;
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
