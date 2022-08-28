import React, { useState, useEffect } from "react";
import {
  FormHelperText,
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
import ShowSchedule from "./show_schedule";

// import { makeStyles } from "@material-ui/core/styles";
// import { makeStyles } from "@mui/styles";

// const useStyles = makeStyles((theme) => ({
//   formControl: {
//     margin: theme.spacing(1),
//     width: 300,
//   },
//   indeterminateColor: {
//     color: "#f50057",
//   },
//   selectAllText: {
//     fontWeight: 500,
//   },
//   selectedAll: {
//     backgroundColor: "rgba(0, 0, 0, 0.08)",
//     "&:hover": {
//       backgroundColor: "rgba(0, 0, 0, 0.08)",
//     },
//   },
// }));

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

const sectionList = [
  {
    section_no: 1,
    section_name: "CSE-2017-B2-CSE423-2022",
  },
  {
    section_no: 2,
    section_name: "CSE-2017-B1-CSE423-2022",
  },
  {
    section_no: 3,
    section_name: "CSE-2017-A2-CSE423-2022",
  },
  {
    section_no: 4,
    section_name: "CSE-2017-A1-CSE423-2022",
  },
];

const CourseEventsAddForm = ({ userName, courseId }) => {
  //   const classes = useStyles();
  const navigate = useNavigate();
  const [eventType, setEventType] = useState("");
  const [eventFullMarks, setEventFullMarks] = useState("");
  const [typeList, setTypeList] = useState([]);
  const [sectionList, setSectionList] = useState([]);
  const [eventSection, setEventSection] = useState([]);
  // const [eventSectionName, setEventSectionName] = useState([]);
  const [eventDescription, setEventDescription] = useState("");
  const [eventTime, setEventTime] = useState(new Date());
  const isAllSelected =
    sectionList.length > 0 && eventSection.length === sectionList.length;

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/calendar/event_type`);
        const jsonData = await response.json();
        setTypeList(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

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

  // useefect
  // dependency eventsection

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

  const addCourseEvent = async (courseEventObj) => {
    //post method here
    //courseId, userName (for teacher info) available. other stuffs are input from form
    try {
      const res = await fetch(`/api/course/addNewEvent`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(courseEventObj),
      });
      const jsonData = await res.json();
      let id = null;
      // console.log(data);
      // console.log(res.status);
      console.log(res);
      if (res.status === 200) {
        console.log(jsonData.message);
        // 		setEventType("");
        // setEventDescription("");
        // setEventTime(new Date());
        // setEventSection([]);
        // id = jsonData.data.id;
        navigate(`/course/${courseId}/events`);
      } else {
        // alert(data.message);
        console.log(jsonData.message);
      }
    } catch (err) {
      console.log(err);
      // alert(err);
    }
  };
  const onSubmitAction = (event) => {
    event.preventDefault();
    const eventSectionList = eventSection.map((s) => s.secno);
    const courseEventObj = {
      eventType: eventType,
      eventFullMarks: eventFullMarks,
      eventTime: eventTime,
      eventDescription: eventDescription,
      courseId: courseId,
      teacherUserName: userName,
      eventSectionList: eventSectionList,
    };
    console.log(courseEventObj);
    addCourseEvent(courseEventObj);
    console.log("onSubmitAction of add new course event");
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
                <MenuItem key={index} value={type.type_id}>
                  {type.type_name}
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
              <TextField
                fullWidth
                type="number"
                id="addcourse__event__marks"
                label="Full Marks"
                variant="outlined"
                // InputProps={{ inputProps: { min: min_num, max: max_num } }}
                value={eventFullMarks}
                onChange={(e) => setEventFullMarks(parseInt(e.target.value))}
                required
              />
              <br /> <br />
              <InputLabel id="mutiple-select-label">Select Section</InputLabel>
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
                      <Checkbox checked={eventSection.indexOf(option) > -1} />
                    </ListItemIcon>
                    <ListItemText primary={option.secname} />
                  </MenuItem>
                ))}
              </SelectMui>
              <br /> <br />
              {eventSection === "" ? (
                <> </>
              ) : (
                <>
                  {eventType === 5 ? (
                    <></>
                  ) : (
                    <div className="event__add__see__schedule">
                      <ToggleButtonGroup
                        color="primary"
                        value={scheduleShow}
                        exclusive
                        onChange={onScheduleShowChange}
                        aria-label="Platform"
                      >
                        <ToggleButton value="schedule">
                          See Schedule
                        </ToggleButton>
                      </ToggleButtonGroup>
                      <br /> <br />
                      {scheduleShow === "schedule" && (
                        <>
                          <ShowSchedule
                            userName={userName}
                            courseId={courseId}
                            sectionList={eventSection}
                          />
                          <br /> <br />
                        </>
                      )}
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
            </>
          )}
        </form>
      </div>
    </div>
  );
};

export default CourseEventsAddForm;
