import React, { useState } from "react";
import { Link } from "react-router-dom";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import StudentTable from "../components/all_students/student_table";
// import './course_home.css';

const AdminStudents = ({ adminNo }) => {
	return (
		<div className="home__container">
			<div className="home__container__divider">
				<div className="course__container" style={{ width: "100%" }}>
					<div className="course__container__add">
						<Link to="/students/addnew">
							<Button variant="contained">
								Add New
								<AddIcon />
							</Button>
						</Link>
					</div>
					<div className="course__home__container__item__1">Students</div>
					<StudentTable adminNo={adminNo} />
				</div>
			</div>
		</div>
	);
};

export default AdminStudents;
