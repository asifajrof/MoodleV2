import React from "react";
import { NavLink } from "react-router-dom";
import { FiLogOut } from "react-icons/fi";

import { home_link, logout_link } from "../../../links";

const LogoutLogo = ({ uId }) => {
  const onClickHandler = () => {
    localStorage.clear();
    sessionStorage.clear();
    window.location.href = "/";
  };

  return (
    <>
      <NavLink onClick={onClickHandler} to={logout_link}>
        <FiLogOut />
      </NavLink>
    </>
  );
};

export default LogoutLogo;
