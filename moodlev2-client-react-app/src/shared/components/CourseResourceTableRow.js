import React from "react";
import moment from "moment";

import { styled } from "@mui/material/styles";
import TableCell, { tableCellClasses } from "@mui/material/TableCell";
import TableRow from "@mui/material/TableRow";
// import moment from "moment";
// import Checkbox from "@mui/material/Checkbox";

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

export default function CourseResourceTableRow({ courseResource, courseId }) {
  let dataIndex = 0;
  function createData(title, fileID, uploader, uploadTime) {
    uploadTime = moment(uploadTime).format("LLL");

    return {
      title,
      fileID,
      uploader,
      uploadTime,
    };
  }
  const row = createData(
    courseResource.title,
    courseResource.fileID,
    courseResource.uploader,
    courseResource.uploadTime
  );

  const linkto = `/course/${courseId}/forum/${row.postID}`;

  return (
    <StyledTableRow>
      <StyledTableCell align="center">{row.title}</StyledTableCell>
      <StyledTableCell align="center">
        {/*<ShowFile fileID={row.id} />*/}{" "}
      </StyledTableCell>
      <StyledTableCell align="center">
        {row.uploader}
        <br />
        {row.uploadTime}
      </StyledTableCell>
    </StyledTableRow>
  );
}
