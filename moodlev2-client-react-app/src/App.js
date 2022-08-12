// import React, { useState, useEffect } from "react";
import React from "react";
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
// import AddNewCourse from "./admin/pages/AddNewCourse";
import DeptAddForm from "./admin/components/add_dept";

import BlankMenuBar from "./shared/components/BlankMenuBar";
import Login from "./shared/pages/login";

import "./App.css";

import { course_events_link, course_link, home_link } from "./links";
import CourseAddForm from "./admin/components/add_course";
import StudentCourseEvents from "./student/pages/course_events";
import useToken from "./shared/pages/useToken";

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

  // const [token, setToken] = useState({});
  const { token, setToken } = useToken();

  // if (!token) {
  //   return <Login onLogin={setToken} />;
  // }

  // const [userType, setUserType] = useState("nologin");
  // useEffect(() => {
  //   setToken({ id: 1705119, type: "student" });
  //   // setUserType("student");
  //   // setUserType("admin");
  //   // setUserType("teacher");
  // }, []);

  // const stdId = token.id;
  // const adminId = token.id;

  const loginElement = (
    <Router>
      <BlankMenuBar />
      <main>
        <Routes>
          <Route path={home_link} element={<Login onLogin={setToken} />} />
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
  if (!token) {
    return loginElement;
  } else if (token.type === "admin") {
    return (
      <Router>
        <AdminMenuBar adminNo={token.id} />
        <main>
          <Routes>
            <Route
              path={home_link}
              element={<Navigate to="/courses" replace />}
            />
            {/* <Route path={home_link} element={<AdminHome adminNo={token.id}/> } /> */}
            <Route
              path={"/courses"}
              element={<AdminHome adminNo={token.id} />}
            />
            <Route
              path={"/courses/addnew"}
              element={<CourseAddForm adminNo={token.id} />}
            />
            <Route
              path={"/dept/addnew"}
              element={<DeptAddForm adminNo={token.id} />}
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
  } else if (token.type === "student") {
    return (
      <Router>
        <StudentMenuBar studentNo={token.id} />
        <main>
          <Routes>
            <Route
              path={home_link}
              element={<StudentHome studentNo={token.id} />}
            />
            <Route
              path={"/course/:courseId" + course_link}
              element={<StudentCourseHome studentNo={token.id} />}
            />
            <Route
              path={"/course/:courseId" + course_events_link}
              element={<StudentCourseEvents studentNo={token.id} />}
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
        {/* <StudentMenuBar studentNo={token.id}/> */}
      </Router>
    );
  } else if (token.type === "teacher") {
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
    return loginElement;
  }
};

export default App;
