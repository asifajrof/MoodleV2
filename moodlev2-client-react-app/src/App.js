import React from 'react';
// import { BrowserRouter as Router, Route, Navigate, Routes, Link } from 'react-router-dom';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

// import logo from './logo.svg';
import UserHome from './UserHome';
import Timeline from './Timeline';
import Courses from './Courses';
import PrivateFiles from './PrivateFiles';
import SiteNews from './SiteNews';

import AdminCourses from './admin/pages/AdminCourses';
import AdminTeachers from './admin/pages/AdminTeachers';
import AdminStudents from './admin/pages/AdminStudents';
import AdminSiteNews from './admin/pages/AdminSiteNews';

import './App.css';
import MenuBar from './student/components/menu_bar';

const App = () => {
  const userType = 'student';
  const navLinksLists = [
    [
      {
        linkTo: '/admin/courses',
        text: 'Courses',
        target: <AdminCourses userType={userType}/>
      },
      {
        linkTo: '/admin/teachers',
        text: 'Teachers',
        target: <AdminTeachers userType={userType}/>
      },
      {
        linkTo: '/admin/students',
        text: 'Students',
        target: <AdminStudents userType={userType}/>
      },
      {
        linkTo: '/admin/sitenews',
        text: 'Site News',
        target: <AdminSiteNews userType={userType}/>
      }
    ],
    [
      {
        linkTo: '/timeline',
        text: 'Timeline',
        target: <Timeline userType={userType}/>
      },
      {
        linkTo: '/courses',
        text: 'Courses',
        target: <Courses userType={userType}/>
      },
      {
        linkTo: '/privatefiles',
        text: 'Private Files',
        target: <PrivateFiles userType={userType}/>
      },
      {
        linkTo: '/sitenews',
        text: 'Site News',
        target: <SiteNews userType={userType}/>
      }
    ]
  ];

  const navLinksList = userType === 'admin' ? navLinksLists[0] : userType === 'student' || userType === 'teacher' ? navLinksLists[1] : [];

  return (
    <Router>
      {/* <MainNavigation userType={userType} navLinksList={navLinksList}/> */}
      <MenuBar studentNo={1} />

      <main>
        {/* <Routes>
          <Route exact path='/' element={<UserHome userType={userType}/>}/>
          {
            navLinksList.map((navLink) => (
              <Route exact path={navLink.linkTo} element={navLink.target} />
            ))
          }
        </Routes> */}
        <h1>hi</h1>
      </main>
    </Router>
  );
};

export default App;
