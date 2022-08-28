import React, { useState, useEffect } from "react";
// import { Link } from "react-router-dom";
import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";
import Checkbox from "@mui/material/Checkbox";

import CourseTeacherTableRow from "./CourseTeacherTableRow";
import RemoveCourseTeacher from "./RemoveCourseTeacher";

// import './registered_course.css';

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

const CourseTeacherTable = ({ adminNo, courseId }) => {
	const [selectedTeachersList, setSelectedTeachersList] = useState([]);
	const [courseTeachersList, setCourseTeachersList] = useState([]);
	const [checkedList, setCheckedList] = useState([]);
	const [showDelete, setShowDelete] = useState(false);

	const handleChangeCheckAll = (event) => {
		const newCheckedList = [...checkedList];
		const newSelectedTeachersList = [];
		if (event.target.checked === true) {
			// add all into selected
			for (let i = 0; i < courseTeachersList.length; i++) {
				newCheckedList[i] = true;
				newSelectedTeachersList.push({
					index: i,
					teacherObj: courseTeachersList[i],
				});
			}
		} else {
			// remove all from selected
			for (let i = 0; i < courseTeachersList.length; i++) {
				newCheckedList[i] = false;
			}
		}
		setCheckedList(newCheckedList);
		setSelectedTeachersList(newSelectedTeachersList);
	};
	const isAllChecked = () => {
		let val = false;
		// for loop
		for (let i = 0; i < checkedList.length; i++) {
			if (checkedList[i] === false) {
				val = false;
				break;
			} else {
				val = true;
			}
		}
		return val;
	};
	const isIndeterminate = () => {
		let val = false;
		let initial = false;
		// for loop
		for (let i = 0; i < checkedList.length; i++) {
			if (i === 0) {
				initial = checkedList[i];
			} else {
				if (checkedList[i] !== initial) {
					val = true;
					break;
				}
			}
		}
		return val;
	};

	const handleChangeSingle = (index, checked) => {
		const newCheckedList = [...checkedList];
		newCheckedList[index] = checked;
		setCheckedList(newCheckedList);

		const newSelectedTeachersList = [...selectedTeachersList];
		if (checked === true) {
			// insert into selectedTeachersList
			newSelectedTeachersList.push({
				index: index,
				teacherObj: courseTeachersList[index],
			});
		} else {
			// remove from selectedTeachersList after finding
			// find
			const foundIndex = newSelectedTeachersList.findIndex(
				(selectedTeacher) => selectedTeacher.index === index
			);
			// remove
			newSelectedTeachersList.splice(foundIndex, 1);
		}
		setSelectedTeachersList(newSelectedTeachersList);
	};

	useEffect(() => {
		const fetchData = async () => {
			try {
				// fetch change hobe
				const response = await fetch(`/api/admin/course/${courseId}/teachers`);
				const jsonData = await response.json();
				setCourseTeachersList(jsonData.data);
				// console.log(jsonData.data);
				// create courseTeachersList.length array filled with false
				const newCheckedList = new Array(jsonData.data.length).fill(false);
				setCheckedList(newCheckedList);
				// console.log(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData();
	}, []);

	useEffect(() => {
		setShowDelete(selectedTeachersList.length > 0);
	}, [selectedTeachersList]);
	return (
		<>
			{showDelete && (
				<div style={{ alignSelf: "flex-start" }}>
					<RemoveCourseTeacher
						courseId={courseId}
						TeacherList={selectedTeachersList}
					/>
				</div>
			)}
			<div style={{ width: "100%", paddingRight: "4rem" }}>
				<TableContainer component={Paper}>
					<Table sx={{ minWidth: 700 }} aria-label="customized table">
						<TableHead>
							<TableRow>
								{/* <StyledTableCell align="center"> </StyledTableCell> */}
								<StyledTableCell align="center">
									<Checkbox
										checked={isAllChecked()}
										indeterminate={isIndeterminate()}
										onChange={handleChangeCheckAll}
									/>
								</StyledTableCell>
								<StyledTableCell align="center">Name</StyledTableCell>
								<StyledTableCell align="center">Username</StyledTableCell>
								{/* <StyledTableCell align="center">E-mail</StyledTableCell>
								<StyledTableCell align="center">Department</StyledTableCell> */}
								{/* <StyledTableCell align="center">Designation</StyledTableCell> */}
							</TableRow>
						</TableHead>
						<TableBody>
							{courseTeachersList.map((teacherObj, index) => (
								<CourseTeacherTableRow
									key={index}
									teacherIndex={index}
									checked={
										checkedList[index] === undefined
											? false
											: checkedList[index]
									}
									teacherObj={teacherObj}
									adminNo={adminNo}
									courseId={courseId}
									handleChangeSingle={handleChangeSingle}
								/>
							))}
						</TableBody>
					</Table>
				</TableContainer>
			</div>
		</>
	);
};

export default CourseTeacherTable;
