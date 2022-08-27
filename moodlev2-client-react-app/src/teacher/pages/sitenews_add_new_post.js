import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

import CourseMenuBar from "../components/course_menu_bar";
import SiteNewsAddForm from "../components/add_site_news_form";

const TeacherAddNewSiteNews = ({ userName }) => {
	const params = useParams();

	return (
		<React.Fragment>
			{/* <CourseMenuBar userName={userName} courseId={courseId} /> */}
			<div className="course__home__container">
				<div className="course__home__container__item__1">
					{/* {courseInfo._term} {courseInfo.__year} {courseInfo._dept_shortname}{" "}
					{courseInfo._course_code}: {courseInfo._course_name} */}
					Site News
				</div>
				<div className="course__home__container__divider">
					<div
						className="addcourse__container"
						style={{
							display: "flex",
							flexDirection: "column",
							gap: "1rem",
							alignItems: "flex-start",
						}}
					>
						<div className="addcourse__title">Add New Forum</div>
						<div className="addcourse__form__container">
							<SiteNewsAddForm userName={userName} />
						</div>
					</div>
					<div></div>
				</div>
			</div>
		</React.Fragment>
	);
};

export default TeacherAddNewSiteNews;
