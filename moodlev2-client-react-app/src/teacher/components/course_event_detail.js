import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import moment from "moment";
// import FileUpload from "./file_upload/FileUpload";
// import FileEdit from "./file_edit/FileEdit";
import ShowFile from "../../shared/components/ShowFile";
import { Button } from "@mui/material";
// import "./course_home.css";

const TeacherCourseEventDetail = ({ userName, courseId, eventId }) => {
	const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
		{}
	);
	useEffect(() => {
		const fetchData = async (eventId) => {
			try {
				const response = await fetch(
					`/api/course/event/${eventId}/${userName}`
				);
				const jsonData = await response.json();
				setCourseEvalueationEventInfo(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData(eventId);
	}, [eventId]);
	return (
		<div className="course__event__container">
			<div className="course__event__info">
				<div className="course__home__container__event__title">
					{courseEvalueationEventInfo.event_type}
				</div>
				<div className="course__home__container__event__subtitle">
					{moment(courseEvalueationEventInfo.event_date).format("YYYY-MM-DD")}
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
				Details
			</div>
			<div className="course__event__submission">
				<div className="course__event__submission__info">
					<div className="course__event__submission__info__col">
						<div>Due date:</div>
						<div>Time remaining:</div>
						<div>Submissions:</div>
					</div>
					<div className="course__event__submission__info__col">
						<div>
							{moment(courseEvalueationEventInfo.event_date).format(
								"YYYY-MM-DD HH:mm:ss"
							)}
						</div>
						<>
							{courseEvalueationEventInfo.completed ? (
								<>
									{courseEvalueationEventInfo.submitted ? (
										<div className="early__remaining__time">
											Submitted early by{" "}
											{courseEvalueationEventInfo.remaining_time}
										</div>
									) : (
										<div className="overdue__remaining__time">
											Overdue by {courseEvalueationEventInfo.remaining_time}
										</div>
									)}
								</>
							) : (
								<div className="normal__remaining__time">
									{courseEvalueationEventInfo.remaining_time}
								</div>
							)}
						</>
						<div>
							<Link to={`/course/${courseId}/event/${eventId}/submissions`}>
								<Button variant="outlined" size="small">
									See Submissions
								</Button>
							</Link>
						</div>
					</div>
				</div>
			</div>
		</div>
	);
};

export default TeacherCourseEventDetail;
