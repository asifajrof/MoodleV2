import React from "react";
import LogoutLogo from "./menu_bar/logout_logo";
import MainLogo from "./menu_bar/main_logo"
import MenuOption from "./menu_bar/menu_option";
import NotificationLogo from "./menu_bar/notification_logo";
import PersonLogo from "./menu_bar/person_logo";
const options = [
    {
        _name:"",
        link:""
    }
    ,
    {
        _name:"",
        link:""
    }
    ,
    {
        _name:"",
        link:""
    }
    ,
    {
        _name:"",
        link:""
    }
]

const MenuBar = (studentNo)=>{
    return (
        <>
        <MainLogo />

        {options.map(option=>{
            <Menu option={option} />
        })}

        <NotificationLogo studentNo={studentNo} />
        <PersonLogo studentNo={studentNo} />
        <LogoutLogo studentNo={studentNo} />
        </>
    )
}