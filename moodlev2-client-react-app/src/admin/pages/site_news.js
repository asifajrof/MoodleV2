import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";

// import CourseMenuBar from "../components/course_menu_bar";
import SiteNewsPage from "../components/site_news/SiteNewsPage";
// import "./course_home.css";

const AdminSiteNews = ({ userName }) => {
	const params = useParams();
	const forumId = params.forumId;

	return (
		<React.Fragment>
			{/* <CourseMenuBar studentNo={studentNo} courseId={courseId} /> */}

			<div className="course__home__container">
				<div className="course__home__container__item__1">Site News</div>
				<SiteNewsPage userName={userName} forumId={forumId} />
			</div>
		</React.Fragment>
	);
};

export default AdminSiteNews;
