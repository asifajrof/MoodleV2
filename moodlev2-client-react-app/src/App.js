import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

// import UserHome from './UserHome';
// import Timeline from './Timeline';
// import Courses from './Courses';
// import PrivateFiles from './PrivateFiles';
// import SiteNews from './SiteNews';

// import AdminCourses from './admin/pages/AdminCourses';
// import AdminTeachers from './admin/pages/AdminTeachers';
// import AdminStudents from './admin/pages/AdminStudents';
// import AdminSiteNews from './admin/pages/AdminSiteNews';

import StudentMenuBar from './student/components/menu_bar';
import StudentHome from './student/pages/home/student_home';

import './App.css';

import { home_link } from './links';

const App = () => {
  const userType = 'student';
  
  if(userType === 'admin') {
    return (
      <Router>
        <h1>admin menu bar here</h1>
        <main>
          {/* <Routes>
            <Route path='/' element={something} />
          </Routes> */}
        </main>
      </Router>
    );

  } else if(userType === 'student') {
    return (
      <Router>
        <StudentMenuBar studentNo={1}/>
        <main>
          <Routes>
            <Route path={home_link} element={<StudentHome studentNo={1}/>} />
          </Routes>
        </main>
      </Router>
    );

  } else if(userType === 'teacher') {
    return (
      <Router>
        <h1>teacher menu bar here</h1>
        <main>
          {/* <Routes>
            <Route path='/' element={something} />
          </Routes> */}
        </main>
      </Router>
    );
  } else {
    return (
      <Router>
        <h1>nologin menu bar here</h1>
        <main>
          {/* <Routes>
            <Route path='/' element={something} />
          </Routes> */}
        </main>
      </Router>
    );
  }
};

export default App;
