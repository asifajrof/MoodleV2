import React from 'react';
import Calendar from './calendar';
import RegisteredCourses from './registered_courses';

import './student_home.css';
import UpcomingEvents from './upcoming_events';

const StudentHome = ({studentNo}) => {
  return (
    <div className='home__container'>
      <UpcomingEvents studentNo={studentNo}/>
      <div className='home__container__divider'>
        <RegisteredCourses studentNo={studentNo}/>
        <Calendar studentNo={studentNo}/>
      </div>
    </div>
  )
}

export default StudentHome;
