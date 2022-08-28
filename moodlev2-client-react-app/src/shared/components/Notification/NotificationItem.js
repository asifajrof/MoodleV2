import React from "react";
import moment from "moment";
import { Link } from "react-router-dom";

import "./NotificationItem.css";

const NotificationItem = ({ notificationitem }) => {
  //   console.log(notificationitem);
  return (
    <Link to={notificationitem.notificationLink}>
      <div className="notification__item__box">
        <div className="notification__item__msg">
          {notificationitem.notificationMsg}
        </div>
        <div className="notification__item__time">
          {notificationitem.notificationTime}
        </div>
      </div>
    </Link>
  );
};

export default NotificationItem;
