import React, { useEffect, useState } from "react";

import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";

import CourseResourceTableRow from "./CourseResourceTableRow";

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

const CourseResourceTable = ({ userName, uType, courseId }) => {
  const [courseResourceList, setCourseResourceList] = useState([]);
  // fetch resource here
  //   useEffect(() => {
  //     const fetchData = async (courseId) => {
  //       try {
  //         const response = await fetch(`/api/forum/course/${courseId}`);
  //         const jsonData = await response.json();
  //         setCourseResourceList(jsonData.data);
  //       } catch (err) {
  //         console.log(err);
  //       }
  //     };
  //     fetchData(courseId);
  //   }, [courseId]);

  return (
    <div style={{ width: "100%", paddingRight: "4rem" }}>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 700 }} aria-label="customized table">
          <TableHead>
            <TableRow>
              <StyledTableCell align="center">Title</StyledTableCell>
              <StyledTableCell align="center">File</StyledTableCell>
              <StyledTableCell align="center">Uploader</StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {courseResourceList.map((courseResource, index) => (
              <CourseResourceTableRow
                key={index}
                uType={uType}
                courseResource={courseResource}
                courseId={courseId}
              />
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
};

export default CourseResourceTable;
