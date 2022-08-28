import React from "react";
import { Button } from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";

import Checkbox from "@mui/material/Checkbox";
import { Link } from "react-router-dom";

import ShowFile from "../../../shared/components/ShowFile";

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

export default function CourseEvaluationEventTableRow({
  courseEvaluationEvent,
  courseId,
}) {
  let dataIndex = 0;
  function createData(isfinished, title, description, id, date, fileLink) {
    dataIndex = dataIndex + 1;

    return {
      dataIndex,
      title,
      description,
      id,
      date,
      fileLink,
    };
  }
  const row = createData(
    courseEvaluationEvent.completed,
    courseEvaluationEvent.event_type,
    courseEvaluationEvent.event_description,
    courseEvaluationEvent.id,
    courseEvaluationEvent.event_date,
    courseEvaluationEvent.filelink
  );
  console.log(courseEvaluationEvent);
  // console.log(row);
  const linkto = `/course/${courseId}/event/${row.id}`;

  return (
    // <StyledTableRow style={{ cursor: "pointer" }}>
    <StyledTableRow>
      {/* <StyledTableCell align="center">{row.dataIndex}</StyledTableCell> */}
      <StyledTableCell align="center" component="th" scope="row">
        {/* <div onClick={onClickHandler(row.id)}>{row.title}</div> */}
        <Link to={linkto}>
          {row.title} <br></br> {row.date}
        </Link>
        {/* {row.title} */}
      </StyledTableCell>
      <StyledTableCell align="center">
        {/* <Link to={linkto}>{row.description}</Link> */}
        {row.description}
      </StyledTableCell>
      <StyledTableCell align="center">
        {row.fileLink === null ? (
          <div className="course__event__add">
            <Link to={`/course/${courseId}/event/${row.id}/addfile`}>
              <Button variant="contained" size="small">
                Add New
                <AddIcon />
              </Button>
            </Link>
          </div>
        ) : (
          <ShowFile fileID={row.id} />
        )}
      </StyledTableCell>
      <StyledTableCell align="center">
        <Link
          to={`/course/${courseId}/event/${courseEvaluationEvent.id}/submissions`}
        >
          <Button variant="outlined" size="small">
            See Submissions
          </Button>
        </Link>
      </StyledTableCell>
    </StyledTableRow>
  );
}
