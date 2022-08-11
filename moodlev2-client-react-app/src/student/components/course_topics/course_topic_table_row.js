import React from "react";

import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";

import Checkbox from "@mui/material/Checkbox";

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

// const rows = [
//     createData(  <Checkbox disabled checked />, 'loop', 'for while do while and bla bla'),
//     createData(  <Checkbox disabled />, 'array', 'something about array'),
// ];

export default function CourseTopicTableRow({ courseTopic }) {
  let dataIndex = 0;
  function createData(
    isfinished,
    teacherName,
    topicName,
    startTime,
    topicDescription
  ) {
    dataIndex = dataIndex + 1;
    let checkBox;
    if (isfinished) {
      checkBox = <Checkbox disabled checked />;
    } else {
      checkBox = <Checkbox disabled />;
    }

    return {
      dataIndex,
      checkBox,
      teacherName,
      topicName,
      startTime,
      topicDescription,
    };
  }
  const row = createData(
    courseTopic.isfinished,
    courseTopic.teachername,
    courseTopic.title,
    courseTopic.start_time,
    courseTopic.topic_description
  );

  return (
    <StyledTableRow>
      <StyledTableCell align="center">{row.checkBox}</StyledTableCell>
      <StyledTableCell align="center">{row.dataIndex}</StyledTableCell>
      <StyledTableCell align="center">{row.teacherName}</StyledTableCell>
      <StyledTableCell align="center" component="th" scope="row">
        {row.topicName}
      </StyledTableCell>
      <StyledTableCell align="center">{row.startTime}</StyledTableCell>
      <StyledTableCell align="center">{row.topicDescription}</StyledTableCell>
    </StyledTableRow>
  );
}
