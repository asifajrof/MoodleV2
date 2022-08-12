import React, { useState, Fragment } from "react";
import { NavLink } from "react-router-dom";
import { FaBell } from "react-icons/fa";

import { notification_link } from "../../../links";
import Notification from "../Notification";
import Backdrop from "../UIElements/Backdrop";

const NotificationLogo = ({ studentNo }) => {
  const [notificationShow, setNotificationShow] = useState(false);
  const onClickHandler = (event) => {
    console.log(event);
    console.log("Notification clicked");
    setNotificationShow(!notificationShow);
  };
  return (
    <Fragment>
      {notificationShow && (
        <>
          <Backdrop show={notificationShow} onClick={onClickHandler} />{" "}
          <Notification />
        </>
      )}
      <NavLink to={notification_link} onClick={onClickHandler}>
        <FaBell />
      </NavLink>
    </Fragment>
  );
};

export default NotificationLogo;
