import React from "react";
import Button from "@mui/material/Button";
import DeleteIcon from "@mui/icons-material/Delete";

const RemoveCourseTeacher = ({ courseId, TeacherList }) => {
  const removeCourseTeacher = async (removeObj) => {
    try {
      const res = await fetch(`/api/admin/removeCourseTeacher`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(removeObj),
      });
      const data = await res.json();

      console.log(data);
      console.log(res.status);

      console.log(data.message);
      if (res.status === 200) {
        setTimeout(() => window.location.reload(), 500);
      }
    } catch (err) {
      console.log(err);
    }
  };
  const onDeleteClick = () => {
    const userNameList = TeacherList.map((teacher) => teacher.teacherObj.uname);
    const removeObj = {
      courseId: courseId,
      teacherList: userNameList,
    };
    // console.log(removeObj);
    removeCourseTeacher(removeObj);
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

export default RemoveCourseTeacher;
