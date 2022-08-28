import React from "react";
import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";
import moment from "moment";

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

export default function TeacherCourseReschedulesTableRow({
  rescheduleEvent,
  courseId,
}) {
  function createData(type, start, end, section, teacher) {
    const startFormatted = moment(start).format("LLL");
    const endFormatted = moment(end).format("h:mm a");
    const date = `${startFormatted} - ${endFormatted}`;
    return {
      type,
      date,
      section,
      teacher,
    };
  }
  const row = createData(
    rescheduleEvent.eventType,
    rescheduleEvent.eventStartTime,
    rescheduleEvent.eventEndTime,
    rescheduleEvent.eventSectionName,
    rescheduleEvent.eventTeacherName
  );

  return (
    <StyledTableRow>
      <StyledTableCell align="center" component="th" scope="row">
        {row.type}
      </StyledTableCell>
      <StyledTableCell align="center">{row.date}</StyledTableCell>
      <StyledTableCell align="center">{row.section}</StyledTableCell>
      <StyledTableCell align="center">{row.teacher}</StyledTableCell>
    </StyledTableRow>
  );
}
