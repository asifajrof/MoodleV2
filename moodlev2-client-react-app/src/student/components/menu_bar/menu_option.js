import React from "react";
import {NavLink} from 'react-router-dom';

const MenuOption = ({option})=>{
    return (
        <>
            <NavLink to={option.link}>{option._name}</NavLink>
        </>
    )
}
export default MenuOption;