import React, { useEffect, useState } from "react";

import { styled } from "@mui/material/styles";
import Table from "@mui/material/Table";
import TableBody from "@mui/material/TableBody";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableContainer from "@mui/material/TableContainer";
import TableHead from "@mui/material/TableHead";
import TableRow from "@mui/material/TableRow";
import Paper from "@mui/material/Paper";

import CourseGradeUpdateRow from "./CourseGradeUpdateRow";
import { Button } from "@mui/material";

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

const TeacherCourseGradeUpdate = ({ userName, courseId, eventId }) => {
  const [studentList, setStudentList] = useState([]);
  // const [markList, setMarkList] = useState([]);
  let markList = [];
  const setMarkList = (newMarkList) => {
    markList = [];
    for (let i = 0; i < newMarkList.length; i++) {
      markList.push(newMarkList[i]);
    }
  };
  const createMarkList = (studentList) => {
    let newMarkList = [];
    for (let i = 0; i < studentList.length; i++) {
      newMarkList.push({
        studentId: studentList[i].id,
        mark: 0,
      });
    }
    setMarkList(newMarkList);
  };
  const updateMarkList = (studentId, mark) => {
    let newMarkList = [...markList];
    for (let i = 0; i < newMarkList.length; i++) {
      if (newMarkList[i].studentId === studentId) {
        newMarkList[i].mark = mark;
      }
    }
    setMarkList(newMarkList);
  };

  // fetch here
  // useEffect(() => {
  //     const fetchData = async () => {
  //       try {
  //         const response = await fetch(`/api/course/topics/${courseId}`);
  //         const jsonData = await response.json();
  //         setStudentList(jsonData.data);
  //         createMarkList(jsonData.data);
  //       } catch (err) {
  //         console.log(err);
  //       }
  //     };
  //     fetchData();
  //   }, []);

  const onMarkSubmit = (e) => {
    e.preventDefault();
    console.log("onMarkSubmit", markList);
  };
  const onChangeMark = (studentId, mark) => {
    updateMarkList(studentId, mark);
  };
  return (
    <div className="course__event__submission">
      <div className="course__event__submission__info">
        <form onSubmit={onMarkSubmit}>
          <div style={{ width: "100%", paddingRight: "4rem" }}>
            <TableContainer component={Paper}>
              <Table sx={{ minWidth: 700 }} aria-label="customized table">
                <TableHead>
                  <TableRow>
                    <StyledTableCell align="center">Student ID</StyledTableCell>
                    <StyledTableCell align="center">Mark</StyledTableCell>
                  </TableRow>
                </TableHead>
                <TableBody>
                  {studentList.map((student, index) => (
                    <CourseGradeUpdateRow
                      key={index}
                      student={student}
                      courseId={courseId}
                      eventId={eventId}
                      onChangeMark={onChangeMark}
                      onMarkSubmit={onMarkSubmit}
                    />
                  ))}
                </TableBody>
              </Table>
            </TableContainer>
          </div>
          <Button type="submit" variant="contained" color="primary">
            Done
          </Button>
        </form>
      </div>
    </div>
  );
};

export default TeacherCourseGradeUpdate;
