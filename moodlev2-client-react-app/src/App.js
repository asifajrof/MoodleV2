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
import StudentCourseEvents from "./student/pages/course_events";
import StudentTimeline from "./student/pages/student_timeline";
import StudentCourseEvent from "./student/pages/course_event";
import StudentSiteNews from "./student/pages/site_news";

import TeacherMenuBar from "./teacher/components/menu_bar";
import TeacherHome from "./teacher/pages/teacher_home";
import TeacherCourseHome from "./teacher/pages/course_home";
import TeacherCourseEvents from "./teacher/pages/course_events";
import TeacherTimeline from "./teacher/pages/teacher_timeline";
import TeacherSiteNews from "./teacher/pages/site_news";

import AdminMenuBar from "./admin/components/menu_bar";
import AdminHome from "./admin/pages/AdminHome";
import AddNewCourse from "./admin/pages/AddNewCourse";
import DeptAddForm from "./admin/components/add_dept";
import AdminTeachers from "./admin/pages/AdminTeachers";
import AddNewTeacher from "./admin/pages/AddNewTeacher";
import AdminStudents from "./admin/pages/AdminStudents";
import AddNewStudent from "./admin/pages/AddNewStudent";
import AdminSiteNews from "./admin/pages/site_news";

import BlankMenuBar from "./shared/components/BlankMenuBar";
import Login from "./shared/pages/login";

import "./App.css";

