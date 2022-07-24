import React from "react";
import { Link } from "react-router-dom";

import './registered_course.css';

// const course = {
//         id: 1,
//         term: "January",
//         _year: 2022,
//         dept_shortname:"CSE",
//         course_code: "405",
//         course_name: "Computer Security"
//     }

const RegisteredCourse = ({course})=>{
    // const courseLink = `/course/${course._year}-${course.term}-${course.dept_shortname}-${course.course_code}`;
    const courseLink = `/course/${course.id}`;
    return (
        <div className='course__container__item'>
            <Link to={courseLink} state={{courseId: course.id}}>
            <div className='course__container__item__1'>
            {course.term} {course._year} {course.dept_shortname}{course.course_code}: {course.course_name}
            </div>
            </Link>
        </div>
    )
}
export default RegisteredCourse;