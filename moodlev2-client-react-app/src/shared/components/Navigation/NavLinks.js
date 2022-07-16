import React from 'react'
import {NavLink} from 'react-router-dom';

import './NavLinks.css';

const NavLinks = (props) => {
  if(props.userType === 'admin') {
    const adminNavLinks = props.navLinksList;
    return (
      <ul className='nav-links'>
        {adminNavLinks.map((navLink) => (
          <li>
            <NavLink to={navLink.linkTo}>{navLink.text}</NavLink>
          </li>
        ))}
      </ul>
    );
  } else if (props.userType === 'student' || props.userType === 'teacher') {
    const nonAdminNavLinks = props.navLinksList;
    return (
      <ul className='nav-links'>
        {nonAdminNavLinks.map((navLink) => (
          <li>
            <NavLink to={navLink.linkTo}>{navLink.text}</NavLink>
          </li>
        ))}
      </ul>
    );
  } else {
    return <> </>
  }
};

export default NavLinks;
