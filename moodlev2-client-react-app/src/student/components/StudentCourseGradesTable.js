import React, { useEffect, useState } from "react";

import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";

import StudentCourseGradesTableRow from "./StudentCourseGradesTableRow";

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

const StudentCourseGradesTable = ({ studentNo, courseId }) => {
  const [courseEventGradesList, setCourseEventGradesList] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      console.log("std id", studentNo);
      try {
        const res = await fetch(`/api/student/course/grade`, {
          method: "POST",
          headers: {
            "Content-type": "application/json",
          },
          body: JSON.stringify({ studentId: studentNo, courseId }),
        });
        const jsonData = await res.json();
        // console.log(data);
        // console.log(res.status);
        if (res.status === 200) {
          setCourseEventGradesList(jsonData.data);
          // console.log(jsonData.data);
        } else {
          // alert(data.message);
          console.log(jsonData.message);
        }
      } catch (err) {
        console.log(err);
        // alert(err);
      }
    };
    fetchData();
  }, []);
  return (
    <div style={{ width: "100%", paddingRight: "4rem" }}>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 700 }} aria-label="customized table">
          <TableHead>
            <TableRow>
              <StyledTableCell align="center">Event Type</StyledTableCell>
              <StyledTableCell align="center">Obtained Mark</StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {courseEventGradesList.map((courseEventGrade, index) => (
              <StudentCourseGradesTableRow
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

export default StudentCourseGradesTable;
