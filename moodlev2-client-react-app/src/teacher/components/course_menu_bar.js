import React, { useState } from "react";
import {
  course_events_link,
  course_forum_link,
  course_grades_link,
  course_link,
  course_resources_link,
} from "../../links";

import CourseHeader from "./course_menu_bar/course_header";
// import CourseMenuOption from './course_menu_bar/course_menu_option';
import MenuOption from "../../shared/components/menu_bar/menu_option";
import Backdrop from "../../shared/components/UIElements/Backdrop";
import SideDrawer from "../../shared/components/menu_bar/side_drawer";
// import './course_menu_bar.css';

const CourseMenuBar = ({ userName, courseId }) => {
  const root_link = `/course/${courseId}`;
  const options = [
    {
      _name: "Home",
      link: root_link + course_link,
    },
    {
      _name: "Events",
      link: root_link + course_events_link,
    },
    {
      _name: "Grades",
      link: root_link + course_grades_link,
    },
    {
      _name: "Resource Sharing",
      link: root_link + course_resources_link,
    },
    {
      _name: "Forum",
      link: root_link + course_forum_link,
    },
  ];

  const [drawerIsOpen, setDrawerIsOpen] = useState(false);

  const openDrawerHandler = () => {
    setDrawerIsOpen(true);
  };

  const closeDrawerHandler = () => {
    setDrawerIsOpen(false);
  };
  return (
    <React.Fragment>
      {drawerIsOpen && (
        <Backdrop show={drawerIsOpen} onClick={closeDrawerHandler} />
      )}
      <SideDrawer show={drawerIsOpen} onClick={closeDrawerHandler}>
        <nav className="main-navigation__drawer-nav">
          <ul className="nav-links">
            {options.map((option, index) => (
              <MenuOption key={index} option={option} />
            ))}
          </ul>
        </nav>
      </SideDrawer>

      <CourseHeader>
        <button
          className="main-navigation__menu-btn"
          onClick={openDrawerHandler}
        >
          <span />
          <span />
          <span />
        </button>
        <nav className="main-navigation__header-nav">
          <ul className="nav-links">
            {options.map((option, index) => (
              <MenuOption key={index} option={option} />
            ))}
          </ul>
        </nav>
      </CourseHeader>
    </React.Fragment>
  );
};

export default CourseMenuBar;
