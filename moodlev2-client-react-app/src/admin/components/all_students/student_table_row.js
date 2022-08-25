import React from "react";

import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";

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

export default function StudentTableRow({ studentObj }) {
	function createData(name, std_id, email, dept) {
		return {
			name,
			std_id,
			email,
			dept,
		};
	}
	const row = createData(
		studentObj.name,
		studentObj.std_id,
		studentObj.email,
		studentObj.dept
	);

	return (
		<StyledTableRow>
			<StyledTableCell align="center">{row.name}</StyledTableCell>
			{/* <StyledTableCell align="center">{row.dataIndex}</StyledTableCell> */}
			<StyledTableCell align="center">{row.std_id}</StyledTableCell>
			{/* <StyledTableCell align="center" component="th" scope="row">
				{row.topicName}
			</StyledTableCell> */}
			<StyledTableCell align="center">{row.dept}</StyledTableCell>
			<StyledTableCell align="center">{row.email}</StyledTableCell>
		</StyledTableRow>
	);
}
