import React, { useEffect, useState } from "react";

const FileEdit = ({ fileID }) => {
	const [fileInfo, setFileInfo] = useState([]);
	useEffect(() => {
		const fetchData = async (fileID, studentNo, courseId, eventId) => {
			try {
				const response = await fetch(
					`/api/file/edit/student/course/evaluation/${fileID}`
				);
				const jsonData = await response.json();
				setFileInfo(jsonData.data);
				console.log(fileInfo);
			} catch (err) {
				console.log(err);
			}
			// try {
			// 	const getFileObj = {
			//     submissionId : fileID,
			// 		studentNo: studentNo,
			// 		courseId: courseId,
			// 		eventId: eventId,
			// 	};
			// 	const res = await fetch(`/api/file/edit/student/course/evaluation`, {
			// 		method: "POST",
			// 		headers: {
			// 			"Content-type": "application/json",
			// 		},
			// 		body: JSON.stringify(getFileObj),
			// 	});
			// 	const data = await res.json();
			// 	// console.log(data);
			// 	// console.log(res.status);
			// 	if (res.status === 200) {
			// 		// alert("Course added successfully!");
			// 		console.log("File Information fetched successfully!");
			// 	} else {
			// 		// alert(data.message);
			// 		console.log(data.message);
			// 	}
			// } catch (err) {
			// 	console.log(err);
			// 	// alert(err);
			// }
		};
		fetchData(fileID); //studentNo, courseId, eventId);
	}, [fileID]);

	const downloadFile = async (fileID) => {
		console.log(fileInfo);
		try {
			const response = await fetch(
				`/api/file/download/student/course/evaluation/${fileID}`
			);
			const blobData = await response.blob();
			let url = window.URL.createObjectURL(blobData);
			let a = document.createElement("a");
			a.href = url;
			a.download = fileInfo.file_name;
			a.click();
		} catch (err) {
			console.log(err);
		}
	};
	return (
		<div>
			<button onClick={() => downloadFile(fileID)}>{fileInfo.file_name}</button>
		</div>
	);
};

export default FileEdit;
