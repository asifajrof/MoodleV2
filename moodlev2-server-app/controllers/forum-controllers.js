const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");

const getMainForumRootList = async (req, res, next) => {
	try {
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

const getMainForumRecursive = async (req, res, next) => {
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

exports.getMainForum = getMainForum;
exports.getCourseForum = getCourseForum;
exports.getMainForumRootList = getMainForumRootList;
