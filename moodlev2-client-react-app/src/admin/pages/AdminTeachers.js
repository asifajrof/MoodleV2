import React, { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import TeacherTable from "../components/all_teachers/teacher_table";
// import './course_home.css';

const AdminTeachers = ({ adminNo }) => {
  return (
    <div className="home__container">
      <div className="home__container__divider">
        <div className="course__container" style={{ width: "100%" }}>
          <div className="course__container__add">
            <Link to="/teachers/addnew">
              <Button variant="contained">
                Add New
                <AddIcon />
              </Button>
            </Link>
          </div>
          <div className="course__home__container__item__1">Teachers</div>
          <TeacherTable adminNo={adminNo} />
        </div>
      </div>
    </div>
  );
};

export default AdminTeachers;
