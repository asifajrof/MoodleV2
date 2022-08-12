import React from "react";

import "./Notification.css";
import NotificationItem from "./Notification/NotificationItem";

const Notification = () => {
  const notificationList = [
    {
      id: 1,
      item: "notification item 1",
    },
    {
      id: 2,
      item: "notification item 2",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 1,
      item: "notification item 1",
    },
    {
      id: 2,
      item: "notification item 2",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
    {
      id: 3,
      item: "notification item 3",
    },
  ];
  //   alert("Notification clicked");
  return (
    <div className="notification__box">
      {notificationList.map((notificationitem, index) => (
        <NotificationItem key={index} notificationitem={notificationitem} />
      ))}
    </div>
  );
};

export default Notification;
