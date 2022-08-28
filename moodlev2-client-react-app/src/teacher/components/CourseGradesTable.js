import React, { useEffect, useState } from "react";

import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";

import CourseGradesTableRow from "./CourseGradesTableRow";

// import './course_topics.css';

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

const CourseGradesTable = ({ userName, courseId }) => {
  const [courseEventGradesList, setCourseEventGradesList] = useState([]);

  // fetch here
  // useEffect(() => {
  //     const fetchData = async () => {
  //       try {
  //         const response = await fetch(`/api/course/topics/${courseId}`);
  //         const jsonData = await response.json();
  //         setCourseEventGradesList(jsonData.data);
  //       } catch (err) {
  //         console.log(err);
  //       }
  //     };
  //     fetchData();
  //   }, []);
  return (
    <div style={{ width: "100%", paddingRight: "4rem" }}>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 700 }} aria-label="customized table">
          <TableHead>
            <TableRow>
              <StyledTableCell align="center">Event Type</StyledTableCell>
              <StyledTableCell align="center">Description</StyledTableCell>
              <StyledTableCell align="center">Grades</StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {courseEventGradesList.map((courseEventGrade, index) => (
              <CourseGradesTableRow
                key={index}
                courseEventGrade={courseEventGrade}
                courseId={courseId}
              />
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
};

export default CourseGradesTable;
