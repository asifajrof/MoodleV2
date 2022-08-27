import React from "react";
import moment from "moment";

import "./NotificationItem.css";

const NotificationItem = ({ notificationitem }) => {
	//   console.log(notificationitem);
	return (
		<div className="notification__item__box">
			{notificationitem.notificationMsg}
			{/* {notificationitem.dept_shortname} {notificationitem.course_code}{" "}
      {notificationitem.teachernamr} posted a {notificationitem.eventtypename} */}
			<br></br>
			{/* {moment(notificationitem.notificationtime).format("LLL")} */}
		</div>
	);
};

export default NotificationItem;
