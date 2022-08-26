import React, { useEffect, useState } from "react";
import Course from "./all_courses/course";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { Link } from "react-router-dom";

// import './registered_courses.css';

const CurrentCourses = ({ adminNo }) => {
	// const [currentCoursesList, setCurrentCoursesList] = useState(course_list);
	const [CurrentCoursesList, setCurrentCoursesList] = useState([]);

	useEffect(() => {
		const fetchData = async () => {
			try {
				const response = await fetch(`/api/admin/courses/current`);
				const jsonData = await response.json();
				setCurrentCoursesList(jsonData.data);
				// console.log(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData();
	}, []);

	return (
		<div className="course__container" style={{ width: "100%" }}>
			<div className="course__container__add">
				<Link to="/courses/addnew">
					<Button variant="contained">
						Add New
						<AddIcon />
					</Button>
				</Link>
			</div>
			{CurrentCoursesList.map((course, index) => (
				<Course key={index} course={course} />
			))}
		</div>
	);
};

export default CurrentCourses;
