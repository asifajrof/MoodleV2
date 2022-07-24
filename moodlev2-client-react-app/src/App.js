// import React, {useState, useEffect} from 'react';
import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';

import StudentMenuBar from './student/components/menu_bar';
import StudentHome from './student/pages/student_home';

import './App.css';

import { home_link } from './links';

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

  const userType = 'student';
  const stdId = 1705119;
  
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
        {/* <StudentMenuBar studentNo={stdId}/> */}
        <main>
          <Routes>
            <Route path={home_link} element={<StudentHome studentNo={stdId}/>} />
          </Routes>
        </main>
        <StudentMenuBar studentNo={stdId}/>
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
