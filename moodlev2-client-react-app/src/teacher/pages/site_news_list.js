import React, { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
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
					<div className="course__home__item__left">
						<div
							className="course__container__add"
							style={{ paddingRight: "4rem" }}
						>
							<Link to={`/sitenews/addnew`}>
								<Button variant="contained">
									Add New
									<AddIcon />
								</Button>
							</Link>
						</div>
						<SiteNewsTable userName={userName} /*courseId={courseId}*/ />
					</div>
					<div>{/* upcoming */}</div>
				</div>
			</div>
		</React.Fragment>
	);
};

export default TeacherSiteNewsList;
