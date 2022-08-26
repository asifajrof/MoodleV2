const express = require("express");

const forumControllers = require("../controllers/forum-controllers");

const forumRoutes = express.Router();

// remember to keep order of route

forumRoutes.get("/", (req, res, next) => {
	console.log("GET /forum");
	res.json({ message: "it works!" });
});

forumRoutes.get("/course/:courseId", forumControllers.getCourseForumRootList);
forumRoutes.get(
	"/course/post/:postId",
	forumControllers.getCourseForumRecursive
);

forumRoutes.post(
	"/course/addNewCourseForum",
	forumControllers.addNewCourseForum
);

forumRoutes.post(
	"/course/addCourseForumReply",
	forumControllers.addCourseForumReply
);
// forumRoutes.get("/main", forumControllers.getMainForum);

module.exports = forumRoutes;
