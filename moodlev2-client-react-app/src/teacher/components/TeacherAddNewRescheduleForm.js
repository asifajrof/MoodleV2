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
import { ListItemIcon, ListItemText, Checkbox } from "@mui/material";
import ShowScheduleReschedule from "./ShowScheduleReschedule";

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
  const [eventSection, setEventSection] = useState([]);

  const isAllSelected =
    sectionList.length > 0 && eventSection.length === sectionList.length;

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

  const eventSectionChange = (event) => {
    const value = event.target.value;
    if (value[value.length - 1] === "all") {
      setEventSection(
        eventSection.length === sectionList.length ? [] : sectionList // sectionList.map((s) => s.section_no)
      );
      return;
    }
    setEventSection(value);
  };

  const addExtraClass = async (extraClassObj) => {
    // console.log(extraClassObj);
    // return;
    //post method here
    //courseId, userName (for teacher info) available. other stuffs are input from form
    try {
      const res = await fetch(`/api/reschedule/add/extra`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(extraClassObj),
      });
      const jsonData = await res.json();
      if (res.status === 200) {
        console.log(jsonData.message);
        navigate(`/course/${courseId}/reschedule`);
      } else {
        console.log(jsonData.message);
      }
    } catch (err) {
      console.log(err);
    }
  };

  const addCancelClass = async (cancelClassObj) => {
    try {
      const res = await fetch(`/api/reschedule/add/cancel`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(cancelClassObj),
      });
      const jsonData = await res.json();
      if (res.status === 200) {
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
    if (rescheduleType === 1) {
      // console.log("extra class on submit");
      const eventSectionList = eventSection.map((s) => s.secno);
      const extraClassObj = {
        eventSectionList: eventSectionList,
        eventTime: rescheduleTime,
        userName: userName,
      };
      addExtraClass(extraClassObj);
    } else if (rescheduleType === 2) {
      // console.log("cancel class on submit");
      const cancelClassObj = {
        userName: userName,
        reschTime: rescheduleTime,
      };
      console.log(cancelClassObj);
      addCancelClass(cancelClassObj);
    }
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
              {rescheduleType === 1 && (
                <>
                  <InputLabel id="mutiple-select-label">
                    Select Section
                  </InputLabel>
                  <SelectMui
                    fullWidth
                    labelId="mutiple-select-label"
                    multiple
                    value={eventSection}
                    onChange={eventSectionChange}
                    renderValue={(eventSection) => {
                      let str = "";
                      eventSection.forEach((section) => {
                        str += section.secname + ", ";
                      });
                      return str;
                    }}
                    // MenuProps={MenuProps}
                  >
                    <MenuItem
                      value="all"
                      //   classes={{
                      //     root: isAllSelected ? classes.selectedAll : "",
                      //   }}
                    >
                      <ListItemIcon>
                        <Checkbox
                          //   classes={{ indeterminate: classes.indeterminateColor }}
                          checked={isAllSelected}
                          indeterminate={
                            eventSection.length > 0 &&
                            eventSection.length < sectionList.length
                          }
                        />
                      </ListItemIcon>
                      <ListItemText
                        // classes={{ primary: classes.selectAllText }}
                        primary="Select All"
                      />
                    </MenuItem>
                    {sectionList.map((option, index) => (
                      <MenuItem key={index} value={option}>
                        <ListItemIcon>
                          <Checkbox
                            checked={eventSection.indexOf(option) > -1}
                          />
                        </ListItemIcon>
                        <ListItemText primary={option.secname} />
                      </MenuItem>
                    ))}
                  </SelectMui>
                  <br /> <br />
                </>
              )}
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
                      sectionList={
                        rescheduleType === 1 ? eventSection : sectionList
                      }
                      rescheduleType={rescheduleType}
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
            </>
          )}
        </form>
      </div>
    </div>
  );
};

export default CourseEventsAddForm;
