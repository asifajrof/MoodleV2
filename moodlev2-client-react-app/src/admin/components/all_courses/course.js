import React from "react";
import { Link } from "react-router-dom";

// import './registered_course.css';

const Course = ({ course }) => {
  const courseLink = `/course/${course._id}`;
  // course.submitted = 2;
  let courseTitle = (
    <div className="course__container__item__1">
      {course._term} {course.__year} {course._dept_shortname}
      {course._course_code}: {course._course_name}
    </div>
  );
  return (
    <div className="course__container__item">
      <Link to={courseLink} state={{ courseId: course._id }}>
        {courseTitle}
      </Link>
    </div>
  );
};
export default Course;
