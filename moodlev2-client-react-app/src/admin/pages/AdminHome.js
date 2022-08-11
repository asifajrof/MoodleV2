import React from "react";
import Calendar from "../components/calendar";
import AllCourses from "../components/all_courses";

// import './student_home.css';

const AdminHome = ({ adminNo }) => {
  return (
    <div className="home__container">
      <div className="home__container__divider">
        <AllCourses adminNo={adminNo} />
        <Calendar adminNo={adminNo} />
      </div>
    </div>
  );
};

export default AdminHome;
