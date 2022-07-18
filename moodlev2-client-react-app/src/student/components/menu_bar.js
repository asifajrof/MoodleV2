import React, {useState} from "react";

import MainHeader from './menu_bar/main_header';
import LogoutLogo from "./menu_bar/logout_logo";
import MainLogo from "./menu_bar/main_logo"
import MenuOption from "./menu_bar/menu_option";
import NotificationLogo from "./menu_bar/notification_logo";
import PersonLogo from "./menu_bar/person_logo";
import SideDrawer from './menu_bar/side_drawer';
import Backdrop from '../../shared/components/UIElements/Backdrop';

import { timeline_link, courses_link, privateFiles_link, siteNews_link } from "../../links";

import './menu_bar.css';

const options = [
    {
        _name: "Timeline",
        link: timeline_link
    }
    ,
    {
        _name: "Courses",
        link: courses_link
    }
    ,
    {
        _name: "Private Files",
        link: privateFiles_link
    }
    ,
    {
        _name: "Site News",
        link: siteNews_link
    }
]

const StudentMenuBar = ({studentNo})=>{
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
                <ul className='nav-links'>
                        {options.map((option, index) => (
                            <MenuOption key={index} option={option} />
                        ))}
                </ul>
            </nav>
            <nav className='main-navigation__drawer-nav'>
                <ul className='nav-icons'>
                    <li>
                        <NotificationLogo studentNo={studentNo} />
                    </li>
                    <li>
                        <PersonLogo studentNo={studentNo} />
                    </li>
                    <li>
                        <LogoutLogo studentNo={studentNo} />
                    </li>
                </ul>
            </nav>
        </SideDrawer>

        <MainHeader>
            <button 
                className='main-navigation__menu-btn'
                onClick={openDrawerHandler}
            >
                <span />
                <span />
                <span />
            </button>
            <MainLogo />

            <nav className='main-navigation__header-nav'>
                <ul className='nav-links'>
                        {options.map((option, index) => (
                            <MenuOption key={index} option={option} />
                        ))}
                </ul>
            </nav>

            <nav className='main-navigation__header-nav'>
                <ul className='nav-icons'>
                    <li>
                        <NotificationLogo studentNo={studentNo} />
                    </li>
                    <li>
                        <PersonLogo studentNo={studentNo} />
                    </li>
                    <li>
                        <LogoutLogo studentNo={studentNo} />
                    </li>
                </ul>
            </nav>
        </MainHeader>
        </React.Fragment>
    )
}

export default StudentMenuBar;
