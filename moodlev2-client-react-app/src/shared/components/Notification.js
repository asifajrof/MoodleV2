import React from "react";
import { Button } from "@mui/material";

import "./Notification.css";
import NotificationItem from "./Notification/NotificationItem";
import { Link } from "react-router-dom";

const Notification = ({ onClick }) => {
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
      <div className="notification__centered__text">
        <Link onClick={onClick} to="/notification">
          <Button variant="contained">See All</Button>
        </Link>
      </div>
    </div>
  );
};

export default Notification;
