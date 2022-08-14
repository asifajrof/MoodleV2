import React from "react";
import Calendar from "../components/calendar";
import RegisteredCourses from "../components/registered_courses";

import "./teacher_home.css";
import UpcomingEvents from "../components/upcoming_events";

const TeacherHome = ({ userName }) => {
  return (
    <div className="home__container">
      <UpcomingEvents userName={userName} />
      <div className="home__container__divider">
        <RegisteredCourses userName={userName} />
        <Calendar userName={userName} />
      </div>
    </div>
  );
};

export default TeacherHome;
