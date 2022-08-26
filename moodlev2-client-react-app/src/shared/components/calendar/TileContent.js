import React, { useEffect, useState } from "react";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import ReactDOM from "react-dom";
import { Link } from "react-router-dom";
const eventColors = [
  "#e6ffe5",
  "#ffe5e5",
  "#e5ffe5",
  "#e5e5ff",
  "#fae5e5",
  "#e5f5e5",
  "#e5e5e5",
];
const TileContent = ({ uId, date, view, uType }) => {
  const maxEventCount = 3;
  const [eventList, setEventList] = useState([]);
  //   const [eventList, setEventList] = useState(events);

  const dateMoment = moment(date);
  const dateOnly = dateMoment.date();
  const monthOnly = dateMoment.month();
  const yearOnly = dateMoment.year();
  //   console.log("date " + dateOnly, "month " + monthOnly, "year " + yearOnly);

  useEffect(() => {
    const fetchData = async (calendarPostBody) => {
      // calendarPostBody -> uId, date, month, year
      try {
        const res = await fetch(`/api/calendar/month`, {
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
          setEventList(jsonData.eventList);
        } else {
          //   alert(jsonData.message);
          //   console.log(jsonData.message);
        }
      } catch (err) {
        console.log(err);
        // alert(err);
      }
    };
    fetchData({ uId, date: dateOnly, month: monthOnly, year: yearOnly, uType });
  }, []);

  const tileElement = [];
  const eventListLength = eventList.length;
  if (view === "month") {
    // console.log(eventList);
    let eventCount = 0;
    const brCount = maxEventCount - eventListLength;

    for (let i = 0; i < brCount; i++) {
      eventCount++;
      tileElement.push(
        <div key={eventCount}>
          <br />
        </div>
      );
    }
    const eventCountAfterBr = eventCount;
    for (let i = eventCountAfterBr; i < maxEventCount; i++) {
      eventCount++;
      tileElement.push(
        // <Link to={`/course/${eventList[i - eventCountAfterBr]}`}>
        <div
          className="calendar__monthly__event"
          style={{
            backgroundColor:
              eventColors[eventList[i - eventCountAfterBr].event_id - 1],
          }}
          key={eventCount}
        >
          <div className="event__title">
            {eventList[i - eventCountAfterBr].dept_shortname}{" "}
            {eventList[i - eventCountAfterBr].course_code}{" "}
            {eventList[i - eventCountAfterBr].event_type}
          </div>

          {/* <div className="event__type"> </div> */}
        </div>
        // </Link>
      );
    }
    eventCount++;
    if (eventListLength > maxEventCount) {
      tileElement.push(
        <div key={eventCount}>
          <AddCircleIcon />
        </div>
      );
    } else {
      tileElement.push(
        <div key={eventCount}>
          <br />
        </div>
      );
    }
  } else {
    let eventCount = 0;
    for (let i = 0; i < maxEventCount + 1; i++) {
      eventCount++;
      tileElement.push(
        <div key={eventCount}>
          <br />
        </div>
      );
    }
  }

  // list of hours
  const hours = [];
  for (let i = 0; i < 24; i++) {
    // hh:mm format
    hours.push(moment(`${i}:00`, "h:mm a").format("h:mm a"));
  }
  // console.log(hours);
  // return tileElement;
  return (
    <>
      {view === "month" ? (
        <div className="calendar__monthly__inside__content">
          {hours.map((hour, index) => {
            return (
              <div
                key={index}
                className="calendar__monthly__inside__content__line"
              >
                {/* <div style={{ background: "#000" }}>event details</div> */}
                <div> </div>
                <div className="calendar__monthly__hourstamp">{hour}</div>
              </div>
            );
          })}
        </div>
      ) : (
        <></>
      )}
    </>
  );
};

export default TileContent;
