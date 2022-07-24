import React, { useState, useEffect } from 'react';
// import { useLocation } from 'react-router-dom';
import { useParams } from 'react-router-dom';

import CourseMenuBar from '../components/course_menu_bar';
import './course_home.css';

const StudentCourseHome = ({studentNo}) => {
  const [courseInfo, setcourseInfo] = useState([]);
  const params = useParams();
  const courseId = params.courseId;
  
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/course/${courseId}`);
        const jsonData = await response.json();
        setcourseInfo(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

  return (
    <React.Fragment>
    <CourseMenuBar studentNo={studentNo} courseId={courseId}/>
    <div className='course__home__container'>
      <div className='course__container__item__1'>
      term {courseInfo.term} year {courseInfo._year} shortname {courseInfo.dept_shortname}code{courseInfo.course_code}: name{courseInfo.course_name}
      </div>
      <div className='course__home__container__divider'>
        <h1>student no: {studentNo}</h1>
        <h2>course Id: {courseId}</h2>
      </div>
    </div>
    </React.Fragment>
  );
};

export default StudentCourseHome;
