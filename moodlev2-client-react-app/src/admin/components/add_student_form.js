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

const StudentAddForm = ({ adminNo }) => {
  // name character varying,
  // hashed_password character varying,
  // dept integer,
  // email character varying)
  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [dept, setDept] = useState("");
  const [email, setEmail] = useState("");
  const [roll, setRoll] = useState("");
  const [batch, setBatch] = useState("");

  const [deptList, setDeptList] = useState([]);
  const makeDeptList = (data) => {
    var deptListTemp = [];
    data.forEach((dept) => {
      deptListTemp.push({ value: dept.dept_code, label: dept.dept_shortname });
    });
    setDeptList(deptListTemp);
  };

  const current_year = 2022;
  const min_year = 2000;
  const yearList = [];
  for (var i = current_year; i >= min_year; i--) {
    yearList.push({ value: i, label: i });
  }

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

  const addStudent = async (studentObj) => {
    try {
      const res = await fetch(`/api/admin/addNewStudent`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(studentObj),
      });
      const data = await res.json();

      console.log(data);
      console.log(res.status);

      if (res.status === 200) {
        // alert("teacger added successfully!");
        console.log("student added successfully!");
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
    const studentObj = {
      name: name,
      password: password,
      dept: dept,
      email: email,
      roll: roll,
      batch: batch,
    };
    console.log(studentObj);

    addStudent(studentObj);

    setName("");
    setPassword("");
    setDept("");
    setEmail("");
    setRoll("");
    setBatch("");

    console.log("onSubmitAction of add new student by admin");
    return;
  };
  return (
    <div className="addcourse__container">
      <div className="addcourse__form__container">
        <form onSubmit={onSubmitAction} style={{ width: "80%" }}>
          <TextField
            fullWidth
            type="text"
            id="addstudent__name"
            label="Full Name"
            variant="outlined"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
          <br />
          <br />
          <TextField
            fullWidth
            type="password"
            id="addstudent__password"
            label="Password"
            variant="outlined"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
          <br />
          <br />
          <TextField
            fullWidth
            type="email"
            id="addstudent__email"
            label="E-mail"
            variant="outlined"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
          <br />
          <br />
          <TextField
            fullWidth
            type="roll"
            id="addstudent__roll"
            label="Roll"
            variant="outlined"
            value={roll}
            onChange={(e) => setRoll(e.target.value)}
            required
          />
          <br />
          <br />
          <InputLabel id="addstudent__batch__label">Select Batch</InputLabel>
          <SelectMui
            fullWidth
            id="addstudent__batch"
            label="Batch"
            value={batch}
            onChange={(e) => setBatch(e.target.value)}
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
          <InputLabel id="addstudent__select__dept__label">
            Select Department
          </InputLabel>
          <SelectMui
            fullWidth
            id="addstudent__select__dept"
            label="Select Department"
            value={dept}
            // options={deptList}
            // onChange={onChangeHandlerSelectDept}
            onChange={(e) => setDept(e.target.value)}
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
          <Button type="submit" variant="outlined">
            Submit
          </Button>
        </form>
      </div>
    </div>
  );
};

export default StudentAddForm;
