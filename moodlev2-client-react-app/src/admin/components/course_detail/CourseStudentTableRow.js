import React from "react";
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

const CourseStudentTableRow = ({
	studentIndex,
	adminNo,
	courseId,
	studentObj,
	handleChangeSingle,
	checked,
}) => {
	function createData(std_name, std_id, sec_name) {
		return {
			std_name,
			std_id,
			sec_name,
		};
	}
	const row = createData(
		studentObj.std_name,
		studentObj.std_id,
		studentObj.sec_name
	);

	const handleChangeSingleHelper = (event) => {
		handleChangeSingle(studentIndex, event.target.checked);
	};
	return (
		<StyledTableRow>
			<StyledTableCell align="center">
				<Checkbox checked={checked} onChange={handleChangeSingleHelper} />
			</StyledTableCell>
			<StyledTableCell align="center">{row.std_name}</StyledTableCell>
			<StyledTableCell align="center">{row.std_id}</StyledTableCell>
			<StyledTableCell align="center">{row.sec_name}</StyledTableCell>
			{/* <StyledTableCell align="center">{row.dept}</StyledTableCell> */}
		</StyledTableRow>
	);
};

export default CourseStudentTableRow;
