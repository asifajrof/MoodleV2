import React from "react";
// import MiniCalendar from "../components/minicalendar";
import RegisteredCourses from "../components/registered_courses";
import AllRegisteredCourses from "../components/all_registered_courses";

// import "./student_home.css";
// import UpcomingEvents from "../components/upcoming_events";

const TeacherCoursePage = ({ userName, uType }) => {
  return (
    <div
      className="home__container"
      style={{ alignItems: "flex-start", padding: "2rem", width: "100%" }}
    >
      <div
        className="course__home__container__item__1"
        style={{ padding: "2rem" }}
      >
        Current Registered Courses
      </div>
      <RegisteredCourses userName={userName} />

      <div
        className="course__home__container__item__1"
        style={{ padding: "2rem" }}
      >
        All Registered Courses
      </div>
      {/* <AllRegisteredCourses userName={userName} /> */}
    </div>
  );
};

export default TeacherCoursePage;
