import React from "react";
import Calendar from "../components/calendar";
import RegisteredCourses from "../components/registered_courses";

import "./student_home.css";
import UpcomingEvents from "../components/upcoming_events";

const StudentHome = ({ studentNo }) => {
  return (
    <div className="home__container">
      <UpcomingEvents studentNo={studentNo} />
      <div className="home__container__divider">
        <RegisteredCourses studentNo={studentNo} />
        <Calendar studentNo={studentNo} />
      </div>
    </div>
  );
};

export default StudentHome;
