import React from "react";
import moment from "moment";

import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";
import { Link } from "react-router-dom";
// import moment from "moment";
// import Checkbox from "@mui/material/Checkbox";

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

// const rows = [
//     createData(  <Checkbox disabled checked />, 'loop', 'for while do while and bla bla'),
//     createData(  <Checkbox disabled />, 'array', 'something about array'),
// ];

export default function CourseForumTableRow({ courseForum, courseId }) {
	let dataIndex = 0;
	function createData(teacherName, topicName, startTime, postID) {
		dataIndex = dataIndex + 1;
		// let checkBox;
		// if (isfinished) {
		// 	checkBox = <Checkbox disabled checked />;
		// } else {
		// 	checkBox = <Checkbox disabled />;
		// }
		startTime = moment(startTime).format("LLL");

		return {
			dataIndex,
			teacherName,
			topicName,
			startTime,
			postID,
		};
	}
	// console.log(courseForum);
	const row = createData(
		courseForum.postername,
		courseForum.title,
		courseForum.posttime,
		courseForum.postid
	);

	// console.log("postID : ", courseForum.postid);

	const linkto = `/course/${courseId}/forum/${row.postID}`;

	return (
		<StyledTableRow>
			{/* <StyledTableCell align="center">{row.checkBox}</StyledTableCell> */}
			{/* <StyledTableCell align="center">{row.dataIndex}</StyledTableCell> */}
			<StyledTableCell align="center">{row.teacherName}</StyledTableCell>
			<StyledTableCell align="center" component="th" scope="row">
				<Link to={linkto}>{row.topicName}</Link>
			</StyledTableCell>
			<StyledTableCell align="center">{row.startTime}</StyledTableCell>
		</StyledTableRow>
	);
}
