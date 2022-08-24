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

        <div className="course__event__container">
          <div className="course__event__info">
            <div className="course__home__container__event__title">
              {courseEvalueationEventInfo.event_type}
            </div>
            <div className="course__home__container__event__subtitle">
              {courseEvalueationEventInfo.event_date}
            </div>

            <div
              className="course__home__container__item__2"
              // style={{ paddingLeft: "1rem" }}
            >
              {courseEvalueationEventInfo.event_description}
            </div>
          </div>
          <div
            className="course__home__container__item__2"
            style={{
              paddingTop: "1rem",
              paddingBottom: "1rem",
              fontWeight: "bold",
            }}
          >
            Submission
          </div>
          <div className="course__event__submission">
            <div className="course__event__submission__info">
              <div className="col_left">
                Due date:
                <br />
                Time remaining:
                <br />
                File upload:
              </div>
              <div className="col_right">
                bla bla bla
                <br />
                bla bla bla
                <br />
                <FileUpload />
              </div>
            </div>
          </div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default StudentCourseEvent;
