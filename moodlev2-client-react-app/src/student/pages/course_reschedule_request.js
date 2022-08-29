import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import RescheduleRequestBody from "../components/reschedule_request_body";
// import "./course_home.css";

const CRCourseRescheduleRequest = ({ studentNo }) => {
  const [courseInfo, setcourseInfo] = useState([]);
  const params = useParams();
  const courseId = params.courseId;
  const extraClassEventId = params.extraClassEventId;
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
        <div className="course__event__container" style={{ width: "95%" }}>
          <div className="course__event__info">
            <RescheduleRequestBody
              studentNo={studentNo}
              courseId={courseId}
              extraClassEventId={extraClassEventId}
            />
          </div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default CRCourseRescheduleRequest;
