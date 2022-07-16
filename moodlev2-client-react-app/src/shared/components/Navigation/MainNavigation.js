import React, {useState} from 'react';
import { Link } from 'react-router-dom';

import logo from '../../../logo.svg';
import MainHeader from './MainHeader';
import NavLinks from './NavLinks';
import NavIcons from './NavIcons';
import SideDrawer from './SideDrawer';
import Backdrop from '../UIElements/Backdrop';
import './MainNavigation.css';

const MainNavigation = (props) => {
    const [drawerIsOpen, setDrawerIsOpen] = useState(false);

    const openDrawerHandler = () => {
        setDrawerIsOpen(true);
    };

    const closeDrawerHandler = () => {
        setDrawerIsOpen(false);
    };

    return (
        <React.Fragment>
            {drawerIsOpen && <Backdrop show={drawerIsOpen} onClick={closeDrawerHandler} />}
            <SideDrawer show={drawerIsOpen} onClick={closeDrawerHandler}>
                <nav className='main-navigation__drawer-nav'>
                    <NavLinks userType={props.userType} navLinksList={props.navLinksList} />
                </nav>
                <nav className='main-navigation__drawer-nav'>
                    <NavIcons userType={props.userType} />
                </nav>
            </SideDrawer>

            <MainHeader>
                {(props.userType==='admin' || props.userType==='student' || props.userType==='teacher') && <button 
                    className='main-navigation__menu-btn'
                    onClick={openDrawerHandler}
                >
                    <span />
                    <span />
                    <span />
                    <span />
                </button>}
                <h1 className='main-navigation__title'>
                    <Link to='/'><img src={logo} className='main-navigation__title__image' alt='M'/>Moodle V2</Link>
                </h1>
                <nav className='main-navigation__header-nav'>
                    <NavLinks userType={props.userType} navLinksList={props.navLinksList} />
                </nav>
                <nav className='main-navigation__header-nav'>
                    <NavIcons userType={props.userType} />
                </nav>
            </MainHeader>
        </React.Fragment>
    );
};

export default MainNavigation;
