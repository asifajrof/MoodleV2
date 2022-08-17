import React from "react";
import StudentAddForm from "../components/add_student_form";
// import "./AddNewCourse.css";

const AddNewStudent = ({ adminNo }) => {
  return (
    <div className="addcourse__container">
      <div className="addcourse__title">Add New Student</div>
      <div className="addcourse__form__container">
        <StudentAddForm adminNo={adminNo} />
      </div>
    </div>
  );
};

export default AddNewStudent;
