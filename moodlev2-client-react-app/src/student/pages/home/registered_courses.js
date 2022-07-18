import React from "react";
import RegisteredCourse from "./registered_courses/registered_course";

import './registered_courses.css';

const course_list = [
    {
        id: 1,
        term: "January",
        _year: 2022,
        dept_shortname:"CSE",
        course_code: "405",
        course_name: "Computer Security"
    }
    ,
    {
        id: 2,
        term: "January",
        _year: 2022,
        dept_shortname:"CSE",
        course_code: "406",
        course_name: "Computer Security Sessional"
    }
    ,
    {
        id: 3,
        term: "January",
        _year: 2022,
        dept_shortname:"CSE",
        course_code: "408",
        course_name: "Software Development Sessional"
    }
    ,
    {
        id: 4,
        term: "January",
        _year: 2022,
        dept_shortname:"CSE",
        course_code: "409",
        course_name: "Computer Graphics"
    }
]



const RegisteredCourses = ({studentNo}) => {
    const getList = (studentNo) =>
    {
        return course_list;
    }
    const student_course_list=getList(studentNo);
    return (
        <div className='course__container'>
            {student_course_list.map( (course, index) => (
                <RegisteredCourse key={index} course={course} />
            ))}
        </div>
    )
}

export default RegisteredCourses;
