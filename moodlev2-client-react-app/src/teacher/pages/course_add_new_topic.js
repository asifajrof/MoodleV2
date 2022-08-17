import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import CourseTopicAddForm from "../components/add_course_topic_form";

const TeacherAddNewCourseTopic = (userName) => {
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
          <div
            className="addcourse__container"
            style={{
              display: "flex",
              flexDirection: "column",
              gap: "1rem",
              alignItems: "flex-start",
            }}
          >
            <div className="addcourse__title">Add New Course Topic</div>
            <div className="addcourse__form__container">
              <CourseTopicAddForm userName={userName} courseId={courseId} />
            </div>
          </div>
          <div>Upcoming/Latest post</div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default TeacherAddNewCourseTopic;
