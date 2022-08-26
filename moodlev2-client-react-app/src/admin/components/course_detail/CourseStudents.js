import React, { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import CourseStudentTable from "./CourseStudentTable";
// import './course_home.css';

const CourseStudents = ({ adminNo, courseId }) => {
  return (
    <div className="home__container">
      <div className="home__container__divider">
        <div className="course__container" style={{ width: "100%" }}>
          <div className="course__container__add">
            <Link to={`/course/${courseId}/teachers/add`}>
              <Button variant="contained">
                Add
                <AddIcon />
              </Button>
            </Link>
          </div>
          <div className="course__home__container__item__1">Students</div>
          <CourseStudentTable adminNo={adminNo} courseId={courseId} />
        </div>
      </div>
    </div>
  );
};

export default CourseStudents;
