import React from "react";

import "./upcoming_event.css";

const UpcomingEvent = ({ event }) => {
  // console.log("upcoming event");
  // console.log(event);
  return (
    <div className="event__container__item">
      <div className="event__container__item__1">
        <div>{event.event_type}</div>
      </div>
      <div className="event__container__item__2">
        <div>
          {event.dept_shortname} {event.course_code}
        </div>
        <div>{event.lookup_time}</div>
      </div>
    </div>
  );
};

export default UpcomingEvent;
