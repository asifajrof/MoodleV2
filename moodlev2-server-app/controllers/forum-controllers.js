const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

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

const getCourseForumRecursive = async (req, res, next) => {
	try {
		const postId = req.params.postId;
		console.log("GET api/forum/main/");
		let result = await pool.query(
			"SELECT json_agg(t) FROM get_root_posts() as t"
		);
		const rootList = result.rows[0].json_agg;
		// console.log(forum);
		// console.log(result);
		if (!rootList) {
			next(new HttpError("Forum Posts not found", 404));
		} else {
			res.json({ message: "getAllPosts", data: rootList });
		}
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

const getCourseForum = async (req, res, next) => {
	// try {
	// 	console.log("GET api/forum/course/:courseId");
	// 	let result = await pool.query(
	// 		"SELECT json_agg(t) FROM get_all_teacher_admin() as t"
	// 	);
	// 	const teachers = result.rows[0].json_agg;
	// 	// console.log(teachers);
	// 	// console.log(result);
	// 	if (!teachers) {
	// 		next(new HttpError("Teachers not found", 404));
	// 	} else {
	// 		res.json({ message: "getAllTeachers", data: teachers });
	// 	}
	// } catch (err) {
	// 	return next(new HttpError(err.message, 500));
	// }
};

// exports.getMainForum = getMainForum;
exports.getCourseForum = getCourseForum;
exports.getCourseForumRootList = getCourseForumRootList;
exports.addNewCourseForum = addNewCourseForum;
