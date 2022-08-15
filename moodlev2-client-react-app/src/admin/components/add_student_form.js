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

const StudentAddForm = ({ adminNo }) => {
  // name character varying,
  // hashed_password character varying,
  // dept integer,
  // email character varying)
  const [name, setName] = useState("");
  const [password, setPassword] = useState("");
  const [dept, setDept] = useState(0);
  const [email, setEmail] = useState("");
  const [roll, setRoll] = useState(0);
  const [batch, setBatch] = useState(0);

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
    setDept(0);
    setEmail("");
    setRoll(0);
    setBatch(0);

    console.log("onSubmitAction of add new student by admin");
    return;
  };
  const onChangeHandlerSelectDept = (selectedDept) => {
    console.log("onChangeHandlerSelectDept", selectedDept);
    // console.log(courseNum);
    setDept(selectedDept.value);
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
          <TextField
            fullWidth
            type="batch"
            id="addstudent__batch"
            label="batch"
            variant="outlined"
            value={batch}
            onChange={(e) => setBatch(e.target.value)}
            required
          />
          <br />
          <br />
          <InputLabel id="addstudent__select__dept__label">
            Select Department
          </InputLabel>
          <Select
            id="addstudent__select__dept"
            options={deptList}
            onChange={onChangeHandlerSelectDept}
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

export default StudentAddForm;
