import React, { useState, useEffect } from "react";
import { FormHelperText, TextField, Button, InputLabel } from "@mui/material";
import { useNavigate } from "react-router-dom";

const CourseForumAddForm = ({ userName, courseId }) => {
	const navigate = useNavigate();
	// var offering, offered, _year, batch, level, term, course_num;
	// var course_name;
	const [forumName, setForumName] = useState("");
	const [forumDescription, setForumDescription] = useState("");

	const addCourseForum = async (courseForumObj) => {
		//post method here
		//courseId, userName (for teacher info) available. other stuffs are input from form
		try {
			const res = await fetch(`/api/forum/course/addNewCourseForum`, {
				method: "POST",
				headers: {
					"Content-type": "application/json",
				},
				body: JSON.stringify(courseForumObj),
			});
			const jsonData = await res.json();
			let id = null;
			// console.log(data);
			// console.log(res.status);
			console.log(res);
			if (res.status === 200) {
				navigate(`/course/${courseId}/forum/${jsonData.data.id}`);
				console.log("Course forum added successfully!");
				// id = data.id;
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
		const courseForumObj = {
			forumName: forumName,
			forumDescription: forumDescription,
			courseId: courseId,
			teacherUserName: userName,
		};
		console.log(courseForumObj);

		setForumName("");
		setForumDescription("");

		addCourseForum(courseForumObj);

		console.log("onSubmitActionc of add new course forum");
		return;
	};

	return (
		<div className="addcourse__container">
			<div className="addcourse__form__container">
				<form onSubmit={onSubmitAction} style={{ width: "80%" }}>
					<TextField
						fullWidth
						type="text"
						id="addcoursetopic__topic__name"
						label="Name"
						variant="outlined"
						value={forumName}
						onChange={(e) => setForumName(e.target.value)}
						required
					/>
					<br />
					<br />
					<TextField
						fullWidth
						type="text"
						id="addcoursetopic__topic__desc"
						label="Description"
						variant="outlined"
						multiline
						value={forumDescription}
						onChange={(e) => setForumDescription(e.target.value)}
						required
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

export default CourseForumAddForm;
