import React, { useState, useEffect } from "react";
// import React from "react";
import {
  BrowserRouter as Router,
  Navigate,
  Route,
  Routes,
} from "react-router-dom";

import StudentMenuBar from "./student/components/menu_bar";
import StudentHome from "./student/pages/student_home";
import StudentCourseHome from "./student/pages/course_home";

import AdminMenuBar from "./admin/components/menu_bar";
import AdminHome from "./admin/pages/AdminHome";
import AddNewCourse from "./admin/pages/AddNewCourse";
import DeptAddForm from "./admin/components/add_dept";

import BlankMenuBar from "./shared/components/BlankMenuBar";
import Login from "./shared/pages/login";

import "./App.css";

import { course_events_link, course_link, home_link } from "./links";
import CourseAddForm from "./admin/components/add_course";
import StudentCourseEvents from "./student/pages/course_events";

const App = () => {
  // const [backendData,setBackendData] = useState([{}])
  // useEffect(() => {
  //   fetch("/api/1705119").then(
  //     response => response.json()
  //   ).then(
  //     data => {
  //       setBackendData(data)
  //     }
  //   )
  // },[]);
  // console.log(backendData);

  const [userType, setUserType] = useState("nologin");
  // const userType = "student";
  // const userType = "admin";
  // const userType = "teacher";
  // const userType = "nologin";
  const stdId = 1705119;
  const adminId = 1;

  if (userType === "admin") {
    return (
      <Router>
        <AdminMenuBar adminNo={adminId} />
        <main>
          <Routes>
            <Route
              path={home_link}
              element={<Navigate to="/courses" replace />}
            />
            {/* <Route path={home_link} element={<AdminHome adminNo={adminId}/> } /> */}
            <Route
              path={"/courses"}
              element={<AdminHome adminNo={adminId} />}
            />
            <Route
              path={"/courses/addnew"}
              element={<CourseAddForm adminNo={adminId} />}
            />
            <Route
              path={"/dept/addnew"}
              element={<DeptAddForm adminNo={adminId} />}
            />
            <Route
              path="*"
              element={
                <div>
                  <h2>404 Page not found</h2>
                </div>
              }
            />
          </Routes>
        </main>
      </Router>
    );
  } else if (userType === "student") {
    return (
      <Router>
        <StudentMenuBar studentNo={stdId} />
        <main>
          <Routes>
            <Route
              path={home_link}
              element={<StudentHome studentNo={stdId} />}
            />
            <Route
              path={"/course/:courseId" + course_link}
              element={<StudentCourseHome studentNo={stdId} />}
            />
            <Route
              path={"/course/:courseId" + course_events_link}
              element={<StudentCourseEvents studentNo={stdId} />}
            />
            <Route
              path="*"
              element={
                <div>
                  <h2>404 Page not found</h2>
                </div>
              }
            />
          </Routes>
        </main>
        {/* <StudentMenuBar studentNo={stdId}/> */}
      </Router>
    );
  } else if (userType === "teacher") {
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
        <BlankMenuBar />
        <main>
          <Routes>
            <Route path={home_link} element={<Login onLogin={setUserType} />} />
            <Route
              path="*"
              element={
                <>
                  Redirecting to Login Page...
                  <Navigate to="/" replace />
                </>
              }
            />
          </Routes>
        </main>
      </Router>
    );
  }
};

export default App;
