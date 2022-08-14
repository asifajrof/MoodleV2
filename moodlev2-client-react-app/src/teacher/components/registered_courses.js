import React, { useEffect, useState } from "react";
import RegisteredCourse from "./registered_courses/registered_course";

import "./registered_courses.css";

// const course_list = [
//     {
//         id: 1,
//         term: "January",
//         _year: 2022,
//         dept_shortname:"CSE",
//         course_code: "405",
//         course_name: "Computer Security"
//     }
//     ,
//     {
//         id: 2,
//         term: "January",
//         _year: 2022,
//         dept_shortname:"CSE",
//         course_code: "406",
//         course_name: "Computer Security Sessional"
//     }
//     ,
//     {
//         id: 3,
//         term: "January",
//         _year: 2022,
//         dept_shortname:"CSE",
//         course_code: "408",
//         course_name: "Software Development Sessional"
//     }
//     ,
//     {
//         id: 4,
//         term: "January",
//         _year: 2022,
//         dept_shortname:"CSE",
//         course_code: "409",
//         course_name: "Computer Graphics"
//     }
//     ,
//     {
//         id: 5,
//         term: "January",
//         _year: 2022,
//         dept_shortname:"CSE",
//         course_code: "423",
//         course_name: "FTS"
//     }
// ]

const RegisteredCourses = ({ userName }) => {
  // const [currentCoursesList, setCurrentCoursesList] = useState(course_list);
  const [currentCoursesList, setCurrentCoursesList] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(
          `/api/teacher/courses/current/${userName}`
        );
        const jsonData = await response.json();
        setCurrentCoursesList(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

  return (
    <div className="course__container">
      {currentCoursesList.map((course, index) => (
        <RegisteredCourse key={index} course={course} />
      ))}
    </div>
  );
};

export default RegisteredCourses;
