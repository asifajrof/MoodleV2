import React from "react";
import { NavLink } from "react-router-dom";
import { FaBell } from "react-icons/fa";

import { notification_link } from "../../../links";

const NotificationLogo = ({ studentNo }) => {
  return (
    <>
      <NavLink to={notification_link}>
        <FaBell />
      </NavLink>
    </>
  );
};

export default NotificationLogo;
