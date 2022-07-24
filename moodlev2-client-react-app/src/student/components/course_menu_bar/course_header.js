import React from 'react'

import './course_header.css';

const CourseHeader = (props) => {
  return (
    <header className='course-header'>
        {props.children}
    </header>
  );
};

export default CourseHeader;
