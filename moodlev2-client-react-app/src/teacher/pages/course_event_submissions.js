import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import moment from "moment";
import CourseMenuBar from "../components/course_menu_bar";
import ShowFile from "../../shared/components/ShowFile";
import SubmissionsTable from "../components/submissions_table";
// import "./course_home.css";

const TeacherCourseEventSubmissions = ({ userName }) => {
	const params = useParams();
	const courseId = params.courseId;
	const eventId = params.eventId;
	const [courseInfo, setcourseInfo] = useState([]);
	const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
		{}
	);
	useEffect(() => {
		const fetchData = async () => {
			try {
				const response = await fetch(`/api/course/${courseId}`);
				const jsonData = await response.json();
				setcourseInfo(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData();
	}, []);
	useEffect(() => {
		const fetchData = async (eventId) => {
			try {
				const response = await fetch(`/api/course/event/${eventId}`);
				const jsonData = await response.json();
				setCourseEvalueationEventInfo(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData(eventId);
	}, [eventId]);
	return (
		<React.Fragment>
			<CourseMenuBar userName={userName} courseId={courseId} />

			<div className="course__home__container">
				<div className="course__home__container__item__1">
					{courseInfo._term} {courseInfo.__year} {courseInfo._dept_shortname}{" "}
					{courseInfo._course_code}: {courseInfo._course_name}
				</div>
				<div className="course__event__container">
					<div className="course__event__info">
						<div className="course__home__container__event__title">
							{courseEvalueationEventInfo.event_type}
						</div>
						<div className="course__home__container__event__subtitle">
							{moment(courseEvalueationEventInfo.event_date).format(
								"YYYY-MM-DD"
							)}
						</div>

						<div
							className="course__home__container__item__2"
							// style={{ paddingLeft: "1rem" }}
						>
							{courseEvalueationEventInfo.event_description}
						</div>
						<div
							className="course__home__container__item__2"
							// style={{ paddingLeft: "1rem" }}
						>
							<ShowFile fileID={eventId} />
						</div>
					</div>
					<div
						className="course__home__container__item__2"
						style={{
							paddingTop: "1rem",
							paddingBottom: "1rem",
							fontWeight: "bold",
						}}
					>
						Submissions
					</div>
					<div className="course__event__submission">
						<SubmissionsTable
							userName={userName}
							courseId={courseId}
							eventId={eventId}
						/>
					</div>
				</div>
			</div>
		</React.Fragment>
	);
};

export default TeacherCourseEventSubmissions;
