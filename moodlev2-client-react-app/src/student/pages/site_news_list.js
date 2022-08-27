import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

// import CourseMenuBar from "../components/course_menu_bar";
import SiteNewsTable from "../components/SiteNewsTable";
// import "./course_home.css";

const StudentSiteNewsList = ({ studentNo }) => {
	// const [courseInfo, setcourseInfo] = useState([]);
	const params = useParams();
	// const courseId = params.courseId;

	// useEffect(() => {
	// 	const fetchData = async () => {
	// 		try {
	// 			const response = await fetch(`/api/course/${courseId}`);
	// 			const jsonData = await response.json();
	// 			setcourseInfo(jsonData.data);
	// 		} catch (err) {
	// 			console.log(err);
	// 		}
	// 	};
	// 	fetchData();
	// }, []);

	return (
		<React.Fragment>
			{/* <CourseMenuBar studentNo={studentNo} courseId={courseId} /> */}
			<div className="course__home__container">
				<div className="course__home__container__item__1">Site News</div>
				<div className="course__home__container__divider">
					<SiteNewsTable studentNo={studentNo} /*courseId={courseId}*/ />
					<div>{/* upcoming */}</div>
				</div>
			</div>
		</React.Fragment>
	);
};

export default StudentSiteNewsList;
