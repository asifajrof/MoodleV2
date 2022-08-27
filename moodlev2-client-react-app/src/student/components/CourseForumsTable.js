import React, { useEffect, useState } from "react";

import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";

import CourseForumTableRow from "./course_forums/course_forum_table_row";

// import './course_home.css';

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

const CourseForumsTable = ({ studentNo, courseId }) => {
	const [courseForumsList, setCourseForumsList] = useState([]);
	useEffect(() => {
		const fetchData = async (courseId) => {
			try {
				const response = await fetch(`/api/forum/course/${courseId}`);
				const jsonData = await response.json();
				setCourseForumsList(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData(courseId);
	}, [courseId]);

	return (
		<div style={{ width: "100%", paddingRight: "4rem" }}>
			{/* <CourseTopicsTable courseTopicList={courseTopicList}/> */}

			<TableContainer component={Paper}>
				<Table sx={{ minWidth: 700 }} aria-label="customized table">
					<TableHead>
						<TableRow>
							{/* <StyledTableCell align="center"> </StyledTableCell> */}
							{/* <StyledTableCell align="center"> </StyledTableCell> */}

							<StyledTableCell align="center">Started By</StyledTableCell>
							<StyledTableCell align="center">Discussion</StyledTableCell>
							<StyledTableCell align="center">Time</StyledTableCell>
							{/* <StyledTableCell align="center">Description</StyledTableCell> */}
						</TableRow>
					</TableHead>
					<TableBody>
						{courseForumsList.map((courseForum, index) => (
							<CourseForumTableRow
								key={index}
								courseForum={courseForum}
								courseId={courseId}
							/>
						))}
					</TableBody>
				</Table>
			</TableContainer>
		</div>
	);
};

export default CourseForumsTable;
