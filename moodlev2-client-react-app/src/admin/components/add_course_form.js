import { Select as SelectMui } from "@mui/material";
import React, { useState, useEffect } from "react";
import {
  FormHelperText,
  TextField,
  Button,
  InputLabel,
  MenuItem,
} from "@mui/material";
// import { Button } from "@mui/material";
// import "./add_course.css";

const CourseAddForm = ({ adminNo }) => {
  // var offering, offered, _year, batch, level, term, course_num;
  // var course_name;
  const [courseName, setCourseName] = useState("");
  const [courseNum, setCourseNum] = useState("");
  const [courseLevel, setCourseLevel] = useState("");
  const [courseTerm, setCourseTerm] = useState("");
  const [courseBatch, setCourseBatch] = useState("");
  const [courseYear, setCourseYear] = useState("");
  const [deptOffered, setDeptOffered] = useState("");
  const [deptOffering, setDeptOffering] = useState("");

  const [deptList, setDeptList] = useState([]);
  const makeDeptList = (data) => {
    var deptListTemp = [];
    data.forEach((dept) => {
      deptListTemp.push({ value: dept.dept_code, label: dept.dept_shortname });
    });
    setDeptList(deptListTemp);
  };
  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/admin/dept_list/`);
        const jsonData = await response.json();
        makeDeptList(jsonData.data);
        // setDeptList(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, []);

  const current_year = 2022;
  const min_year = 2000;
  const yearList = [];
  for (var i = current_year; i >= min_year; i--) {
    yearList.push({ value: i, label: i });
  }

  const max_level = 5;
  const min_level = 1;
  const levelList = [];
  for (var i = max_level; i >= min_level; i--) {
    levelList.push({ value: i, label: i });
  }
  const termList = [
    {
      label: "January",
      value: 1,
    },
    {
      label: "July",
      value: 2,
    },
  ];

  const max_num = 0;
  const min_num = 99;

  // const max_term = 2;
  // const min_term = 1;
  // const termList = [];
  // for (var i = max_term; i >= min_term; i--) {
  //   termList.push({ value: i, label: i });
  // }

  const addCourse = async (courseObj) => {
    try {
      const res = await fetch(`/api/admin/addNewCourse`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(courseObj),
      });
      const data = await res.json();

      console.log(data);
      console.log(res.status);

      if (res.status === 200) {
        // alert("Course added successfully!");
        console.log("Course added successfully!");
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
    const courseObj = {
      courseName: courseName,
      courseNum: courseNum,
      courseLevel: courseLevel,
      courseTerm: courseTerm,
      courseBatch: courseBatch,
      courseYear: courseYear,
      deptOffered: deptOffered,
      deptOffering: deptOffering,
    };
    console.log(courseObj);

    setCourseName("");
    setCourseNum("");
    setCourseLevel("");
    setCourseTerm("");
    setCourseBatch("");
    setCourseYear("");
    setDeptOffered("");
    setDeptOffering("");

    addCourse(courseObj);

    console.log("onSubmitActionc of add new course by admin");
    return;
  };

  return (
    <div className="addcourse__container">
      <div className="addcourse__form__container">
        <form onSubmit={onSubmitAction} style={{ width: "80%" }}>
          <TextField
            fullWidth
            type="text"
            id="addcourse__course__name"
            label="Course Name"
            variant="outlined"
            value={courseName}
            onChange={(e) => setCourseName(e.target.value)}
            required
          />
          <br />
          <br />
          <TextField
            fullWidth
            type="number"
            id="addcourse__course__num"
            label="Course Number"
            variant="outlined"
            // InputProps={{ inputProps: { min: min_num, max: max_num } }}
            value={courseNum}
            onChange={(e) => setCourseNum(parseInt(e.target.value))}
            required
          />
          <br />
          <br />
          <InputLabel id="addcourse__select__dept__offering__label">
            Select Offering Department
          </InputLabel>
          <SelectMui
            fullWidth
            id="addcourse__select__dept__offering"
            label="Select Offering Department"
            value={deptOffering}
            // options={deptList}
            // onChange={onChangeHandlerSelectDeptOffering}
            onChange={(e) => setDeptOffering(e.target.value)}
            required
          >
            {deptList.map((dept, index) => {
              return (
                <MenuItem key={index} value={dept.value}>
                  {dept.label}
                </MenuItem>
              );
            })}
          </SelectMui>
          <br />
          <br />
          <InputLabel id="addcourse__select__dept__offered__label">
            Select Offered Department
          </InputLabel>
          <SelectMui
            fullWidth
            id="addcourse__select__dept__offered"
            label="Select Offered Department"
            value={deptOffered}
            // options={deptList}
            // onChange={onChangeHandlerSelectDeptOffered}
            onChange={(e) => setDeptOffered(e.target.value)}
            required
          >
            {deptList.map((dept, index) => {
              return (
                <MenuItem key={index} value={dept.value}>
                  {dept.label}
                </MenuItem>
              );
            })}
          </SelectMui>
          <br />
          <br />
          <InputLabel id="addcourse__select__course__year__label">
            Select Course Year
          </InputLabel>
          <SelectMui
            fullWidth
            id="addcourse__select__course__year"
            label="Select Course Year"
            value={courseYear}
            // options={yearList}
            // onChange={onChangeHandlerSelectCourseYear}
            onChange={(e) => setCourseYear(e.target.value)}
            required
          >
            {yearList.map((year, index) => {
              return (
                <MenuItem key={index} value={year.value}>
                  {year.label}
                </MenuItem>
              );
            })}
          </SelectMui>
          <br />
          <br />
          <InputLabel id="addcourse__select__course__batch__label">
            Select Course Batch
          </InputLabel>
          <SelectMui
            fullWidth
            id="addcourse__select__course__batch__year"
            label="Select Course Batch"
            value={courseBatch}
            // options={yearList}
            // onChange={onChangeHandlerSelectCourseBatch}
            onChange={(e) => setCourseBatch(e.target.value)}
            required
          >
            {yearList.map((year, index) => {
              return (
                <MenuItem key={index} value={year.value}>
                  {year.label}
                </MenuItem>
              );
            })}
          </SelectMui>
          <br />
          <br />
          <InputLabel id="addcourse__select__course__level__label">
            Select Course Level
          </InputLabel>
          <SelectMui
            fullWidth
            id="addcourse__select__course__level"
            label="Select Course Level"
            value={courseLevel}
            // options={levelList}
            // onChange={onChangeHandlerSelectCourseLevel}
            onChange={(e) => setCourseLevel(e.target.value)}
            required
          >
            {levelList.map((level, index) => {
              return (
                <MenuItem key={index} value={level.value}>
                  {level.label}
                </MenuItem>
              );
            })}
          </SelectMui>
          <br />
          <br />
          <InputLabel id="addcourse__select__course__term__label">
            Select Course Term
          </InputLabel>
          <SelectMui
            fullWidth
            id="addcourse__select__course__term"
            label="Select Course Term"
            value={courseTerm}
            // options={term_list}
            // onChange={onChangeHandlerSelectCourseTerm}
            onChange={(e) => setCourseTerm(e.target.value)}
            required
          >
            {termList.map((term, index) => {
              return (
                <MenuItem key={index} value={term.value}>
                  {term.label}
                </MenuItem>
              );
            })}
          </SelectMui>
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

export default CourseAddForm;
