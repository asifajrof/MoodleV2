import React, { useEffect, useState } from "react";
import moment from "moment";
import AddCircleIcon from "@mui/icons-material/AddCircle";
import ReactDOM from "react-dom";
import { Link } from "react-router-dom";
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
    // tileElement = (
    //   <div className="calendar__monthly__event__container">
    //     <br></br>
    //     <br></br>
    //     <br></br>
    //     <br></br>
    //     <br></br>
    //   </div>
    // );
    // map over eventList and check if the date matches the date of the tile
    //     eventList.map((event) => {
    //       if (eventCount < maxEventCount) {
    //         // if the date matches, add the event to the tile
    //         tileElement = (
    //           <div
    //             className="calendar__monthly__event"
    //             style={{ backgroundColor: eventColors[event.type] }}
    //           >
    //             <div className="event__title">{event.title}</div>
    //             <div className="event__type">:aro kisu lekha</div>
    //           </div>
    //         );
    //       } else if (eventCount === maxEventCount) {
    //         tileElement = (
    //           <div
    //             className="calendar__monthly__event"
    //             style={{ backgroundColor: eventColors[event.type] }}
    //           >
    //             <div className="event__title">{event.title}</div>
    //             <div className="event__type">:aro kisu lekha</div>
    //             <AddCircleIcon />
    //           </div>
    //         );
    //       }
    //     });
    //   } else {
    //     // not month
    //     tileElement = <></>;
    //   }
    //   return tileElement;

    //   return (
    //     <>
    //       <br></br>
    //       <br></br>
    //       <br></br>
    //       <br></br>
    //       <br></br>
    //     </>
    //   );
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
  return tileElement;
};

export default TileContent;
