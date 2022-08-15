import {
  Paper,
  Table,
  TableBody,
  TableContainer,
  TableHead,
  TableRow,
} from "@mui/material";
import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import React, { useState } from "react";
import CourseEvaluationEventTableRow from "./course_evaluation_events/course_evaluation_event_table_row";

const courseEvaluationEventListInit = [
  {
    id: 1,
    title: "HW 1",
    description: "Homework on Chapter 1",
    isFinished: false,
  },
];

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

const CourseEvaluationEvents = ({ studentNo, courseId }) => {
  // const [courseEvaluationEventList, setCourseEvaluationEventList] = useState(
  //   []
  // );
  const [courseEvaluationEventList, setCourseEvaluationEventList] = useState(
    courseEvaluationEventListInit
  );

  // useEffect(() => {
  //   const fetchData = async () => {
  //     try {
  //       const response = await fetch(`/api/course/events/${courseId}`);
  //       const jsonData = await response.json();
  //       setCourseEvaluationEventList(jsonData.data);
  //     } catch (err) {
  //       console.log(err);
  //     }
  //   };
  //   fetchData();
  // }, []);

  const onClickHandler = (id) => {
    console.log("click na hoitei?");
    console.log(id);
  };

  return (
    <div style={{ width: "100%", paddingRight: "4rem" }}>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 700 }} aria-label="customized table">
          <TableHead>
            <TableRow>
              <StyledTableCell align="center"> </StyledTableCell>
              <StyledTableCell align="center">Topic Name</StyledTableCell>
              <StyledTableCell align="center">Description</StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {courseEvaluationEventList.map((courseEvaluationEvent, index) => (
              <CourseEvaluationEventTableRow
                key={index}
                courseEvaluationEvent={courseEvaluationEvent}
                courseId={courseId}
                onClickHandler={onClickHandler}
              />
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
};

export default CourseEvaluationEvents;
