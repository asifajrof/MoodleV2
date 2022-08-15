import React from "react";
import MiniCalendar from "../../shared/components/minicalendar";
import RegisteredCourses from "../components/registered_courses";

// import "./teacher_home.css";
import UpcomingEvents from "../components/upcoming_events";

const TeacherHome = ({ userName, uType }) => {
  return (
    <div className="home__container">
      <UpcomingEvents userName={userName} />
      <div className="home__container__divider">
        <RegisteredCourses userName={userName} />
        <MiniCalendar uId={userName} uType={uType} />
      </div>
    </div>
  );
};

export default TeacherHome;
