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

import StudentTableRow from "./student_table_row";

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

const StudentTable = ({ adminNo }) => {
	const [allStudentsList, setAllStudentsList] = useState([]);

	useEffect(() => {
		const fetchData = async () => {
			try {
				const response = await fetch(`/api/admin/students/all`);
				const jsonData = await response.json();
				setAllStudentsList(jsonData.data);
				console.log(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData();
	}, []);
	return (
		<div style={{ width: "100%", paddingRight: "4rem" }}>
			<TableContainer component={Paper}>
				<Table sx={{ minWidth: 700 }} aria-label="customized table">
					<TableHead>
						<TableRow>
							{/* <StyledTableCell align="center"> </StyledTableCell> */}
							{/* <StyledTableCell align="center"> </StyledTableCell> */}
							<StyledTableCell align="center">Name</StyledTableCell>
							<StyledTableCell align="center">Student ID</StyledTableCell>
							<StyledTableCell align="center">E-mail</StyledTableCell>
							<StyledTableCell align="center">Department</StyledTableCell>
							{/* <StyledTableCell align="center">Designation</StyledTableCell> */}
						</TableRow>
					</TableHead>
					<TableBody>
						{allStudentsList.map((studentObj, index) => (
							<StudentTableRow key={index} studentObj={studentObj} />
						))}
					</TableBody>
				</Table>
			</TableContainer>
		</div>
	);
};
export default StudentTable;
