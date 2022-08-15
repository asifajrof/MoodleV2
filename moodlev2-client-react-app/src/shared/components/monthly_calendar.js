import React, { useState } from "react";
import Calendar from "react-calendar";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import "./monthly_calendar.css";

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
  const changeDate = (e) => {
    setDateState(e);
  };
  const tileContent = ({ date, view }) => {
    let eventCount = 0;
    const maxEventCount = 1;
    let tileElement = (
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
    return tileElement;
  };
  return (
    <div className="calendar__monthly__container">
      <Calendar
        calendarType="Arabic"
        value={dateState}
        // showWeekNumbers
        onChange={changeDate}
        tileContent={tileContent}
      />
    </div>
  );
};

export default MonthlyCalendar;
