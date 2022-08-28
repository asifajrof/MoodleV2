import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";

import CourseGradeUpdateRow from "./CourseGradeUpdateRow";
import { Button } from "@mui/material";

// import './course_topics.css';

const StyledTableCell = styled(TableCell)(({ theme }) => ({
	[`&.${tableCellClasses.head}`]: {
		//   backgroundColor: theme.palette.common.black,
		backgroundColor: "#F4F7FC",
		color: theme.palette.common.black,
		fontWeight: "bold",
	},
	[`&.${tableCellClasses.body}`]: {
		fontSize: 14,
	},
}));

const TeacherCourseGradeUpdate = ({ userName, courseId, eventId }) => {
	const navigate = useNavigate();
	const [studentList, setStudentList] = useState([]);
	const [markList, setMarkList] = useState([]);

	const createMarkList = (studentList) => {
		// console.log("create marks list");
		let newMarkList = [];
		for (let i = 0; i < studentList.length; i++) {
			newMarkList.push({
				studentId: studentList[i].studentID,
				subId: studentList[i].subID,
				mark: studentList[i].mark,
				totalMark: studentList[i].totalMark,
				tUserName: userName,
				courseId: courseId,
			});
		}
		// console.log(newMarkList);
		setMarkList(newMarkList);
	};
	const updateMarkList = (studentId, mark) => {
		let newMarkList = [...markList];
		for (let i = 0; i < newMarkList.length; i++) {
			if (newMarkList[i].studentId === studentId) {
				newMarkList[i].mark = mark;
			}
		}
		setMarkList(newMarkList);
		// console.log("updated newMarkList", newMarkList);
	};

	// fetch here
	useEffect(() => {
		const fetchData = async () => {
			try {
				const response = await fetch(`/api/course/grade/${eventId}`);
				const jsonData = await response.json();
				setStudentList(jsonData.data);
				createMarkList(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData();
	}, []);

	const updateGrade = async (markList) => {
		// post method here
		// courseId, userName (for teacher info) available. other stuffs are input from form
		try {
			const res = await fetch(`/api/teacher/course/addGrade`, {
				method: "POST",
				headers: {
					"Content-type": "application/json",
				},
				body: JSON.stringify(markList),
			});
			const jsonData = await res.json();
			let id = null;
			console.log(res);
			if (res.status === 200) {
				console.log(jsonData.message);
				// navigate(`/course/${courseId}/grades`);
			} else {
				// alert(data.message);
				console.log(jsonData.message);
			}
		} catch (err) {
			console.log(err);
			// alert(err);
		}
	};

	const onMarkSubmit = (e) => {
		e.preventDefault();
		console.log("onMarkSubmit", markList);
		updateGrade(markList);
	};
	const onChangeMark = (studentId, mark) => {
		console.log("on change function back", studentId, mark);
		updateMarkList(studentId, mark);
	};
	return (
		<div className="course__event__submission">
			<div className="course__event__submission__info">
				<form onSubmit={onMarkSubmit}>
					<div style={{ width: "100%", paddingRight: "4rem" }}>
						<TableContainer component={Paper}>
							<Table sx={{ minWidth: 700 }} aria-label="customized table">
								<TableHead>
									<TableRow>
										<StyledTableCell align="center">Student ID</StyledTableCell>
										<StyledTableCell align="center">Mark</StyledTableCell>
									</TableRow>
								</TableHead>
								<TableBody>
									{studentList.map((student, index) => (
										<CourseGradeUpdateRow
											key={index}
											userName={userName}
											student={student}
											courseId={courseId}
											onChangeMark={onChangeMark}
										/>
									))}
								</TableBody>
							</Table>
						</TableContainer>
					</div>
					<br />
					<Button type="submit" variant="contained" color="primary">
						Done
					</Button>
				</form>
			</div>
		</div>
	);
};

export default TeacherCourseGradeUpdate;
