import React, { useState, useEffect } from "react";
// import { useLocation } from 'react-router-dom';
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import CourseEvaluationEvents from "../components/course_evaluation_events";
import FileUpload from "../components/file_upload/FileUpload";
// import "./course_home.css";

const courseEvalueationEventInfoInit = {
  id: 1,
  event_type: "Assignment",
  event_description: "Homework on Chapter 1",
  completed: false,
  event_date: "2022-08-20",
};

const StudentCourseEvent = ({ studentNo }) => {
  const [courseInfo, setcourseInfo] = useState([]);
  // const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
  //   {}
  // );
  const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
    courseEvalueationEventInfoInit
  );
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
      <CourseMenuBar studentNo={studentNo} courseId={courseId} />

      <div className="course__home__container">
        <div className="course__home__container__item__1">
          {courseInfo._term} {courseInfo.__year} {courseInfo._dept_shortname}{" "}
          {courseInfo._course_code}: {courseInfo._course_name}
        </div>
        <div
          className="course__home__container__event__title"
          style={{ paddingTop: "2rem" }}
        >
          {courseEvalueationEventInfo.event_type}
        </div>
        <div className="course__home__container__event__subtitle">
          {courseEvalueationEventInfo.event_date}
        </div>
        <div
          className="course__home__container__divider"
          style={{ paddingLeft: "1rem" }}
        >
          {courseEvalueationEventInfo.event_description}
          <FileUpload />

          <div> </div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default StudentCourseEvent;
