import React from "react";

const course = {
        id: 1,
        term: "January",
        _year: 2022,
        dept_shortname:"CSE",
        course_code: "405",
        course_name: "Computer Security"
    }

const RegisteredCourse = ({course})=>{
    return (
        <>
        {course.term} {course._year} {course.dept_shortname}{course_code}: {course.course_name}
        </>
    )
}
export default RegisteredCourse;