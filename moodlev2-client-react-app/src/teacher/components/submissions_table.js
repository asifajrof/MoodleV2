import React, { useEffect, useState } from "react";
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
import SubmissionsTableRow from "./submissions_table_row";

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

const SubmissionsTable = ({ userName, courseId, eventId }) => {
  const [submittedList, setSubmittedList] = useState([]);
  useEffect(() => {
    // fetch
    // const fetchData = async () => {
    //   try {
    //     const res = await fetch(`/api/course/events_teacher`, {
    //       method: "POST",
    //       headers: {
    //         "Content-type": "application/json",
    //       },
    //       body: JSON.stringify({ userName, courseId }),
    //     });
    //     const jsonData = await res.json();
    //     // console.log(data);
    //     // console.log(res.status);
    //     if (res.status === 200) {
    //       setCourseEvaluationEventList(jsonData.data);
    //       // console.log(jsonData.data);
    //     } else {
    //       // alert(data.message);
    //       console.log(jsonData.message);
    //     }
    //   } catch (err) {
    //     console.log(err);
    //     // alert(err);
    //   }
    // };
    // fetchData();
  }, []);
  return (
    <div style={{ width: "100%", paddingRight: "4rem" }}>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 700 }} aria-label="customized table">
          <TableHead>
            <TableRow>
              {/* <StyledTableCell align="center"> </StyledTableCell> */}
              <StyledTableCell align="center">Student ID</StyledTableCell>
              <StyledTableCell align="center">File</StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {submittedList.map((submitted, index) => (
              <SubmissionsTableRow
                key={index}
                submittedInfo={submitted}
                courseId={courseId}
                eventId={eventId}
              />
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
};

export default SubmissionsTable;
