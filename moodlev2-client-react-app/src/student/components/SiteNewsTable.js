import React, { useEffect, useState } from "react";

import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";

import SiteNewsTableRow from "./site_news/site_news_table_row";

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

const SiteNewsTable = ({ studentNo }) => {
	const [siteNewsList, setSiteNewsList] = useState([]);
	useEffect(() => {
		const fetchData = async () => {
			try {
				const response = await fetch(`/api/forum/sitenews`);
				const jsonData = await response.json();
				setSiteNewsList(jsonData.data);
			} catch (err) {
				console.log(err);
			}
		};
		fetchData();
	});

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
						{siteNewsList.map((siteNews, index) => (
							<SiteNewsTableRow key={index} siteNews={siteNews} />
						))}
					</TableBody>
				</Table>
			</TableContainer>
		</div>
	);
};

export default SiteNewsTable;
