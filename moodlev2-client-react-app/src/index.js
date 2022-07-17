import React from 'react';
import ReactDOM from 'react-dom/client';
import UpcomingEvents from './student/pages/home/upcoming_events';
import './index.css';
import App from './App';
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    {/* <App /> */}
    <UpcomingEvents studentNo={1} />
  </React.StrictMode>
);
