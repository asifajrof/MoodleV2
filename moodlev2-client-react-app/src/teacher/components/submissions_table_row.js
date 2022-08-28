import React from "react";
import { Button } from "@mui/material";
import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";
import FileEdit from "./file_edit/FileEdit";

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

const SubmissionsTableRow = ({ submittedInfo, courseId, eventId }) => {
	function createData(studentID, fileID) {
		return {
			studentID,
			fileID,
		};
	}
	// console.log(submittedInfo);
	const row = createData(submittedInfo.studentID, submittedInfo.fileID);
	return (
		<StyledTableRow>
			<StyledTableCell align="center" component="th" scope="row">
				{row.studentID}
			</StyledTableCell>
			<StyledTableCell align="center">
				<FileEdit fileID={row.fileID} />
			</StyledTableCell>
		</StyledTableRow>
	);
};

export default SubmissionsTableRow;
