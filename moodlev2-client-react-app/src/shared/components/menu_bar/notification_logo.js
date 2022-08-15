import React, { useState, Fragment, useEffect } from "react";
import { NavLink } from "react-router-dom";
import { FaBell } from "react-icons/fa";

import { notification_link } from "../../../links";
import Notification from "../Notification";
import Backdrop from "../UIElements/Backdrop";

const IntervalTime = 2000;

const NotificationLogo = ({ uId }) => {
  const [notificationShow, setNotificationShow] = useState(false);
  const [notificationList, setnotificationList] = useState([]);
  const onClickHandler = () => {
    setNotificationShow(!notificationShow);
  };
  useEffect(() => {
    let interval = setInterval(async () => {
      const res = await fetch(`/api/notification/${uId}`);
      const jsonData = await res.json();
      if (res.status === 200) {
        setnotificationList(jsonData.data);
      } else {
        alert(jsonData.message);
      }
    }, IntervalTime);
  }, []);
  return (
    <Fragment>
      {notificationShow && (
        <>
          <Backdrop show={notificationShow} onClick={onClickHandler} />{" "}
          <Notification
            onClick={onClickHandler}
            notificationList={notificationList}
            uId={uId}
          />
        </>
      )}
      <NavLink to={notification_link} onClick={onClickHandler}>
        <FaBell />
      </NavLink>
    </Fragment>
  );
};

export default NotificationLogo;
