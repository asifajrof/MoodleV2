import React from 'react';
import { useLocation, useParams } from 'react-router-dom';

import './course_home.css';

const StudentCourseHome = ({studentNo}) => {
    const params = useParams();
    const courseId = params.courseId;
    // console.log(params);
    
    // // problem with this is i can not directly go into the link. i have to navigate through the prev pages
    // const loc = useLocation();
    // const {courseId} = loc.state;
    // // console.log(courseId);

  return (
    <div className='course__home__container'>
    <h1>student no: {studentNo}</h1>
    <h2>course Id: {courseId}</h2>
    </div>
  )
}

export default StudentCourseHome;
