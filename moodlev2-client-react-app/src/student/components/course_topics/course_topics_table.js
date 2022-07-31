import React, { useEffect, useState }  from 'react';
import { styled } from '@mui/material/styles';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import Checkbox from '@mui/material/Checkbox';

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
  '&:nth-of-type(odd)': {
    backgroundColor: theme.palette.action.hover,
  },
  // hide last border
  '&:last-child td, &:last-child th': {
    border: 0,
  },
}));

let dataIndex = 0;
function createData(isfinished, topicName, topicDescription) {
    dataIndex = dataIndex +1;
    let checkBox;
    if(isfinished){
        checkBox = <Checkbox disabled checked />;
    } else {
        checkBox = <Checkbox disabled />;
    }
     
  return { dataIndex, checkBox, topicName, topicDescription};
}

// const rows = [
//     createData(  <Checkbox disabled checked />, 'loop', 'for while do while and bla bla'),
//     createData(  <Checkbox disabled />, 'array', 'something about array'),
// ];

export default function CourseTopicsTable({courseTopicList}) {
    console.log(courseTopicList)
    const [rows, setRows] = useState([]);
    
    useEffect(() => {
        // courseTopicList.array.forEach(courseTopic => {
        //     setRows([...rows, createData(courseTopic.isfinished, courseTopic.title, courseTopic.topic_description)]);
        // });
        courseTopicList.map((courseTopic, index) => {
            console.log(`coursetopiclist map index ${index}`);
            setRows([...rows, createData(courseTopic.isfinished, courseTopic.title, courseTopic.topic_description)]);
        });
    }, []);
  return (
    <TableContainer component={Paper}>
      <Table sx={{ minWidth: 700 }} aria-label="customized table">
        <TableHead>
          <TableRow>
            <StyledTableCell> </StyledTableCell>
            <StyledTableCell> </StyledTableCell>
            <StyledTableCell>Topic Name</StyledTableCell>
            <StyledTableCell align="center">Description</StyledTableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {rows.map((row, index) => (
            <StyledTableRow key={index}>
              <StyledTableCell align="center">{row.checkBox}</StyledTableCell>
              <StyledTableCell align="center">{row.dataIndex}</StyledTableCell>
              <StyledTableCell component="th" scope="row">
                {row.topicName}
              </StyledTableCell>
              <StyledTableCell align="center">{row.topicDescription}</StyledTableCell>
            </StyledTableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
}
