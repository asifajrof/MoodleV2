import { Button } from "@mui/material";
import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import "./reschedule_request_body.css";

const RescheduleRequestBody = ({ studentNo, courseId, extraClassEventId }) => {
  const [postBodyObj, setPostBodyObj] = useState({});
  const navigate = useNavigate();
  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch(`/api/reschedule/info/extra`, {
          method: "POST",
          headers: {
            "Content-type": "application/json",
          },
          body: JSON.stringify({
            studentId: studentNo,
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
  const sendOkay = async (okayObj) => {
    try {
      const res = await fetch(`/api/course/addNewEvent`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(okayObj),
      });
      const jsonData = await res.json();
      console.log(res);
      if (res.status === 200) {
        console.log(jsonData.message);
        navigate("/");
      } else {
        // alert(data.message);
        console.log(jsonData.message);
      }
    } catch (err) {
      console.log(err);
    }
  };
  const sendReschedule = async (reschedObj) => {
    try {
      const res = await fetch(`/api/course/addNewEvent`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(reschedObj),
      });
      const jsonData = await res.json();
      console.log(res);
      if (res.status === 200) {
        console.log(jsonData.message);
        navigate("/");
      } else {
        // alert(data.message);
        console.log(jsonData.message);
      }
    } catch (err) {
      console.log(err);
    }
  };
  const onOkayClick = () => {
    // console.log("onOkayClick");
    sendOkay();
  };
  const onRescheduleClick = () => {
    // console.log("onRescheduleClick");
    sendReschedule();
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
      <div className="resched__req__body__button">
        <Button variant="contained" color="success" onClick={onOkayClick}>
          Okay
        </Button>
        <Button variant="contained" color="error" onClick={onRescheduleClick}>
          Reschedule Request
        </Button>
      </div>
    </div>
  );
};

export default RescheduleRequestBody;
