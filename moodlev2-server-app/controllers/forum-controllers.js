const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const moment = require("moment");

const getCourseForumRootList = async (req, res, next) => {
	try {
		const courseId = req.params.courseId;
		console.log("GET api/forum/course/root");
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_root_course_posts($1) as t",
			[courseId]
		);
		// console.log(courseId);
		const rootList = result.rows[0].json_agg;
		// console.log(rootList);
		// console.log(result);
		if (!rootList) {
			// console.log("here");
			res.json({ message: "getCourseForumRootList", data: [] });
		} else if (rootList == null) {
			res.json({ message: "getCourseForumRootList", data: [] });
		} else {
			res.json({ message: "getCourseForumRootList", data: rootList });
		}
	} catch (err) {
		return next(new HttpError(err.message, 500));
	}
};

const BuildRecursiveForum = async (postId) => {
	try {
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_current_course_post($1) as t",
			[postId]
		);
		const current_post = result.rows[0].json_agg;
		let currentPostObj = {
			id: current_post[0].postid,
			title: current_post[0].title,
			description: current_post[0].description,
			time: moment(current_post[0].posttime).format("LLL"),
			poster: current_post[0].postername,
			children: [],
		};
		// console.log(current_post);
		let result2 = await pool.query(
			"SELECT json_agg(t) FROM get_course_children_post($1) as t",
			[postId]
		);

		const children_list = result2.rows[0].json_agg;
		// console.log("children_list : ", children_list);

		if (children_list == null) {
			return currentPostObj;
		}

		for (child of children_list) {
			// console.log(child);
			let childPostObj = await BuildRecursiveForum(child);
			// console.log(childPostObj);
			currentPostObj.children.push(childPostObj);
		}
		return currentPostObj;
	} catch (err) {
		return new HttpError(err.message, 500);
	}
};

const getCourseForumRecursive = async (req, res, next) => {
	try {
		const postId = req.params.postId;
		let courseForumPagePosts = await BuildRecursiveForum(postId);
		res.json({
			message: "recursive course forum list",
			data: [courseForumPagePosts],
		});
	} catch (err) {
		return next(new HttpError(err.message, 500));
	}
};
const addNewCourseForum = async (req, res, next) => {
	try {
		const { forumName, forumDescription, courseId, teacherUserName } = req.body;
		const isStudent = false;
		const parent = null;
		// console.log(
		// 	courseId,
		// 	teacherUserName.userName,
		// 	isStudent,
		// 	forumName,
		// 	forumDescription,
		// 	parent
		// );
		console.log("POST api/forum/course/addNewCourseForum");
		let result = await pool.query(
			"SELECT json_agg(t) FROM add_course_post($1, $2, $3, $4, $5, $6) as t",
			[
				courseId,
				teacherUserName.userName,
				isStudent,
				forumName,
				forumDescription,
				parent,
			]
		);
		const forum = result.rows[0].json_agg;
		res.json({ message: "added New Course Forum", data: { id: forum } });
		// console.log(forum[0]);
		// console.log(result);
		// if (!forum) {
		// 	next(new HttpError("Forum not found", 404));
		// } else {
		// 	res.json({ message: "addNewCourseForum", data: forum });
		// }
	} catch (err) {
		return next(new HttpError(err.message, 500));
	}
};

const addCourseForumReply = async (req, res, next) => {
	try {
		const {
			forumName,
			forumDescription,
			courseId,
			userName,
			isStudent,
			parentId,
		} = req.body;
		const parent = null;
		// console.log(
		// 	courseId,
		// 	teacherUserName.userName,
		// 	isStudent,
		// 	forumName,
		// 	forumDescription,
		// 	parent
		// );
		console.log("POST api/forum/course/addNewCourseForumReply");
		let result = await pool.query(
			"SELECT json_agg(t) FROM add_course_post($1, $2, $3, $4, $5, $6) as t",
			[courseId, userName, isStudent, forumName, forumDescription, parentId]
		);
		const forum = result.rows[0].json_agg;
		res.json({ message: "added New Course Forum", data: { id: forum } });
	} catch (err) {
		return next(new HttpError(err.message, 500));
	}
};
exports.addCourseForumReply = addCourseForumReply;
exports.getCourseForumRecursive = getCourseForumRecursive;
exports.getCourseForumRootList = getCourseForumRootList;
exports.addNewCourseForum = addNewCourseForum;
