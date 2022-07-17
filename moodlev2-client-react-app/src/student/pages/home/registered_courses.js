import React from "react";
import RegisteredCourse from "./registered_courses/registered_course";

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
        id: 2,
        term: "January",
        _year: 2022,
        dept_shortname:"CSE",
        course_code: "408",
        course_name: "Software Development Sessional"
    }
]



const RegisteredCourses = ({studentNo}) => {
    const getList = (studentNo) =>
    {
        return course_list;
    }
    const student_course_list=getList(studentNo);
    return (
        <>
            {student_course_list.map( course => (
                <RegisteredCourse course={course} />
            ))}
        </>
    )
}