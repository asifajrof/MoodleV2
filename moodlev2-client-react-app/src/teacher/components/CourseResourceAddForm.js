import React, { useState, useEffect } from "react";
import {
	FormHelperText,
	TextField,
	Button,
	InputLabel,
	MenuItem,
	ToggleButton,
	ToggleButtonGroup,
} from "@mui/material";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import { Select as SelectMui } from "@mui/material";
import { useNavigate } from "react-router-dom";
import dayjs from "dayjs";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import { ListItemIcon, ListItemText, Checkbox } from "@mui/material";
import ShowSchedule from "./show_schedule";

// import { makeStyles } from "@material-ui/core/styles";
// import { makeStyles } from "@mui/styles";

// const useStyles = makeStyles((theme) => ({
//   formControl: {
//     margin: theme.spacing(1),
//     width: 300,
//   },
//   indeterminateColor: {
//     color: "#f50057",
//   },
//   selectAllText: {
//     fontWeight: 500,
//   },
//   selectedAll: {
//     backgroundColor: "rgba(0, 0, 0, 0.08)",
//     "&:hover": {
//       backgroundColor: "rgba(0, 0, 0, 0.08)",
//     },
//   },
// }));

const CourseResourceAddForm = ({ userName, courseId }) => {
	//   const classes = useStyles();
	const navigate = useNavigate();
	const [eventType, setEventType] = useState("");
	const [eventFullMarks, setEventFullMarks] = useState("");
	const [typeList, setTypeList] = useState([]);
	const [sectionList, setSectionList] = useState([]);
	const [eventSection, setEventSection] = useState([]);
	// const [eventSectionName, setEventSectionName] = useState([]);
	const [eventDescription, setEventDescription] = useState("");
	const [eventTime, setEventTime] = useState(new Date());
	const isAllSelected =
		sectionList.length > 0 && eventSection.length === sectionList.length;

	// useefect
	// dependency eventsection

	const addCourseEvent = async (courseEventObj) => {
		//post method here
		//courseId, userName (for teacher info) available. other stuffs are input from form
		try {
			const res = await fetch(`/api/course/addNewEvent`, {
				method: "POST",
				headers: {
					"Content-type": "application/json",
				},
				body: JSON.stringify(courseEventObj),
			});
			const jsonData = await res.json();
			let id = null;
			// console.log(data);
			// console.log(res.status);
			console.log(res);
			if (res.status === 200) {
				console.log(jsonData.message);
				// 		setEventType("");
				// setEventDescription("");
				// setEventTime(new Date());
				// setEventSection([]);
				// id = jsonData.data.id;
				navigate(`/course/${courseId}/events`);
			} else {
				// alert(data.message);
				console.log(jsonData.message);
			}
		} catch (err) {
			console.log(err);
			// alert(err);
		}
	};
	const onSubmitAction = (event) => {
		event.preventDefault();
		const eventSectionList = eventSection.map((s) => s.secno);
		const courseEventObj = {
			eventType: eventType,
			eventFullMarks: eventFullMarks,
			eventTime: eventTime,
			eventDescription: eventDescription,
			courseId: courseId,
			teacherUserName: userName,
			eventSectionList: eventSectionList,
		};
		console.log(courseEventObj);
		addCourseEvent(courseEventObj);
		console.log("onSubmitAction of add new course event");
		return;
	};
	const [scheduleShow, setScheduleShow] = useState("");
	const onScheduleShowChange = (event, newValue) => {
		setScheduleShow(newValue);
	};

	return (
		<div className="addcourse__container">
			<div className="addcourse__form__container">
				<form onSubmit={onSubmitAction} style={{ width: "80%" }}>
					<InputLabel>Title</InputLabel>
					<TextField
						fullWidth
						type="text"
						id="addcoursetopic__topic__desc"
						// label="Description"
						variant="outlined"
						value={eventDescription}
						onChange={(e) => setEventDescription(e.target.value)}
						required
					/>
					<InputLabel>Description</InputLabel>
					<TextField
						fullWidth
						type="text"
						id="addcoursetopic__topic__desc"
						// label="Description"
						variant="outlined"
						multiline
						value={eventDescription}
						onChange={(e) => setEventDescription(e.target.value)}
					/>
					<br />
					<br />
					<Button type="submit" variant="outlined">
						Add
					</Button>
				</form>
			</div>
		</div>
	);
};

export default CourseResourceAddForm;
