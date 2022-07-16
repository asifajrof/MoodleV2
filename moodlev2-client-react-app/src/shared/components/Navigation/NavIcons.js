import React from 'react'
// import {NavLink} from 'react-router-dom';
// import {FaUserAlt} from 'react-icons/fa';
// import {FaBell} from 'react-icons/fa';
// import {FiLogOut} from 'react-icons/fi';

import './NavIcons.css';

const NavIcons = (props) => {
    if(props.userType === 'admin') {
        return (
          <ul className='nav-icons'>
            {/* <li><NavLink to='/profile'><FaBell /></NavLink></li> */}
            {/* <li><NavLink to='/profile'><FaUserAlt /></NavLink></li>
            <li><NavLink to='/profile'><FiLogOut /></NavLink></li> */}
          </ul>
        );
      } else if (props.userType === 'student' || props.userType === 'teacher') {
        return (
          <ul className='nav-icons'>
            {/* <li><NavLink to='#notification'><FaBell /></NavLink></li>
            <li><NavLink to='/profile'><FaUserAlt /></NavLink></li>
            <li><NavLink to='#logout'><FiLogOut /></NavLink></li> */}
          </ul>
        );
      } else {
        return <> </>
      }
};

export default NavIcons;
