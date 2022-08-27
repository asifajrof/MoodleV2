import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

// import CourseMenuBar from "../components/course_menu_bar";
import SiteNewsTable from "../components/SiteNewsTable";
// import "./course_home.css";

const TeacherSiteNewsList = ({ userName }) => {
	const params = useParams();

	return (
		<React.Fragment>
			{/* <CourseMenuBar studentNo={studentNo} courseId={courseId} /> */}
			<div className="course__home__container">
				<div className="course__home__container__item__1">Site News</div>
				<div className="course__home__container__divider">
					<SiteNewsTable userName={userName} /*courseId={courseId}*/ />
					<div>{/* upcoming */}</div>
				</div>
			</div>
		</React.Fragment>
	);
};

export default TeacherSiteNewsList;
