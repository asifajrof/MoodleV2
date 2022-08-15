import React from "react";
import TeacherAddForm from "../components/add_teacher_form";
// import "./AddNewCourse.css";

const AddNewTeacher = ({ adminNo }) => {
  return (
    <div className="addcourse__container">
      <div className="addcourse__title">Add New Teacher</div>
      <div className="addcourse__form__container">
        <TeacherAddForm adminNo={adminNo} />
      </div>
    </div>
  );
};

export default AddNewTeacher;
