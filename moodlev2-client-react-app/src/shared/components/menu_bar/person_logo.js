import React from "react";
import { NavLink } from "react-router-dom";
import { FaUserAlt } from "react-icons/fa";

import { personal_link } from "../../../links";

const PersonLogo = ({ studentNo }) => {
  return (
    <>
      <NavLink to={personal_link}>
        <FaUserAlt />
      </NavLink>
    </>
  );
};

export default PersonLogo;
