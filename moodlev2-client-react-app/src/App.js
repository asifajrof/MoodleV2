import React from 'react';
// import { BrowserRouter as Router, Route, Redirect, Routes as Switch, Link } from "react-router-dom";
import { BrowserRouter as Router } from "react-router-dom";

import logo from './logo.svg';
import UserHome from './UserHome';
import MainNavigation from './shared/components/Navigation/MainNavigation';
import './App.css';

const App = () => {
  const userType = 'student';
  return (
    <Router>
      <MainNavigation userType={userType}/>
      <main>
        <div className="App">
          <header className="App-header">
            <img src={logo} className="App-logo" alt="logo" />
            <p>
              Edit <code>src/App.js</code> and save to reload.
            </p>
            <a
              className="App-link"
              href="https://reactjs.org"
              target="_blank"
              rel="noopener noreferrer"
            >
              Learn React
            </a>
          </header>
        </div>
        {/* <Switch>
          <Route path="/" exact>
            <UserHome userType={userType}/>
          </Route>
        </Switch> */}
      </main>
    </Router>
  );
};

export default App;
