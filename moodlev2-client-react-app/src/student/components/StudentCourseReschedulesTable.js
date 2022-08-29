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
import React, { useState, useEffect } from "react";

import StudentCourseReschedulesTableRow from "./StudentCourseReschedulesTableRow";

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

const StudentCourseReschedulesTable = ({ studentNo, courseId }) => {
  const [rescheduleList, setRescheduleList] = useState([]);

  // fetch here to get list of reschedule event list

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch(`/api/reschedule/view/student`, {
          method: "POST",
          headers: {
            "Content-type": "application/json",
          },
          body: JSON.stringify({ studentNo, courseId }),
        });
        const jsonData = await res.json();
        // console.log(data);
        // console.log(res.status);
        if (res.status === 200) {
          setRescheduleList(jsonData.data);
          // console.log(jsonData.data);
        } else {
          // alert(data.message);
          console.log(jsonData.message);
        }
      } catch (err) {
        console.log(err);
        // alert(err);
      }
    };
    fetchData();
  }, []);

  return (
    <div style={{ width: "100%", paddingRight: "4rem" }}>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 700 }} aria-label="customized table">
          <TableHead>
            <TableRow>
              <StyledTableCell align="center">Event Type</StyledTableCell>
              <StyledTableCell align="center">Date</StyledTableCell>
              <StyledTableCell align="center">Section Name</StyledTableCell>
              <StyledTableCell align="center">Teacher Name</StyledTableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {rescheduleList.map((rescheduleEvent, index) => (
              <StudentCourseReschedulesTableRow
                key={index}
                rescheduleEvent={rescheduleEvent}
                courseId={courseId}
              />
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </div>
  );
};

export default StudentCourseReschedulesTable;
