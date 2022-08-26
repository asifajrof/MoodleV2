import React, { useState } from "react";
import { ToggleButton, ToggleButtonGroup } from "@mui/material";
// import "./student_timeline.css";
import "./AdminCourseDetail.css";
import CourseTeachers from "./course_detail/CourseTeachers";
import CourseStudents from "./course_detail/CourseStudents";
import CourseCRs from "./course_detail/CourseCRs";

const AdminCourseDetail = ({ adminNo, courseId }) => {
  const [view, setView] = useState("teachers");
  const handleToggleChange = (event, newView) => {
    setView(newView);
  };
  return (
    <div className="timeline__calendar__container">
      <div className="timeline__calendar__button__container">
        <div></div>
        <ToggleButtonGroup
          color="primary"
          value={view}
          exclusive
          onChange={handleToggleChange}
        >
          <ToggleButton value="teachers">Teachers</ToggleButton>
          <ToggleButton value="students">Students</ToggleButton>
          <ToggleButton value="crs">CRs</ToggleButton>
        </ToggleButtonGroup>
        <div></div>
      </div>

      {view === "teachers" && (
        <div className="course__detail__teachers">
          <CourseTeachers adminNo={adminNo} courseId={courseId} />
        </div>
      )}
      {view === "students" && (
        <div className="course__detail__students">
          <CourseStudents adminNo={adminNo} courseId={courseId} />
        </div>
      )}
      {view === "crs" && (
        <div className="course__detail__students">
          <CourseCRs adminNo={adminNo} courseId={courseId} />
        </div>
      )}
    </div>
  );
};

export default AdminCourseDetail;
