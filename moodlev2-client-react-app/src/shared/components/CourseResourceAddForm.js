import React, { useState, useEffect } from "react";
import { TextField, Button, InputLabel } from "@mui/material";
import { useNavigate } from "react-router-dom";

import axios from "axios";

import Message from "./Message";
import Progress from "./Progress";
// import "./FileUpload.css";

const CourseResourceAddForm = ({ userName, uType, courseId }) => {
	const [file, setFile] = useState("");
	const [filename, setFilename] = useState("Choose File");
	const [message, setMessage] = useState("");
	const [uploadPercentage, setUploadPercentage] = useState(0);
	const navigate = useNavigate();
	const [resourceTitle, setResourceTitle] = useState("");

	const onChange = (e) => {
		setFile(e.target.files[0]);
		if (e.target.files[0] !== undefined) {
			setFilename(e.target.files[0].name);
		} else {
			setFilename("Choose File");
		}
	};

	const addCourseResource = async (resourceObj) => {
		try {
			const formData = new FormData();
			if (file === "" || file === undefined) {
				console.log("No file selected");
				// raise error
				setMessage("Please select a file");
				// clear message
				setTimeout(() => setMessage(""), 2000);
				return;
			}
			// resourceTitle: resourceTitle,
			// resourceUploaderId: userName,
			// resourceUploaderType: uType,
			// resourceCourseId: courseId,
			// console.log(resourceObj);
			formData.append("resourceTitle", resourceObj.resourceTitle);
			formData.append("resourceUploaderId", resourceObj.resourceUploaderId);
			formData.append("resourceUploaderType", resourceObj.resourceUploaderType);
			formData.append("resourceCourseId", resourceObj.resourceCourseId);

			formData.append("file", file);
			const res = await axios.post("/api/resource/upload/", formData, {
				headers: {
					"Content-Type": "multipart/form-data",
				},
				onUploadProgress: (progressEvent) => {
					setUploadPercentage(
						parseInt(
							Math.round((progressEvent.loaded * 100) / progressEvent.total)
						)
					);
				},
			});

			// Clear percentage
			// console.log(res);
			setTimeout(() => setUploadPercentage(0), 1000);
			const message = res.data.message;
			// console.log(message);
			// setUploadedFile({ fileName, filePath });
			setMessage(message);
			// clear message
			setTimeout(() => setMessage(""), 2000);
			setFile("");
			setFilename("Choose File");
			// refresh page
			setTimeout(() => window.location.reload(), 2000);
		} catch (err) {
			if (err.response.status === 500) {
				setMessage("There was a problem with the server");
			} else {
				setMessage(err.response.data.msg);
			}
			setUploadPercentage(0);
			// clear message
			setTimeout(() => setMessage(""), 2000);
		}
	};
	const onSubmitAction = (event) => {
		event.preventDefault();
		const resourceObj = {
			resourceTitle: resourceTitle,
			resourceUploaderId: userName,
			resourceUploaderType: uType,
			resourceCourseId: courseId,
		};
		// console.log(resourceObj);
		addCourseResource(resourceObj);
		return;
	};

	return (
		<div className="addcourse__container">
			<div className="addcourse__form__container">
				{message ? (
					<>
						<Message msg={message} showVal={true} /> <br />
						<br />{" "}
					</>
				) : null}
				<form onSubmit={onSubmitAction} style={{ width: "80%" }}>
					<TextField
						fullWidth
						type="text"
						id="addresource__title"
						label="Title"
						variant="outlined"
						value={resourceTitle}
						onChange={(e) => setResourceTitle(e.target.value)}
						required
					/>
					<br />
					<br />

					<div className="custom-file">
						<label className="custom-file-label" htmlFor="customFile">
							{filename}
						</label>
						<input
							className="custom-file-input"
							type="file"
							// style={{ display: "none" }}
							id="customFile"
							onChange={onChange}
						/>
						<label className="custom-file-label2" htmlFor="customFile">
							Browse
						</label>
					</div>
					<br />
					<Progress percentage={uploadPercentage} />
					<input
						type="submit"
						value="Upload"
						className="btn btn-primary btn-block mt-4"
					/>
				</form>
			</div>
		</div>
	);
};

export default CourseResourceAddForm;
