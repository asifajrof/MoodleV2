import React, { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import CourseGradesTable from "../components/CourseGradesTable";

const TeacherCourseGrades = ({ userName }) => {
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
            <CourseGradesTable userName={userName} courseId={courseId} />
          </div>
          <div></div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default TeacherCourseGrades;
