import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import CourseForumAddForm from "../components/add_course_forum_form";

const TeacherAddNewForum = (userName) => {
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
            <div className="addcourse__title">Add New Forum</div>
            <div className="addcourse__form__container">
              <CourseForumAddForm userName={userName} courseId={courseId} />
            </div>
          </div>
          <div></div>
        </div>
      </div>
    </React.Fragment>
  );
};

export default TeacherAddNewForum;
