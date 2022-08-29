import React, { useState, useEffect } from "react";
import {
  TextField,
  Button,
  InputLabel,
  MenuItem,
  ToggleButton,
  ToggleButtonGroup,
} from "@mui/material";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import dayjs from "dayjs";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
import ShowScheduleReschedule from "./ShowScheduleReschedule";
import { useNavigate } from "react-router-dom";

const TeacherRescheduleExtraClass = ({
  sectionList,
  userName,
  startTime,
  courseId,
  eventId,
}) => {
  const navigate = useNavigate();
  const [rescheduleTime, setRescheduleTime] = useState(new Date());

  const [scheduleShow, setScheduleShow] = useState("");
  const onScheduleShowChange = (event, newValue) => {
    setScheduleShow(newValue);
  };

  const sendRescheduleRequest = async (submitObj) => {
    try {
      const response = await fetch(
        "/api/reschedule/rescheduleRequestAccepted",
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(submitObj),
        }
      );
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

  const onSubmitAction = (event) => {
    event.preventDefault();
    const submitObj = {
      eventId: eventId,
      startTime: startTime,
    };
    // console.log(submitObj);
    // console.log("submit");
    sendRescheduleRequest(submitObj);
  };

  return (
    <div className="addcourse__container">
      <div className="addcourse__form__container">
        <form onSubmit={onSubmitAction} style={{ width: "100%" }}>
          <div className="event__add__see__schedule">
            <ToggleButtonGroup
              color="primary"
              value={scheduleShow}
              exclusive
              onChange={onScheduleShowChange}
              aria-label="Platform"
            >
              <ToggleButton value="schedule">See Schedule</ToggleButton>
            </ToggleButtonGroup>
            <br /> <br />
            {scheduleShow === "schedule" && (
              <>
                <ShowScheduleReschedule
                  userName={userName}
                  courseId={courseId}
                  sectionList={sectionList}
                  rescheduleType={1}
                />
                <br /> <br />
              </>
            )}
          </div>
          <LocalizationProvider dateAdapter={AdapterDayjs}>
            <DateTimePicker
              renderInput={(props) => <TextField {...props} />}
              label="Select Time"
              value={rescheduleTime}
              onChange={(newValue) => {
                setRescheduleTime(newValue);
              }}
            />
          </LocalizationProvider>
          <br />
          <br />
          <Button type="submit" variant="outlined">
            Submit
          </Button>
        </form>
      </div>
    </div>
  );
};

export default TeacherRescheduleExtraClass;
