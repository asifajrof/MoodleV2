import React, { useState, useEffect } from "react";
// import { useLocation } from 'react-router-dom';
import { useParams, Link } from "react-router-dom";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";

import CourseMenuBar from "../components/course_menu_bar";
import CourseEvaluationEvents from "../components/course_evaluation_events";
// import "./course_home.css";

const TeacherCourseEvents = ({ userName }) => {
  const [courseInfo, setcourseInfo] = useState([]);
  const params = useParams();
  const courseId = params.courseId;

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/course/${courseId}`);
        const jsonData = await response.json();
        setcourseInfo(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

  return (
    <React.Fragment>
      <CourseMenuBar userName={userName} courseId={courseId} />
      <div className="course__home__container">
        <div className="course__home__container__item__1">
          {courseInfo._term} {courseInfo.__year} {courseInfo._dept_shortname}{" "}
          {courseInfo._course_code}: {courseInfo._course_name}
        </div>
        <div className="course__home__container__divider">
          <div className="course__home__item__left">
            <div
              className="course__container__add"
              style={{ paddingRight: "4rem" }}
            >
              <Link to={`/course/${courseId}/events/addnew`}>
                <Button variant="contained">
                  Add New
                  <AddIcon />
                </Button>
              </Link>
            </div>
            <CourseEvaluationEvents userName={userName} courseId={courseId} />
          </div>
          <div></div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default TeacherCourseEvents;
