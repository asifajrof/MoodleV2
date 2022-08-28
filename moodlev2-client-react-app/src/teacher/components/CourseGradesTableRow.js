import React from "react";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";

import Checkbox from "@mui/material/Checkbox";
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

const CourseGradesTableRow = ({ courseEventGrade, courseId }) => {
  // needed fields
  //     courseEventGrade.eventId
  //     courseEventGrade.eventType
  //     courseEventGrade.eventDate
  //     courseEventGrade.description
  const linkto = `/course/${courseId}/grade/event/${courseEventGrade.eventId}}`;

  return (
    <StyledTableRow>
      <StyledTableCell align="center" component="th" scope="row">
        <Link to={linkto}>
          {courseEventGrade.eventType} <br></br> {courseEventGrade.eventDate}
        </Link>
      </StyledTableCell>
      <StyledTableCell align="center">
        {courseEventGrade.description}
      </StyledTableCell>
      <StyledTableCell align="center">
        <Link to={linkto}>
          <Button variant="outlined" size="small">
            Grade
          </Button>
        </Link>
      </StyledTableCell>
    </StyledTableRow>
  );
};

export default CourseGradesTableRow;
