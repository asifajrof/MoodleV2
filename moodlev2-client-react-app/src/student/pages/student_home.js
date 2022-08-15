import React from "react";
import MiniCalendar from "../../shared/components/minicalendar";
import RegisteredCourses from "../components/registered_courses";

import "./student_home.css";
import UpcomingEvents from "../components/upcoming_events";

const StudentHome = ({ studentNo }) => {
  return (
    <div className="home__container">
      <UpcomingEvents studentNo={studentNo} />
      <div className="home__container__divider">
        <RegisteredCourses studentNo={studentNo} />
        <MiniCalendar uId={studentNo} />
      </div>
    </div>
  );
};

export default StudentHome;
