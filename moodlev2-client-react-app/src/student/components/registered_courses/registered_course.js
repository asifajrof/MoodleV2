import React from "react";

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
    return (
        <div className='course__container__item'>
            <div className='course__container__item__1'>
            {course.term} {course._year} {course.dept_shortname}{course.course_code}: {course.course_name}
            </div>
        </div>
    )
}
export default RegisteredCourse;