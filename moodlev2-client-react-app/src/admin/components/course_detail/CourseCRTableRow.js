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

const CourseCRTableRow = ({
  crIndex,
  adminNo,
  courseId,
  crObj,
  handleChangeSingle,
  checked,
}) => {
  function createData(name, cr_username, email, dept) {
    return {
      name,
      cr_username,
      email,
      dept,
    };
  }
  const row = createData(
    crObj.name,
    crObj.cr_username,
    crObj.email,
    crObj.dept
  );

  const handleChangeSingleHelper = (event) => {
    handleChangeSingle(crIndex, event.target.checked);
  };
  return (
    <StyledTableRow>
      <StyledTableCell align="center">
        <Checkbox checked={checked} onChange={handleChangeSingleHelper} />
      </StyledTableCell>
      <StyledTableCell align="center">{row.name}</StyledTableCell>
      <StyledTableCell align="center">{row.cr_username}</StyledTableCell>
      <StyledTableCell align="center">{row.email}</StyledTableCell>
      <StyledTableCell align="center">{row.dept}</StyledTableCell>
    </StyledTableRow>
  );
};

export default CourseCRTableRow;
