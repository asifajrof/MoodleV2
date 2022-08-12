import React, { useState, useEffect } from "react";
// import { useLocation } from 'react-router-dom';
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import FileUpload from "../components/file_upload/FileUpload";
import "./course_home.css";

const StudentCourseEvents = ({ studentNo }) => {
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
      <CourseMenuBar studentNo={studentNo} courseId={courseId} />
      <div className="course__home__container">
        <div className="course__home__container__item__1">
          {courseInfo._term} {courseInfo.__year} {courseInfo._dept_shortname}{" "}
          {courseInfo._course_code}: {courseInfo._course_name}
        </div>
        <div className="course__home__container__divider">
          <div className="container mt-4">
            <h6 className="display-4 text-center mb-4">File Upload</h6>
            <FileUpload />
          </div>
          <div>Upcoming/Latest post</div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default StudentCourseEvents;