import {
  courses_link,
  course_events_link,
  course_forum_link,
  course_link,
  home_link,
  timeline_link,
  siteNews_link,
  course_resources_link,
} from "./links";
import useToken from "./shared/pages/useToken";
import TeacherAddNewCourseTopic from "./teacher/pages/course_add_new_topic";
import StudentCoursePage from "./student/pages/course_page";
import TeacherCoursePage from "./teacher/pages/course_page";
import StudentCourseForums from "./student/pages/course_forums";
import StudentSiteNewsList from "./student/pages/site_news_list";
import TeacherSiteNewsList from "./teacher/pages/site_news_list";
import StudentCourseForum from "./student/pages/course_forum";
import TeacherCourseForums from "./teacher/pages/course_forums";
import Resources from "./shared/pages/course_resources";
import TeacherAddNewForum from "./teacher/pages/course_add_new_forum";
import TeacherAddNewSiteNews from "./teacher/pages/sitenews_add_new_post";
import TeacherCourseForum from "./teacher/pages/course_forum";
import AdminCourse from "./admin/pages/AdminCourse";
import TeacherAddNewCourseEvents from "./teacher/pages/TeacherAddNewCourseEvents";
import AddNewResource from "./shared/pages/AddNewResource";
import AdminAddNewSiteNews from "./admin/pages/sitenews_add_new_post";
import AdminSiteNewsList from "./admin/pages/site_news_list";
import TeacherCourseEvent from "./teacher/pages/course_event";
import TeacherCourseEventFileAdd from "./teacher/pages/course_event_file_add";
import TeacherCourseEventSubmissions from "./teacher/pages/course_event_submissions";
import TeacherCourseGrades from "./teacher/pages/course_grades";
import TeacherCourseGrade from "./teacher/pages/course_grade";
import StudentCourseGrades from "./student/pages/course_grades";
import TeacherCourseReschedules from "./teacher/pages/course_rechedules";
import TeacherAddNewReschedule from "./teacher/pages/add_new_course_reschedule";
import CRCourseRescheduleRequest from "./student/pages/course_reschedule_request";
import TeacherCourseRescheduleRequest from "./teacher/pages/course_reschedule_request";
import StudentCourseReschedules from "./student/pages/course_reschedule";
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
  } else if (token.type === "Admin") {
    console.log("Admin ", token);
    return (
      <Router>
        <AdminMenuBar adminNo={token.id} uType={token.type} />
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
            {/* <Route
							path={siteNews_link}
							element={<Navigate to="/courses" replace />}
						/> */}
            <Route
              path={"/courses/addnew"}
              element={<AddNewCourse adminNo={token.id} />}
            />
            <Route
              path={"/course/:courseId"}
              element={<AdminCourse adminNo={token.id} />}
            />
            <Route
              path={"/teachers"}
              element={<AdminTeachers adminNo={token.id} />}
            />
            <Route
              path={"/teachers/addnew"}
              element={<AddNewTeacher adminNo={token.id} />}
            />
            <Route
              path={"/students"}
              element={<AdminStudents adminNo={token.id} />}
            />
            <Route
              path={"/students/addnew"}
              element={<AddNewStudent adminNo={token.id} />}
            />
            <Route
              path={"/dept/addnew"}
              element={<DeptAddForm adminNo={token.id} />}
            />
            <Route
              path={"/sitenews/addnew"}
              element={<AdminAddNewSiteNews userName={token.id} />}
            />
            <Route
              path={"/sitenews/:forumId"}
              element={<AdminSiteNews userName={token.id} />}
            />
            <Route
              path={siteNews_link}
              element={
                <AdminSiteNewsList userName={token.id} uType={token.type} />
              }
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
  } else if (token.type === "Student") {
    console.log("Student ", token);
    return (
      <Router>
        <StudentMenuBar studentNo={token.id} uType={token.type} />
        <main>
          <Routes>
            <Route
              path={home_link}
              element={<StudentHome studentNo={token.id} uType={token.type} />}
            />
            <Route
              path={courses_link}
              element={
                <StudentCoursePage studentNo={token.id} uType={token.type} />
              }
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
              path={"/course/:courseId/event/:eventId"}
              element={<StudentCourseEvent studentNo={token.id} />}
            />
            <Route
              path={"/course/:courseId/grades"}
              element={<StudentCourseGrades studentNo={token.id} />}
            />
            <Route
              path={
                "/course/:courseId/reschedule/extra/request/:extraClassEventId"
              }
              element={<CRCourseRescheduleRequest studentNo={token.id} />}
            />
            <Route
              path={"/course/:courseId/reschedule"}
              element={<StudentCourseReschedules studentNo={token.id} />}
            />
            <Route
              path={"/course/:courseId" + course_forum_link}
              element={<StudentCourseForums studentNo={token.id} />}
            />
            <Route
              path={"/course/:courseId/forum/:forumId"}
              element={<StudentCourseForum studentNo={token.id} />}
            />
            <Route
              path={"/course/:courseId" + course_resources_link}
              element={<Resources userName={token.id} uType={token.type} />}
            />
            <Route
              path={"/course/:courseId/resource/addnew"}
              element={
                <AddNewResource userName={token.id} uType={token.type} />
              }
            />
            <Route
              path={timeline_link}
              element={
                <StudentTimeline studentNo={token.id} uType={token.type} />
              }
            />
            <Route
              path={"/sitenews/:forumId"}
              element={<StudentSiteNews studentNo={token.id} />}
            />
            <Route
              path={siteNews_link}
              element={
                <StudentSiteNewsList studentNo={token.id} uType={token.type} />
              }
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
  } else if (token.type === "Teacher") {
    console.log("Teacher ", token);
    return (
      <Router>
        <TeacherMenuBar userName={token.id} uType={token.type} />
        <main>
          <Routes>
            <Route
              path={home_link}
              element={<TeacherHome userName={token.id} uType={token.type} />}
            />
            <Route
              path={courses_link}
              element={
                <TeacherCoursePage userName={token.id} uType={token.type} />
              }
            />
            <Route
              path={"/course/:courseId" + course_link}
              element={<TeacherCourseHome userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/topics/addnew" + course_link}
              element={<TeacherAddNewCourseTopic userName={token.id} />}
            />
            <Route
              path={"/course/:courseId" + course_events_link}
              element={<TeacherCourseEvents userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/events/addnew"}
              element={<TeacherAddNewCourseEvents userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/event/:eventId"}
              element={<TeacherCourseEvent userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/event/:eventId/addfile"}
              element={<TeacherCourseEventFileAdd userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/event/:eventId/submissions"}
              element={<TeacherCourseEventSubmissions userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/grades"}
              element={<TeacherCourseGrades userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/grade/event/:eventId"}
              element={<TeacherCourseGrade userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/reschedule"}
              element={<TeacherCourseReschedules userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/reschedule/addnew"}
              element={<TeacherAddNewReschedule userName={token.id} />}
            />
            <Route
              path={
                "/course/:courseId/reschedule/extra/request/:extraClassEventId"
              }
              element={<TeacherCourseRescheduleRequest userName={token.id} />}
            />
            <Route
              path={"/course/:courseId" + course_forum_link}
              element={<TeacherCourseForums userName={token.id} />}
            />
            <Route
              path={"/course/:courseId" + course_resources_link}
              element={<Resources userName={token.id} uType={token.type} />}
            />
            <Route
              path={"/course/:courseId/resource/addnew"}
              element={
                <AddNewResource userName={token.id} uType={token.type} />
              }
            />
            <Route
              path={"/course/:courseId/forum/addnew" + course_link}
              element={<TeacherAddNewForum userName={token.id} />}
            />
            <Route
              path={"/sitenews/addnew"}
              element={<TeacherAddNewSiteNews userName={token.id} />}
            />
            <Route
              path={"/course/:courseId/forum/:forumId"}
              element={<TeacherCourseForum userName={token.id} />}
            />
            <Route
              path={timeline_link}
              element={
                <TeacherTimeline userName={token.id} uType={token.type} />
              }
            />
            <Route
              path={"/sitenews/:forumId"}
              element={<TeacherSiteNews userName={token.id} />}
            />
            <Route
              path={siteNews_link}
              element={
                <TeacherSiteNewsList userName={token.id} uType={token.type} />
              }
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
  } else {
    return loginElement;
  }
};

export default App;
