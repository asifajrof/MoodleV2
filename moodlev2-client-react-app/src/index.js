import React from 'react';
import ReactDOM from 'react-dom/client';

import UpcomingEvents from './student/pages/home/upcoming_events';
import App from './App';
import {home} from './links';
import MenuBar from './student/components/menu_bar';

import './index.css';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
    {/* <UpcomingEvents studentNo={1} /> */}
  </React.StrictMode>
);
