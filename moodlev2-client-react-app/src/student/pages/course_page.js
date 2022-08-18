import React from "react";
// import MiniCalendar from "../components/minicalendar";
import RegisteredCourses from "../components/registered_courses";
import AllRegisteredCourses from "../components/all_registered_courses";

// import "./student_home.css";
// import UpcomingEvents from "../components/upcoming_events";

const StudentCoursePage = ({ studentNo, uType }) => {
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
      <RegisteredCourses studentNo={studentNo} />

      <div
        className="course__home__container__item__1"
        style={{ padding: "2rem" }}
      >
        All Registered Courses
      </div>
      {/* <AllRegisteredCourses studentNo={studentNo} /> */}
    </div>
  );
};

export default StudentCoursePage;
