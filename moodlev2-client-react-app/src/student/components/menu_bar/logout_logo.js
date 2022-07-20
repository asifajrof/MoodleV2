import React from "react";
import {NavLink} from 'react-router-dom';
import {FiLogOut} from 'react-icons/fi';

import { logout_link } from "../../../links";

const LogoutLogo = ({studentNo})=>{
    return (
        <>
            <NavLink to={logout_link}><FiLogOut /></NavLink>
        </>
    )
}

export default LogoutLogo;