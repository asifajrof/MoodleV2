import { Button } from "@mui/material";
import React, { useEffect, useState } from "react";
// import { Link } from "react-router-dom";
import "./SiteNewsPage.css";
import SiteNewsPageReply from "./SiteNewsPageReply";

const SinglePost = ({ userName, forumId, postObj, onNewReply }) => {
  const [showReply, setShowReply] = useState(false);
  const onClickReply = () => {
    setShowReply(!showReply);
  };

  const addSiteNewsReply = async (siteNewsReplyObj) => {
    //post method here
    //courseId, userName (for teacher info) available. other stuffs are input from form
    try {
      const res = await fetch(`/api/forum/sitenews/addSiteNewsReply`, {
        method: "POST",
        headers: {
          "Content-type": "application/json",
        },
        body: JSON.stringify(siteNewsReplyObj),
      });
      const data = await res.json();
      let id = null;
      // console.log(data);
      // console.log(res.status);
      if (res.status === 200) {
        console.log("site news added successfully!");
        id = data.id;
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

    const siteNewsReplyObj = {
      forumName: `Re:${postObj.title}`,
      forumDescription: replyBody,
      userName: userName,
      isStudent: false,
      parentId: postObj.id,
    };
    addSiteNewsReply(siteNewsReplyObj);
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
        {showReply && <SiteNewsPageReply onSubmitReply={onSubmitReply} />}
      </div>
      {postObj.children?.length > 0 && (
        <Post
          userName={userName}
          forumId={forumId}
          data={postObj.children}
          onNewReply={onNewReply}
        />
      )}
    </div>
  );
};

const Post = ({ userName, forumId, data, onNewReply }) => {
  return (
    <>
      {data.map((item, index) => (
        <SinglePost
          key={index}
          userName={userName}
          forumId={forumId}
          postObj={item}
          onNewReply={onNewReply}
        />
      ))}
    </>
  );
};

const SiteNewsPage = ({ userName, forumId }) => {
  const [rootID, setRootID] = useState(null);
  const [siteNewsPagePosts, setSiteNewsPagePosts] = useState([]);
  const [newReply, setNewReply] = useState(false);
  useEffect(() => {
    // fetch here
    const fetchData = async () => {
      try {
        const response = await fetch(`/api/forum/siteNews/post/${forumId}`);
        const jsonData = await response.json();
        setSiteNewsPagePosts(jsonData.data.list);
        setRootID(jsonData.data.id);
        // console.log(jsonData.data.id);
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
            {/* <Link to={`/sitenews/${rootID}`}> */}
            <Button
              variant="outlined"
              size="small"
              color="primary"
              href={`/sitenews/${rootID}`}
            >
              Show Root Post
            </Button>
            {/* </Link> */}
          </div>
        )}
        <Post
          userName={userName}
          forumId={forumId}
          data={siteNewsPagePosts}
          onNewReply={onNewReply}
        />
      </div>
    </div>
  );
};

export default SiteNewsPage;
