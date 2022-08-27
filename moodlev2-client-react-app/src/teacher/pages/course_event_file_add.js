import React, { useState, useEffect } from "react";
import moment from "moment";
// import { useLocation } from 'react-router-dom';
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import FileUpload from "../components/file_upload/FileUpload";
// import "./course_home.css";

const TeacherCourseEventFileAdd = ({ userName }) => {
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
        const response = await fetch(`/api/course/event/${eventId}`);
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
          </div>
          <div
            className="course__home__container__item__2"
            style={{
              paddingTop: "1rem",
              paddingBottom: "1rem",
              fontWeight: "bold",
            }}
          >
            Add File
          </div>
          <div className="course__event__submission">
            <div className="course__event__submission__info">
              <div className="course__event__submission__info__col">
                <div>File upload:</div>
              </div>
              <div className="course__event__submission__info__col">
                <FileUpload
                  userName={userName}
                  courseId={courseId}
                  eventId={eventId}
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default TeacherCourseEventFileAdd;
