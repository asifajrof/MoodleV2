import { Button } from "@mui/material";
import React, { useEffect, useState } from "react";
import "./CourseForumPage.css";
import CourseForumPageReply from "./CourseForumPageReply";

const SinglePost = ({ studentNo, courseId, forumId, postObj, onNewReply }) => {
  const [showReply, setShowReply] = useState(false);
  const onClickReply = () => {
    setShowReply(!showReply);
  };

  const addCourseForumReply = async (courseForumReplyObj) => {
    //post method here
    //courseId, userName (for teacher info) available. other stuffs are input from form
    try {
      const res = await fetch(`/api/forum/course/addCourseForumReply`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(courseForumReplyObj),
      });
      const data = await res.json();
      let id = null;
      // console.log(data);
      // console.log(res.status);
      if (res.status === 200) {
        console.log("Course forum added successfully!");
        id = data.id;
        // window.location.reload();
      } else {
        // alert(data.message);
        console.log(data.message);
      }
    } catch (err) {
      console.log(err);
      // alert(err);
    }
  };

  const onSubmitReply = (replyBody) => {
    // e.preventDefault();
    // console.log("studentNo", studentNo);
    // console.log("courseId", courseId);
    // console.log("forumId", forumId);
    // console.log("postId", postObj.id);
    // console.log(replyBody);

    // send to backend

    const courseForumReplyObj = {
      forumName: `Re:${postObj.title}`,
      forumDescription: replyBody,
      courseId: courseId,
      userName: studentNo,
      isStudent: true,
      parentId: postObj.id,
    };
    addCourseForumReply(courseForumReplyObj);
    setShowReply(false);
    onNewReply();
  };
  return (
    <div className="course__forum__post">
      <div className="course__forum__post__body">
        <div className="course__forum__post__body__title">{postObj.title}</div>
        <div className="course__forum__post__body__info">
          By {postObj.poster} - {postObj.time}
        </div>
        <div className="course__forum__post__body__desc">
          {postObj.description}
        </div>
        <div className="course__forum__post__body__reply">
          <Button
            variant="outlined"
            size="small"
            color="primary"
            onClick={onClickReply}
          >
            Reply
          </Button>
        </div>
        {showReply && <CourseForumPageReply onSubmitReply={onSubmitReply} />}
      </div>
      {postObj.children?.length > 0 && (
        <Post
          studentNo={studentNo}
          courseId={courseId}
          forumId={forumId}
          data={postObj.children}
          onNewReply={onNewReply}
        />
      )}
    </div>
  );
};

const Post = ({ studentNo, courseId, forumId, data, onNewReply }) => {
  return (
    <>
      {data.map((item, index) => (
        <SinglePost
          key={index}
          studentNo={studentNo}
          courseId={courseId}
          forumId={forumId}
          postObj={item}
          onNewReply={onNewReply}
        />
      ))}
    </>
  );
};

const CourseForumPage = ({ studentNo, courseId, forumId }) => {
  const [rootID, setRootID] = useState(null);
  const [courseForumPagePosts, setCourseForumPagePosts] = useState([]);
  const [newReply, setNewReply] = useState(false);
  useEffect(() => {
    // fetch here
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/forum/course/post/${forumId}`);
        const jsonData = await response.json();
        setCourseForumPagePosts(jsonData.data.list);
        setRootID(jsonData.data.id);
        // console.log(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, [newReply]);

  const onNewReply = () => {
    setNewReply(true);
  };
  return (
    <div className="course__event__container" style={{ width: "95%" }}>
      <div className="course__event__info">
        {rootID === null || rootID === forumId ? (
          <></>
        ) : (
          <div className="forum__root__id__div">
            <Button
              variant="outlined"
              size="small"
              color="primary"
              href={`/course/${courseId}/forum/${rootID}`}
            >
              Show Root Post
            </Button>
          </div>
        )}
        <Post
          studentNo={studentNo}
          courseId={courseId}
          forumId={forumId}
          data={courseForumPagePosts}
          onNewReply={onNewReply}
        />
      </div>
    </div>
  );
};

export default CourseForumPage;
