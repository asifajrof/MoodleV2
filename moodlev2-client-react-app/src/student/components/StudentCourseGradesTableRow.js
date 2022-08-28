import React from "react";
import moment from "moment";
import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";

import { Link } from "react-router-dom";

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

const StudentCourseGradesTableRow = ({ courseEventGrade, courseId }) => {
  const linkto = `/course/${courseId}/grade/event/${courseEventGrade.eventId}`;

  return (
    <StyledTableRow>
      <StyledTableCell align="center" component="th" scope="row">
        {/* <Link to={linkto}> */}
        {courseEventGrade.eventName} <br></br>{" "}
        {moment(courseEventGrade.event_ended).format("LLL")}
        {/* </Link> */}
      </StyledTableCell>
      <StyledTableCell align="center">
        {courseEventGrade.marks} / {courseEventGrade.totalMarks}
      </StyledTableCell>
    </StyledTableRow>
  );
};

export default StudentCourseGradesTableRow;
