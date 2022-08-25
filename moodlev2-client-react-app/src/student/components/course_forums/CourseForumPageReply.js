import { Button, TextField } from "@mui/material";
import React, { useState } from "react";

const CourseForumPageReply = ({ onSubmitReply }) => {
  const [replyBody, setReplyBody] = useState("");
  return (
    <div className="course__forum__post__body__reply__form">
      <form onSubmit={onSubmitReply}>
        <TextField
          fullWidth
          type="text"
          multiline
          variant="outlined"
          value={replyBody}
          onChange={(e) => setReplyBody(e.target.value)}
        />
        <br />
        <br />
        <Button variant="outlined" size="small" color="primary" type="submit">
          Submit
        </Button>
      </form>
    </div>
  );
};

export default CourseForumPageReply;
