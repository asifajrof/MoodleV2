import React from "react";
import moment from "moment";

import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";

import Checkbox from "@mui/material/Checkbox";

const StyledTableCell = styled(TableCell)(({ theme }) => ({
	[`&.${tableCellClasses.head}`]: {
		backgroundColor: theme.palette.common.black,
		color: theme.palette.common.white,
	},
	[`&.${tableCellClasses.body}`]: {
		fontSize: 14,
	},
}));

const StyledTableRow = styled(TableRow)(({ theme }) => ({
	"&:nth-of-type(odd)": {
		backgroundColor: theme.palette.action.hover,
	},
	// hide last border
	"&:last-child td, &:last-child th": {
		border: 0,
	},
}));

export default function TeacherTableRow({ teacherObj }) {
	let dataIndex = 0;
	function createData(name, teacher_username, email, dept) {
		return {
			name,
			teacher_username,
			email,
			dept,
		};
	}
	const row = createData(
		teacherObj.name,
		teacherObj.teacher_username,
		teacherObj.email,
		teacherObj.dept
	);

	return (
		<StyledTableRow>
			<StyledTableCell align="center">{row.name}</StyledTableCell>
			{/* <StyledTableCell align="center">{row.dataIndex}</StyledTableCell> */}
			<StyledTableCell align="center">{row.teacher_username}</StyledTableCell>
			{/* <StyledTableCell align="center" component="th" scope="row">
				{row.topicName}
			</StyledTableCell> */}
			<StyledTableCell align="center">{row.email}</StyledTableCell>
			<StyledTableCell align="center">{row.dept}</StyledTableCell>
		</StyledTableRow>
	);
}
