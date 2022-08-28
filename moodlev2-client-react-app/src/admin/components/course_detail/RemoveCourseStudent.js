import React from "react";
import Button from "@mui/material/Button";
import DeleteIcon from "@mui/icons-material/Delete";

const RemoveCourseStudent = ({ courseId, StudentList }) => {
  const removeCourseStudent = async (removeObj) => {
    try {
      const res = await fetch(`/api/admin/removeCourseStudent`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(removeObj),
      });
      const data = await res.json();

      console.log(data);
      console.log(res.status);

      if (res.status === 200) {
        console.log("Student removed successfully!");
        setTimeout(() => window.location.reload(), 500);
      } else {
        console.log(data.message);
      }
    } catch (err) {
      console.log(err);
    }
  };
  const onDeleteClick = () => {
    // console.log(StudentList);
    const userNameList = StudentList.map(
      (student) => student.studentObj.std_id
    );
    const removeObj = {
      courseId: courseId,
      studentList: userNameList,
    };
    console.log(removeObj);
    removeCourseStudent(removeObj);
  };
  return (
    <>
      <Button
        variant="outlined"
        startIcon={<DeleteIcon />}
        onClick={onDeleteClick}
      >
        Delete
      </Button>
      <br />
      <br />
    </>
  );
};

export default RemoveCourseStudent;
