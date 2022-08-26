import { Button } from "@mui/material";
import React, { useEffect, useState } from "react";
import "./CourseForumPage.css";
import CourseForumPageReply from "./CourseForumPageReply";

const courseForumPagePostsInit = [
  {
    id: 1,
    title: "Root",
    description: "This is the root post",
    time: "2021-08-20 12:00:00",
    poster: "NIT",
    children: [
      {
        id: 2,
        title: "Child 1",
        description: "This is the child post 1",
        time: "2021-08-20 12:00:00",
        poster: "NIT",
        children: [
          {
            id: 3,
            title: "Child 1.1",
            description: "This is the child post 1.1",
            time: "2021-08-20 12:00:00",
            poster: "NIT",
          },
        ],
      },
      {
        id: 4,
        title: "Child 2",
        description: "This is the child post 2",
        time: "2021-08-20 12:00:00",
        poster: "NIT",
        children: [
          {
            id: 5,
            title: "Child 2.1",
            description: "This is the child post 2.1",
            time: "2021-08-20 12:00:00",
            poster: "NIT",
            children: [
              {
                id: 6,
                title: "Child 2.1.1",
                description: "This is the child post 2.1.1",
                time: "2021-08-20 12:00:00",
                poster: "NIT",
              },
              {
                id: 7,
                title: "Child 2.1.2",
                description: "This is the child post 2.1.2",
                time: "2021-08-20 12:00:00",
                poster: "NIT",
              },
            ],
          },
        ],
      },
      {
        id: 8,
        title: "Child 3",
        description: "This is the child post 3",
        time: "2021-08-20 12:00:00",
        poster: "NIT",
      },
    ],
  },
];

const SinglePost = ({ studentNo, courseId, forumId, postObj, onNewReply }) => {
  const [showReply, setShowReply] = useState(false);
  const onClickReply = () => {
    setShowReply(!showReply);
  };
  const onSubmitReply = (replyBody) => {
    // e.preventDefault();
    // console.log("studentNo", studentNo);
    // console.log("courseId", courseId);
    // console.log("forumId", forumId);
    // console.log("postId", postObj.id);
    // console.log(replyBody);

    // send to backend

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
      {postObj.children?.length && (
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
  // const [courseForumPagePosts, setCourseForumPagePosts] = useState([]);
  const [courseForumPagePosts, setCourseForumPagePosts] = useState(
    courseForumPagePostsInit
  );
  const [newReply, setNewReply] = useState(false);
  useEffect(() => {
    // fetch here
  }, [newReply]);

  const onNewReply = () => {
    setNewReply(true);
  };
  return (
    <div className="course__event__container" style={{ width: "95%" }}>
      <div className="course__event__info">
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
