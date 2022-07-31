import React, {useEffect, useState} from "react";

import { styled } from '@mui/material/styles';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell, { tableCellClasses } from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableHead from '@mui/material/TableHead';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';

import CourseTopicTableRow from "./course_topics/course_topic_table_row";

// import './course_topics.css';

const StyledTableCell = styled(TableCell)(({ theme }) => ({
    [`&.${tableCellClasses.head}`]: {
      backgroundColor: theme.palette.common.black,
      color: theme.palette.common.white,
    },
    [`&.${tableCellClasses.body}`]: {
      fontSize: 14,
    },
}));

// const StyledTableRow = styled(TableRow)(({ theme }) => ({
//     '&:nth-of-type(odd)': {
//     backgroundColor: theme.palette.action.hover,
//     },
//     // hide last border
//     '&:last-child td, &:last-child th': {
//     border: 0,
//     },
// }));

const CourseTopics = ({studentNo, courseId}) => {
    // const [currentCoursesList, setCurrentCoursesList] = useState(course_list);
    const [courseTopicList, setCourseTopicList] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch(`/api/course/topics/${courseId}`);
                const jsonData = await response.json();
                setCourseTopicList(jsonData.data);
            } catch (err) {
                console.log(err);
            }
        };
        fetchData();
    }, []);

    return (
        // <div className='course__container'>
        //     {currentCoursesList.map( (course, index) => (
        //         <RegisteredCourse key={index} course={course} />
        //     ))}
        // </div>
        <div style={{ width:'100%', paddingRight: '4rem' }}>
            {/* <CourseTopicsTable courseTopicList={courseTopicList}/> */}

            <TableContainer component={Paper}>
            <Table sx={{ minWidth: 700 }} aria-label="customized table">
                <TableHead>
                <TableRow>
                    <StyledTableCell> </StyledTableCell>
                    <StyledTableCell> </StyledTableCell>
                    <StyledTableCell align="center">Teacher</StyledTableCell>
                    <StyledTableCell>Topic Name</StyledTableCell>
                    <StyledTableCell align="center">Posted</StyledTableCell>
                    <StyledTableCell align="center">Description</StyledTableCell>
                </TableRow>
                </TableHead>
                <TableBody>
                {courseTopicList.map((courseTopic, index) =>(
                    <CourseTopicTableRow key={index} courseTopic={courseTopic}/>
                ))}
                </TableBody>
            </Table>
            </TableContainer>
        </div>
    )
}

export default CourseTopics;
