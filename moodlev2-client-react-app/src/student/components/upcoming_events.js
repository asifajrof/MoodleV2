import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { FaAngleRight } from "react-icons/fa";

import UpcomingEvent from "./upcoming_events/upcoming_event";

import "./upcoming_events.css";

const events = [
  {
    type: "Class Test",
    course_code: "CSE 405",
    time: "08:00 am",
  },
  {
    type: "Class",
    course_code: "CSE 409",
    time: "09:00 am",
  },
  {
    type: "Online",
    course_code: "CSE 408",
    time: "02:00 pm",
  },
  {
    type: "Offline",
    course_code: "CSE 410",
    time: "11:00 pm",
  },
];

const UpcomingEvents = ({ studentNo }) => {
  const [upcomingEventsList, setUpcomingEventsList] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/student/upcoming/${studentNo}`);
        const jsonData = await response.json();
        setUpcomingEventsList(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

  return (
    <>
      {upcomingEventsList.length > 0 && (
        <>
          <div className="event__container__title">Upcoming Classes/Events</div>
          <div className="event__container">
            {upcomingEventsList.map((event, index) => (
              <UpcomingEvent key={index} event={event} />
            ))}
            <div>
              <Link
                to="/timeline"
                style={{
                  width: "5rem",
                  display: "flex",
                  flexDirection: "row",
                  justifyContent: "space-between",
                  fontSize: "0.8rem",
                }}
              >
                See All <FaAngleRight />
              </Link>
            </div>
          </div>
        </>
      )}
    </>
  );
};

export default UpcomingEvents;
