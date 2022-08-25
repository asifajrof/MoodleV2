import React, { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";

import CourseMenuBar from "../components/course_menu_bar";
import CourseForumsTable from "../components/CourseForumsTable";
// import "./course_home.css";

const TeacherCourseForums = ({ userName }) => {
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
  const addNewForumLink = `/course/${courseId}/forum/addnew`;

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
              <Link to={addNewForumLink}>
                <Button variant="contained">
                  Add New
                  <AddIcon />
                </Button>
              </Link>
            </div>
            <CourseForumsTable userName={userName} courseId={courseId} />
          </div>
          <div>{/* upcoming */}</div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default TeacherCourseForums;
