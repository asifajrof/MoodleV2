import React from "react";

import "./NotificationItem.css";

const NotificationItem = ({ notificationitem }) => {
  //   console.log(notificationitem);
  return <div className="notification__item__box">{notificationitem.item}</div>;
};

export default NotificationItem;
