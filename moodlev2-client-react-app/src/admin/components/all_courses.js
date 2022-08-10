import React, {useEffect, useState} from "react";
import Course from "./all_courses/course";
import { Button } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { Link } from "react-router-dom";

// import './registered_courses.css';

const AllCourses = ({adminNo}) => {
    // const [currentCoursesList, setCurrentCoursesList] = useState(course_list);
    const [allCoursesList, setAllCoursesList] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch(`/api/admin/courses/all`);
                const jsonData = await response.json();
                setAllCoursesList(jsonData.data);
                // console.log(jsonData.data);
            } catch (err) {
                console.log(err);
            }
        };
        fetchData();
    }, []);

    return (
        <div className='course__container'>
            <div className='course__container__add'>
            <Link to='/courses/addnew'>
                <Button variant="contained">
                    Add New<AddIcon />
                </Button>
            </Link>
            </div>
            {allCoursesList.map( (course, index) => (
                <Course key={index} course={course} />
            ))}
        </div>
    )
}

export default AllCourses;
