import React, { useEffect, useState } from "react";
import RegisteredCourse from "./registered_courses/registered_course";

// import "./registered_courses.css";

const AllRegisteredCourses = ({ studentNo }) => {
  // const [currentCoursesList, setCurrentCoursesList] = useState(course_list);
  const [allCoursesList, setAllCoursesList] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/student/courses/all/${studentNo}`);
        const jsonData = await response.json();
        setAllCoursesList(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

  return (
    <div className="course__container">
      {allCoursesList.map((course, index) => (
        <RegisteredCourse key={index} course={course} />
      ))}
    </div>
  );
};

export default AllRegisteredCourses;
