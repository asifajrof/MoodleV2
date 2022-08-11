// import Select from 'react-select';
import React, { useState, useEffect } from "react";
import { Button } from "@mui/material";

const DeptAddForm = ({ course }) => {
  const [deptName, setDeptName] = useState("");
  const [deptShortName, setDeptShortName] = useState("");
  const [deptCode, setDeptCode] = useState(0);

  const onAddDept = async (dept) => {
    try {
      // console.log("trying");
      const res = await fetch(`/api/admin/adddept`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(dept),
      });
      // console.log("post done");
      const data = await res.json();
      alert(data.message);
    } catch (err) {
      // console.log("error khaisi");
      // console.log(err);
      // if (err.response.status === 500) {
      //   alert("Server Error");
      // }
    }
  };

  const onSubmitAction = (event) => {
    event.preventDefault();
    if (!deptName) {
      alert("Please enter the name");
      return;
    } else if (!deptShortName) {
      alert("Please enter the shortname");
      return;
    } else if (!deptCode) {
      alert("Please enter the code");
      return;
    }

    // console.log("onSubmitAction");
    // console.log(deptName, deptShortName, deptCode);
    setDeptName("");
    setDeptShortName("");
    setDeptCode(0);
    onAddDept({ deptName, deptShortName, deptCode });
  };

  return (
    <form onSubmit={onSubmitAction}>
      <label htmlFor="deptName">Department Name:</label>
      <input
        type="text"
        placeholder="Add Department Name"
        value={deptName}
        onChange={(e) => setDeptName(e.target.value)}
      />
      <label htmlFor="deptShortName">Department Short Name:</label>
      <input
        type="text"
        placeholder="Add Department Short Name"
        value={deptShortName}
        onChange={(e) => setDeptShortName(e.target.value)}
      />
      <label htmlFor="deptCode">Department Code:</label>
      <input
        type="number"
        placeholder={0}
        min={1}
        value={deptCode}
        onChange={(e) => setDeptCode(e.target.value)}
      />
      <Button type="submit" variant="contained">
        Submit
      </Button>
    </form>
  );
};

export default DeptAddForm;
