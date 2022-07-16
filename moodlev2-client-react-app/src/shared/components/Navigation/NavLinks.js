import React from 'react'
import {NavLink} from 'react-router-dom';

import './NavLinks.css';

const Navlinks = (props) => {
  const adminNavLinks = [
    {
      linkTo: '/admin/courses',
      text: 'Courses'
    },
    {
      linkTo: '/admin/teachers',
      text: 'Teachers'
    },
    {
      linkTo: '/admin/students',
      text: 'Students'
    },
    {
      linkTo: '/admin/sitenews',
      text: 'Site News'
    }
  ];
  const nonAdminNavLinks = [
    {
      linkTo: '/timeline',
      text: 'Timeline'
    },
    {
      linkTo: '/courses',
      text: 'Courses'
    },
    {
      linkTo: '/privatefiles',
      text: 'Private Files'
    },
    {
      linkTo: '/sitenews',
      text: 'Site News'
    }
  ];
  
  if(props.userType === 'admin') {
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

export default Navlinks;
