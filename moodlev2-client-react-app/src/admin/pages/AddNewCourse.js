import React from "react";
import CourseAddForm from "../components/add_course_form";
import "./AddNewCourse.css";

const AddNewCourse = ({ adminNo }) => {
  return (
    <div className="addcourse__container">
      <div className="addcourse__title">Add New Course</div>
      <div className="addcourse__form__container">
        <CourseAddForm adminNo={adminNo} />
      </div>
    </div>
  );
};

export default AddNewCourse;
