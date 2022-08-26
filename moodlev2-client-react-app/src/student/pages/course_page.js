import React, { useState } from "react";
import { Button, ToggleButton, ToggleButtonGroup } from "@mui/material";
// import MiniCalendar from "../components/minicalendar";
import RegisteredCourses from "../components/registered_courses";
import AllRegisteredCourses from "../components/all_registered_courses";

// import "./student_home.css";
// import UpcomingEvents from "../components/upcoming_events";

const StudentCoursePage = ({ studentNo, uType }) => {
  const [view, setView] = useState("current");
  const handleToggleChange = (event, newView) => {
    setView(newView);
  };
  return (
    <div
      className="home__container"
      style={{ alignItems: "flex-start", padding: "2rem", width: "100%" }}
    >
      <div className="timeline__calendar__button__container">
        <div></div>
        <ToggleButtonGroup
          color="primary"
          value={view}
          exclusive
          onChange={handleToggleChange}
        >
          <ToggleButton value="current">Current</ToggleButton>
          <ToggleButton value="all">All</ToggleButton>
        </ToggleButtonGroup>
        <div></div>
      </div>
      {view === "current" && (
        <>
          <div
            className="course__home__container__item__1"
            style={{ padding: "2rem" }}
          >
            Current Registered Courses
          </div>
          <RegisteredCourses studentNo={studentNo} />
        </>
      )}
      {view === "all" && (
        <>
          <div
            className="course__home__container__item__1"
            style={{ padding: "2rem" }}
          >
            All Registered Courses
          </div>
          <AllRegisteredCourses studentNo={studentNo} />
        </>
      )}
    </div>
  );
};

export default StudentCoursePage;
