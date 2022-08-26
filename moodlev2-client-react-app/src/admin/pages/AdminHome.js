import React from "react";
// import Calendar from "../components/calendar";
import AllCourses from "../components/all_courses";
import CurrentCourses from "../components/current_courses";

// import './student_home.css';

const AdminHome = ({ adminNo }) => {
	return (
		<div
			className="home__container"
			style={{ alignItems: "flex-start", padding: "2rem", width: "100%" }}
		>
			<div
				className="course__home__container__item__1"
				style={{ padding: "2rem" }}
			>
				Current Courses
			</div>
			<CurrentCourses adminNo={adminNo} />

			<div
				className="course__home__container__item__1"
				style={{ padding: "2rem" }}
			>
				All Courses
			</div>
			<AllCourses adminNo={adminNo} />
		</div>
	);
	// return (
	// 	<div className="home__container">
	// 		<div className="home__container__divider">
	// 			<AllCourses adminNo={adminNo} />
	// 			{/* <Calendar adminNo={adminNo} /> */}
	// 		</div>
	// 	</div>
	// );
};

export default AdminHome;
