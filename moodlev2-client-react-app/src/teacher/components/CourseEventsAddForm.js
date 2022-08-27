import React, { useState, useEffect } from "react";
import {
  FormHelperText,
  TextField,
  Button,
  InputLabel,
  MenuItem,
} from "@mui/material";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import { Select as SelectMui } from "@mui/material";
import { useNavigate } from "react-router-dom";
import dayjs from "dayjs";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";

const typeList = [
  {
    id: 1,
    type: "Class Test",
  },
  {
    id: 2,
    type: "Lab Quiz",
  },
  {
    id: 3,
    type: "Lab Test",
  },
  {
    id: 4,
    type: "Online Evaluation",
  },
  {
    id: 5,
    type: "Assignment",
  },
];

const CourseEventsAddForm = ({ userName, courseId }) => {
  const navigate = useNavigate();
  const [eventType, setEventType] = useState("");
  const [eventDescription, setEventDescription] = useState("");
  const [eventTime, setEventTime] = useState(new Date());

  const addCourseForum = async (courseForumObj) => {
    //post method here
    //courseId, userName (for teacher info) available. other stuffs are input from form
    try {
      const res = await fetch(`/api/forum/course/addNewCourseForum`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(courseForumObj),
      });
      const data = await res.json();
      let id = null;
      // console.log(data);
      // console.log(res.status);
      console.log(res);
      if (res.status === 200) {
        navigate(`/course/${courseId}/forum`);
        console.log("Course forum added successfully!");
        id = data.id;
      } else {
        // alert(data.message);
        console.log(data.message);
      }
    } catch (err) {
      console.log(err);
      // alert(err);
    }
  };
  const onSubmitAction = (event) => {
    event.preventDefault();
    const courseEventObj = {
      eventType: eventType,
      eventTime: eventTime,
      eventDescription: eventDescription,
      courseId: courseId,
      teacherUserName: userName,
    };
    console.log(courseEventObj);

    setEventType("");
    setEventDescription("");
    setEventTime(new Date());

    // addCourseForum(courseForumObj);

    console.log("onSubmitAction of add new course event");
    return;
  };

  return (
    <div className="addcourse__container">
      <div className="addcourse__form__container">
        <form onSubmit={onSubmitAction} style={{ width: "80%" }}>
          <InputLabel id="addevent__select__type__label">
            Select Event Type
          </InputLabel>
          <SelectMui
            fullWidth
            id="addevent__select__type"
            label="Select Event Type"
            value={eventType}
            onChange={(e) => setEventType(e.target.value)}
            required
          >
            {typeList.map((type, index) => {
              return (
                <MenuItem key={index} value={type.id}>
                  {type.type}
                </MenuItem>
              );
            })}
          </SelectMui>
          <br />
          <br />
          {eventType === "" ? (
            <></>
          ) : (
            <>
              {eventType == 5 ? (
                <></>
              ) : (
                <div>
                  schedule button
                  <br /> <br />
                </div>
              )}

              <LocalizationProvider dateAdapter={AdapterDayjs}>
                <DateTimePicker
                  renderInput={(props) => <TextField {...props} />}
                  label="Select Event Time"
                  value={eventTime}
                  onChange={(newValue) => {
                    setEventTime(newValue);
                  }}
                />
              </LocalizationProvider>
              <br />
              <br />
              <InputLabel>Description</InputLabel>
              <TextField
                fullWidth
                type="text"
                id="addcoursetopic__topic__desc"
                // label="Description"
                variant="outlined"
                multiline
                value={eventDescription}
                onChange={(e) => setEventDescription(e.target.value)}
                required
              />
              <br />
              <br />
              <Button type="submit" variant="outlined">
                Add
              </Button>
            </>
          )}
        </form>
      </div>
    </div>
  );
};

export default CourseEventsAddForm;
