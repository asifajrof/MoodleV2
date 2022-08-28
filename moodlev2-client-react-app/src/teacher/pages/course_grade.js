import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import moment from "moment";

import CourseMenuBar from "../components/course_menu_bar";
import TeacherCourseGradeUpdate from "../components/course_grade_update";
// import "./course_home.css";

const TeacherCourseGrade = ({ userName }) => {
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

  const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
    {}
  );
  useEffect(() => {
    const fetchData = async (eventId) => {
      try {
        const response = await fetch(
          `/api/course/event/${eventId}/${userName}`
        );
        const jsonData = await response.json();
        setCourseEvalueationEventInfo(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData(eventId);
  }, [eventId]);

  return (
    <React.Fragment>
      <CourseMenuBar userName={userName} courseId={courseId} />

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
              {moment(courseEvalueationEventInfo.event_date).format(
                "YYYY-MM-DD"
              )}
            </div>

            <div className="course__home__container__item__2">
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
            Grades
          </div>
          <TeacherCourseGradeUpdate
            userName={userName}
            courseId={courseId}
            eventId={eventId}
          />
        </div>
      </div>
    </React.Fragment>
  );
};

export default TeacherCourseGrade;
