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

const CourseCRTableRow = ({
	crIndex,
	adminNo,
	courseId,
	crObj,
	handleChangeSingle,
	checked,
}) => {
	function createData(crname, crid, sectionname) {
		return {
			crname,
			crid,
			sectionname,
		};
	}
	const row = createData(crObj.crname, crObj.crid, crObj.sectionname);

	const handleChangeSingleHelper = (event) => {
		handleChangeSingle(crIndex, event.target.checked);
	};
	return (
		<StyledTableRow>
			<StyledTableCell align="center">
				<Checkbox checked={checked} onChange={handleChangeSingleHelper} />
			</StyledTableCell>
			<StyledTableCell align="center">{row.crname}</StyledTableCell>
			<StyledTableCell align="center">{row.crid}</StyledTableCell>
			<StyledTableCell align="center">{row.sectionname}</StyledTableCell>
			{/* <StyledTableCell align="center">{row.dept}</StyledTableCell> */}
		</StyledTableRow>
	);
};

export default CourseCRTableRow;
