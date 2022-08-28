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
import { Select as SelectMui } from "@mui/material";
import { useNavigate } from "react-router-dom";
import dayjs from "dayjs";
import { AdapterDayjs } from "@mui/x-date-pickers/AdapterDayjs";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider";
// import ShowSchedule from "./show_schedule";

const typeListDummy = [
  {
    type_id: 1,
    type_name: "Extra Class",
  },
  {
    type_id: 2,
    type_name: "Cancel Class",
  },
];

const CourseEventsAddForm = ({ userName, courseId }) => {
  //   const classes = useStyles();
  const navigate = useNavigate();
  const [typeList, setTypeList] = useState(typeListDummy);
  const [sectionList, setSectionList] = useState([]);
  const [rescheduleType, setRescheduleType] = useState("");
  const [rescheduleTime, setRescheduleTime] = useState(new Date());
  console.log("typeList", typeList);
  // fetch type list -> reschedule type
  // currently fixed -> if problem let it be fixed

  //  useEffect(() => {
  //     const fetchData = async () => {
  //       try {
  //         const response = await fetch(`/api/calendar/event_type`);
  //         const jsonData = await response.json();
  //         setTypeList(jsonData.data);
  //       } catch (err) {
  //         console.log(err);
  //       }
  //     };
  //     fetchData();
  //   }, []);

  useEffect(() => {
    const fetchData = async (courseId) => {
      try {
        const response = await fetch(`/api/calendar/section_list/${courseId}`);
        const jsonData = await response.json();
        setSectionList(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData(courseId);
  }, []);

  // const addCourseEvent = async (courseEventObj) => {
  //   //post method here
  //   //courseId, userName (for teacher info) available. other stuffs are input from form
  //   try {
  //     const res = await fetch(`/api/course/addNewEvent`, {
  //       method: "POST",
  //       headers: {
  //         "Content-type": "application/json",
  //       },
  //       body: JSON.stringify(courseEventObj),
  //     });
  //     const jsonData = await res.json();
  //     let id = null;
  //     // console.log(data);
  //     // console.log(res.status);
  //     console.log(res);
  //     if (res.status === 200) {
  //       console.log(jsonData.message);
  //       navigate(`/course/${courseId}/events`);
  //     } else {
  //       // alert(data.message);
  //       console.log(jsonData.message);
  //     }
  //   } catch (err) {
  //     console.log(err);
  //     // alert(err);
  //   }
  // };
  const onSubmitAction = (event) => {
    event.preventDefault();
    // const eventSectionList = eventSection.map((s) => s.secno);
    // const courseEventObj = {
    //   eventType: eventType,
    //   eventFullMarks: eventFullMarks,
    //   eventTime: eventTime,
    //   eventDescription: eventDescription,
    //   courseId: courseId,
    //   teacherUserName: userName,
    //   eventSectionList: eventSectionList,
    // };
    // console.log(courseEventObj);
    // addCourseEvent(courseEventObj);
    // console.log("onSubmitAction of add new course event");
    return;
  };
  const [scheduleShow, setScheduleShow] = useState("");
  const onScheduleShowChange = (event, newValue) => {
    setScheduleShow(newValue);
  };

  return (
    <div className="addcourse__container">
      <div className="addcourse__form__container">
        <form onSubmit={onSubmitAction} style={{ width: "100%" }}>
          <InputLabel id="addevent__select__type__label">
            Select Type
          </InputLabel>
          <SelectMui
            fullWidth
            id="addevent__select__type"
            label="Select Event Type"
            value={rescheduleType}
            onChange={(e) => setRescheduleType(e.target.value)}
            required
          >
            {typeList.map((type, index) => {
              return (
                <MenuItem key={index} value={type.type_id}>
                  {type.type_name}
                </MenuItem>
              );
            })}
          </SelectMui>
          <br />
          <br />
          {rescheduleType === "" ? (
            <></>
          ) : (
            <>
              {rescheduleType === 2 ? (
                <>
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
                        {/* <ShowSchedule
                          userName={userName}
                          courseId={courseId}
                          sectionList={sectionList}
                        /> */}{" "}
                        dekhano hobe
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
                    Add
                  </Button>
                </>
              ) : (
                <></>
              )}
            </>
          )}
        </form>
      </div>
    </div>
  );
};

export default CourseEventsAddForm;
