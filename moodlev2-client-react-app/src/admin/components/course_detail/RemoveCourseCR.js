import React from "react";
import Button from "@mui/material/Button";
import DeleteIcon from "@mui/icons-material/Delete";

const RemoveCourseCR = ({ courseId, CRList }) => {
  const removeCourseCR = async (removeObj) => {
    try {
      const res = await fetch(`/api/admin/removeCourseCR`, {
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
        console.log("CR removed successfully!");
        setTimeout(() => window.location.reload(), 500);
      } else {
        console.log(data.message);
      }
    } catch (err) {
      console.log(err);
    }
  };
  const onDeleteClick = () => {
    const userNameList = CRList.map((cr) => cr.crObj.uname);
    const removeObj = {
      courseId: courseId,
      crList: userNameList,
    };
    // console.log(removeObj);
    removeCourseCR(removeObj);
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

export default RemoveCourseCR;
