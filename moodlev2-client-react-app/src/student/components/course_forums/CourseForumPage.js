import React, { useState } from "react";
import "./CourseForumPage.css";

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

const Post = (props) => {
  return (
    <>
      {props.data.map((item) => (
        <>
          <div className="course__forum__post">
            {item.title}
            <br />
            {item.description}
            <br />
            {item.time}
            <br />
            {item.poster}
            {item.children?.length && <Post data={item.children} />}
          </div>
        </>
      ))}
    </>
  );
};

const CourseForumPage = ({ studentNo, courseId, eventId }) => {
  // const [courseForumPagePosts, setCourseForumPagePosts] = useState([]);
  const [courseForumPagePosts, setCourseForumPagePosts] = useState(
    courseForumPagePostsInit
  );
  return (
    <div className="course__event__container" style={{ width: "95%" }}>
      <div className="course__event__info">
        <Post data={courseForumPagePosts} />
      </div>
    </div>
  );
};

export default CourseForumPage;
