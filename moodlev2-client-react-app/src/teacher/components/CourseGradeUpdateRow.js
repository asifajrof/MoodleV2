import React, { useState } from "react";
import { Button, TextField } from "@mui/material";
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

const CourseGradeUpdateRow = ({
  student,
  courseId,
  eventId,
  onChangeMark,
  onMarkSubmit,
}) => {
  const [mark, setMark] = useState(student.mark);
  // needed fields
  //     student.id
  //     student.mark
  return (
    <StyledTableRow>
      <StyledTableCell align="center" component="th" scope="row">
        {student.id}
      </StyledTableCell>
      <StyledTableCell align="center">
        <TextField
          fullWidth
          type="number"
          id="marks"
          label="Marks"
          variant="outlined"
          value={mark}
          onChange={(e) => {
            setMark(e.target.value);
            onChangeMark(student.id, e.target.value);
          }}
        />
      </StyledTableCell>
    </StyledTableRow>
  );
};

export default CourseGradeUpdateRow;
