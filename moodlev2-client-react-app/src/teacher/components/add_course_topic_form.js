import React, { useState, useEffect } from "react";
import { FormHelperText, TextField, Button, InputLabel } from "@mui/material";

const CourseTopicAddForm = ({ userName, courseId }) => {
  // var offering, offered, _year, batch, level, term, course_num;
  // var course_name;
  const [topicName, setTopicName] = useState("");
  const [topicDescription, setTopicDescription] = useState("");

  const addCourseTopic = async (courseTopicObj) => {
    //post method here
    //courseId, userName (for teacher info) available. other stuffs are input from form
    try {
      const res = await fetch(`/api/course/addNewCourseTopic`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(courseTopicObj),
      });
      const data = await res.json();
      console.log(data);
      console.log(res.status);
      if (res.status === 200) {
        // alert("Course added successfully!");
        console.log("Course topic added successfully!");
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
    const courseTopicObj = {
      topicName: topicName,
      topicDescription: topicDescription,
      courseId: courseId,
      teacherUserName: userName,
    };
    console.log(courseTopicObj);

    setTopicName("");
    setTopicDescription("");

    addCourseTopic(courseTopicObj);

    console.log("onSubmitActionc of add new course topic");
    return;
  };

  return (
    <div className="addcourse__container">
      <div className="addcourse__form__container">
        <form onSubmit={onSubmitAction} style={{ width: "80%" }}>
          <TextField
            fullWidth
            type="text"
            id="addcoursetopic__topic__name"
            label="Name"
            variant="outlined"
            value={topicName}
            onChange={(e) => setTopicName(e.target.value)}
            required
          />
          <br />
          <br />
          <TextField
            fullWidth
            type="text"
            id="addcoursetopic__topic__desc"
            label="Description"
            variant="outlined"
            multiline
            value={topicDescription}
            onChange={(e) => setTopicDescription(e.target.value)}
            required
          />
          <br />
          <br />
          <Button type="submit" variant="outlined">
            Add
          </Button>
        </form>
      </div>
    </div>
  );
};

export default CourseTopicAddForm;
