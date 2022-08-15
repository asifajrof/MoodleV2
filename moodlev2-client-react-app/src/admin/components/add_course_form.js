import Select from "react-select";
// import Select from "@mui/material/Select";
import React, { useState, useEffect } from "react";
import { FormHelperText, TextField, Button, InputLabel } from "@mui/material";
// import { Button } from "@mui/material";
// import "./add_course.css";

const term_list = [
  {
    label: "January",
    value: 1,
  },
  {
    label: "July",
    value: 2,
  },
];

const CourseAddForm = ({ adminNo }) => {
  // var offering, offered, _year, batch, level, term, course_num;
  // var course_name;
  const [courseName, setCourseName] = useState("");
  const [courseNum, setCourseNum] = useState(0);
  const [courseLevel, setCourseLevel] = useState(0);
  const [courseTerm, setCourseTerm] = useState(0);
  const [courseBatch, setCourseBatch] = useState(0);
  const [courseYear, setCourseYear] = useState(0);
  const [deptOffered, setDeptOffered] = useState(0);
  const [deptOffering, setDeptOffering] = useState(0);

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
  for (var i = current_year + 1; i >= min_year; i--) {
    yearList.push({ value: i, label: i });
  }

  const max_level = 5;
  const min_level = 1;
  const levelList = [];
  for (var i = max_level; i >= min_level; i--) {
    levelList.push({ value: i, label: i });
  }

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
        alert("Course added successfully!");
      } else {
        alert(data.message);
      }
    } catch (err) {
      console.log(err);
      alert(err);
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
    setCourseNum(0);
    setCourseLevel(0);
    setCourseTerm(0);
    setCourseBatch(0);
    setCourseYear(0);
    setDeptOffered(0);
    setDeptOffering(0);

    addCourse(courseObj);

    console.log("onSubmitActionc of add new course by admin");
    return;
  };
  const onChangeHandlerSelectDeptOffering = (selectedDept) => {
    console.log("onChangeHandlerSelectDeptOffering", selectedDept);
    // console.log(courseNum);
    setDeptOffering(selectedDept.value);
  };
  const onChangeHandlerSelectDeptOffered = (selectedDept) => {
    console.log("onChangeHandlerSelectDeptOffered", selectedDept);
    setDeptOffered(selectedDept.value);
  };
  const onChangeHandlerSelectCourseYear = (selectedYear) => {
    console.log("onChangeHandlerSelectCourseYear", selectedYear);
    setCourseYear(selectedYear.value);
  };
  const onChangeHandlerSelectCourseBatch = (selectedYear) => {
    console.log("onChangeHandlerSelectCourseBatch", selectedYear);
    setCourseBatch(selectedYear.value);
  };
  const onChangeHandlerSelectCourseLevel = (selectedLevel) => {
    console.log("onChangeHandlerSelectCourseLevel", selectedLevel);
    setCourseLevel(selectedLevel.value);
  };
  const onChangeHandlerSelectCourseTerm = (selectedTerm) => {
    console.log("onChangeHandlerSelectCourseTerm", selectedTerm);
    setCourseTerm(selectedTerm.value);
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
          <Select
            id="addcourse__select__dept__offering"
            options={deptList}
            onChange={onChangeHandlerSelectDeptOffering}
            required
          ></Select>
          <br />
          <InputLabel id="addcourse__select__dept__offered__label">
            Select Offered Department
          </InputLabel>
          <Select
            id="addcourse__select__dept__offered"
            options={deptList}
            onChange={onChangeHandlerSelectDeptOffered}
            required
          ></Select>
          <br />
          <InputLabel id="addcourse__select__course__year__label">
            Select Course Year
          </InputLabel>
          <Select
            id="addcourse__select__course__year"
            options={yearList}
            onChange={onChangeHandlerSelectCourseYear}
            required
          ></Select>
          <br />
          <InputLabel id="addcourse__select__course__batch__label">
            Select Course Batch
          </InputLabel>
          <Select
            id="addcourse__select__course__batch__year"
            options={yearList}
            onChange={onChangeHandlerSelectCourseBatch}
            required
          ></Select>
          <br />
          <InputLabel id="addcourse__select__course__level__label">
            Select Course Level
          </InputLabel>
          <Select
            id="addcourse__select__course__level"
            options={levelList}
            onChange={onChangeHandlerSelectCourseLevel}
            required
          ></Select>
          <br />
          <InputLabel id="addcourse__select__course__term__label">
            Select Course Term
          </InputLabel>
          <Select
            id="addcourse__select__course__term"
            options={term_list}
            onChange={onChangeHandlerSelectCourseTerm}
            required
          ></Select>
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
