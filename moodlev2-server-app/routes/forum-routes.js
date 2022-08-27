const express = require("express");

const forumControllers = require("../controllers/forum-controllers");

const forumRoutes = express.Router();

// remember to keep order of route

forumRoutes.get("/", (req, res, next) => {
	console.log("GET /forum");
	res.json({ message: "it works!" });
});

forumRoutes.get("/course/:courseId", forumControllers.getCourseForumRootList);

forumRoutes.get("/sitenews", forumControllers.getSiteNewsRootList);
forumRoutes.get(
	"/course/post/:postId",
	forumControllers.getCourseForumRecursive
);

forumRoutes.get(
	"/siteNews/post/:postId",
	forumControllers.getSiteNewsRecursive
);
forumRoutes.post(
	"/course/addNewCourseForum",
	forumControllers.addNewCourseForum
);

forumRoutes.post("/sitenews/addSiteNews", forumControllers.addNewSiteNews);

forumRoutes.post(
	"/course/addCourseForumReply",
	forumControllers.addCourseForumReply
);

forumRoutes.post(
	"/sitenews/addSiteNewsReply",
	forumControllers.addSiteNewsReply
);

// forumRoutes.get("/main", forumControllers.getMainForum);

module.exports = forumRoutes;
