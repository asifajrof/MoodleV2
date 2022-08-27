import React, { useState, useEffect } from "react";
// import { useLocation } from 'react-router-dom';
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import TeacherCourseEventDetail from "../components/course_event_detail";
// import "./course_home.css";

const TeacherCourseEvent = ({ userName }) => {
  const [courseInfo, setcourseInfo] = useState([]);
  const params = useParams();
  const courseId = params.courseId;
  const eventId = params.eventId;

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
        <TeacherCourseEventDetail
          userName={userName}
          courseId={courseId}
          eventId={eventId}
        />
      </div>
    </React.Fragment>
  );
};

export default TeacherCourseEvent;
