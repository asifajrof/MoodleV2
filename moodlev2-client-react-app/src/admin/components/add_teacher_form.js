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

const TeacherAddForm = ({ adminNo }) => {
  // name character varying,
  // uname character varying,
  // hashed_password character varying,
  // dept integer,
  // email character varying)
  const [name, setName] = useState("");
  const [uName, setUName] = useState("");
  const [password, setPassword] = useState("");
  const [dept, setDept] = useState(0);
  const [email, setEmail] = useState("");

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

  const onSubmitAction = (event) => {
    event.preventDefault();
    const teacherObj = {
      name: name,
      uName: uName,
      password: password,
      dept: dept,
      email: email,
    };
    console.log(teacherObj);

    console.log("onSubmitAction");
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
            id="addteacher__name"
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
            type="text"
            id="addteacher__u__name"
            label="Username"
            variant="outlined"
            value={uName}
            onChange={(e) => setUName(e.target.value)}
            required
          />
          <br />
          <br />
          <TextField
            fullWidth
            type="password"
            id="addteacher__password"
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
            id="addteacher__email"
            label="E-mail"
            variant="outlined"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
          <br />
          <br />
          <InputLabel id="addteacher__select__dept__label">
            Select Offering Department
          </InputLabel>
          <Select
            id="addteacher__select__dept"
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

export default TeacherAddForm;
