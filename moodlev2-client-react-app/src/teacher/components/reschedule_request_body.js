import { Button } from "@mui/material";
import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import TeacherRescheduleExtraClass from "./TeacherRescheduleExtraClass";
// import "./reschedule_request_body.css";

const RescheduleRequestBody = ({ userName, courseId, extraClassEventId }) => {
  const [view, setView] = useState("button");
  const [postBodyObj, setPostBodyObj] = useState({});
  const navigate = useNavigate();
  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch(`/api/reschedule/info/extra/reschedule`, {
          method: "POST",
          headers: {
            "Content-type": "application/json",
          },
          body: JSON.stringify({
            userName: userName,
            eventId: extraClassEventId,
          }),
        });
        const jsonData = await res.json();
        //   console.log(res);
        if (res.status === 200) {
          // obj = {
          //     userName: extra.teacherNamr,
          //     eventStartTime: extra.start_time,
          //     courseName: extra.dept_shortname + " " + extra.course_code,
          // };
          setPostBodyObj(jsonData.data);
          console.log(jsonData);
        } else {
          // alert(data.message);
          console.log(jsonData.message);
        }
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);
  const sendReject = async (rejectObj) => {
    try {
      const response = await fetch("/api/reschedule/rescheduleRequestDenied", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(rejectObj),
      });
      const jsonData = await response.json();
      if (response.status === 200) {
        console.log(jsonData.message);
        navigate(`/course/${courseId}/reschedule`);
      } else {
        console.log(jsonData.message);
      }
    } catch (err) {
      console.log(err);
    }
  };
  const onReject = () => {
    // console.log("onReject");
    const rejectObj = {
      sec: postBodyObj.secNo,
      userName: userName,
      eventStartTime: postBodyObj.eventStartTime,
      eventEndTime: postBodyObj.eventEndTime,
    };
    sendReject(rejectObj);
  };
  const onRescheduleClick = () => {
    // console.log("onRescheduleClick");
    setView("reschedule");
    // sendReschedule();
  };
  return (
    <div className="resched__req__body">
      {/* <div>{studentNo}</div>
      <div>{courseId}</div>
      <div>{extraClassEventId}</div> */}
      <div className="resched__req__body__msg">
        {postBodyObj.courseName} : {postBodyObj.userName} has requested to
        reschedule an extra class on {postBodyObj.eventStartTime}
      </div>
      {view === "button" && (
        <div className="resched__req__body__button">
          <Button
            variant="contained"
            color="success"
            onClick={onRescheduleClick}
          >
            Reschedule
          </Button>
          <Button variant="contained" color="error" onClick={onReject}>
            Reject Request
          </Button>
        </div>
      )}
      {view === "reschedule" && (
        <>
          <div className="addcourse__form__container">
            <TeacherRescheduleExtraClass
              sectionList={[
                { secname: postBodyObj.secName, secno: postBodyObj.secNo },
              ]}
              userName={userName}
              startTime={postBodyObj.eventStartTime}
              courseId={courseId}
              eventId={extraClassEventId}
            />
          </div>
        </>
      )}
    </div>
  );
};

export default RescheduleRequestBody;
