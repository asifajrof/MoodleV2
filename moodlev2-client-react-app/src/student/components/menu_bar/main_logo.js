import React from "react";
import { Link } from 'react-router-dom';

import logo from '../../../logo.svg';

const MainLogo = ()=>{
    return (
        <div className='main-navigation__title'>
            <Link to='/'><img src={logo} className='main-navigation__title__image' alt='M'/>Moodle V2</Link>
        </div>
    )
}

export default MainLogo;