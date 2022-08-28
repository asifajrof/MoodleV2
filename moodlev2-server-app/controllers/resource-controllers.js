const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const fs = require("fs");
const Path = require("path");

const showResourceFiles = async (req, res, next) => {
	try {
		const courseId = req.params.courseId;

		let result = await pool.query(
			"SELECT json_agg(t) FROM  get_course_resources($1) as t",
			[courseId]
		);
		const resources = result.rows[0].json_agg;
		let resourceList = [];
		if (resources != null) {
			for (r of resources) {
				const resourceInfo = {
					fileID: r.fileid,
					// fileLink: r.filelink,
					title: r.filename,
					// ownerID: r.ownerid,
					uploader: r.uploadername,
					isStudent: r.isstudent,
				};
				resourceList.push(resourceInfo);
			}
		}
		// console.log(resources);
		if (resourceList.length === 0) {
			res.json({ message: "No resources yet!", data: [] });
		} else {
			res.json({ message: "showResourceFiles", data: resourceList });
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const downloadResourceFile = async (req, res, next) => {
	try {
		const res_id = req.params.fileID;
		const isStudent = req.params.isStudent;

		if (isStudent === "true") {
			let result = await pool.query(
				"select res_link from student_resource where res_id = $1",
				[res_id]
			);
			const path = result.rows[0].res_link;

			const filePath = `${__dirname}${path}`;
			const fileName = Path.basename(filePath);
			// console.log(filePath);

			const stream = fs.createReadStream(filePath);
			res.set({
				"Content-Disposition": `attachment; filename='${fileName}'`,
			});
			res.contentType(`${fileName}`);
			stream.pipe(res);
		} else {
			let result = await pool.query(
				"select res_link from instructor_resource where res_id = $1",
				[res_id]
			);
			const path = result.rows[0].res_link;
			const filePath = `${__dirname}${path}`;
			const fileName = Path.basename(filePath);
			// console.log(filePath);

			const stream = fs.createReadStream(filePath);
			res.set({
				"Content-Disposition": `attachment; filename='${fileName}'`,
			});
			res.contentType(`${fileName}`);
			stream.pipe(res);
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const ResourceUpload = async (req, res, next) => {
	try {
		if (req.files === null) {
			return new HttpError("No file uploaded", 400);
		}
		// console.log(req);
		// const resourceInfo = req.body.resourceInfo;

		// const resourceObj = {
		const resourceTitle = req.body.resourceTitle;
		const resourceUploaderId = req.body.resourceUploaderId;
		const resourceUploaderType = req.body.resourceUploaderType;
		const resourceCourseId = req.body.resourceCourseId;
		//   };
		const file = req.files.file;
		// console.log(req.body);
		// console.log(
		// 	resourceTitle,
		// 	resourceUploaderId,
		// 	resourceUploaderType,
		// 	resourceCourseId
		// );

		if (resourceUploaderType === "Student") {
			const folderPath = `${__dirname}/../Files/course/${resourceCourseId}/resource/student/${resourceUploaderId}/`;
			if (!fs.existsSync(folderPath)) {
				console.log("folder does not exist");
				fs.mkdirSync(folderPath, { recursive: true });
			}
			let fileMovePath = `${folderPath}${file.name}`;
			// check if already exists
			if (fs.existsSync(fileMovePath)) {
				// console.log("file exists");
				// change filename
				fileMovePath = `${folderPath}${Date.now()}_${file.name}`;
			}
			file.mv(
				// `${__dirname}/../moodlev2-client-react-app/public/uploads/${file.name}`,
				fileMovePath,
				(err) => {
					if (err) {
						console.error(err);
						return next(new HttpError(err.message, 500));
					}
					res.json({ message: "File uploaded!" });
				}
			);
			// console.log(fileMovePath);
			const r_path = `/../Files/course/${resourceCourseId}/resource/student/${resourceUploaderId}/${file.name}`;
			result = await pool.query(
				"SELECT json_agg(t) FROM add_student_resource($1, $2, $3, $4) as t",
				[resourceCourseId, resourceUploaderId, resourceTitle, r_path]
			);

			res.json({
				message: "file successfully added",
				data: [],
			});
		} else if (resourceUploaderType === "Teacher") {
			const folderPath = `${__dirname}/../Files/course/${resourceCourseId}/resource/teacher/${resourceUploaderId}/`;
			if (!fs.existsSync(folderPath)) {
				console.log("folder does not exist");
				fs.mkdirSync(folderPath, { recursive: true });
			}
			let fileMovePath = `${folderPath}${file.name}`;
			// check if already exists
			if (fs.existsSync(fileMovePath)) {
				// console.log("file exists");
				// change filename
				fileMovePath = `${folderPath}${Date.now()}_${file.name}`;
			}
			file.mv(
				// `${__dirname}/../moodlev2-client-react-app/public/uploads/${file.name}`,
				fileMovePath,
				(err) => {
					if (err) {
						// console.error(err);
						console.log("error happened");
						return next(new HttpError(err.message, 500));
					}
					res.json({ message: "File uploaded!" });
				}
			);
			// console.log(fileMovePath);
			const r_path = `/../Files/course/${resourceCourseId}/resource/teacher/${resourceUploaderId}/${file.name}`;
			result = await pool.query(
				"SELECT json_agg(t) FROM add_teacher_resource($1, $2, $3, $4) as t",
				[resourceCourseId, resourceUploaderId, resourceTitle, r_path]
			);
			res.json({
				message: "file successfully added",
				data: [],
			});
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const getResourceFileInfo = async (req, res, next) => {
	try {
		const res_id = req.params.fileID;
		const isStudent = req.params.isStudent;

		// console.log(res_id, typeof isStudent);

		if (isStudent === "true") {
			let result = await pool.query(
				"select res_link from student_resource where res_id = $1",
				[res_id]
			);
			const path = result.rows[0].res_link;
			const filePath = `${__dirname}${path}`;

			if (!fs.existsSync(filePath)) {
				// --> change it to filePath
				res.json({
					message: "No filePath!",
					data: {
						fileInfo: {
							id: null,
							file_name: null,
							fileExists: false,
						},
					},
				});
			} else {
				const fileName = Path.basename(filePath);
				// console.log(filenName);
				const fileInfo = {
					id: res_id,
					file_name: fileName,
					fileExists: true,
				};
				res.json({
					message: "getResourceFileInfo",
					data: fileInfo,
				});
			}
		} else {
			let result = await pool.query(
				"select res_link from instructor_resource where res_id = $1",
				[res_id]
			);
			// console.log(result.rows[0].res_link);
			const path = result.rows[0].res_link;
			const filePath = `${__dirname}${path}`;

			if (!fs.existsSync(filePath)) {
				// --> change it to filePath
				res.json({
					message: "No filePath!",
					data: {
						fileInfo: {
							id: null,
							file_name: null,
							fileExists: false,
						},
					},
				});
			} else {
				const fileName = Path.basename(filePath);
				// console.log(fileName);
				const fileInfo = {
					id: res_id,
					file_name: fileName,
					fileExists: true,
				};
				res.json({
					message: "getResourceFileInfo",
					data: fileInfo,
				});
			}
		}
	} catch (error) {
		console.log("error happened", error);
		return next(new HttpError(error.message, 500));
	}
};
exports.getResourceFileInfo = getResourceFileInfo;
exports.showResourceFiles = showResourceFiles;
exports.downloadResourceFile = downloadResourceFile;
exports.ResourceUpload = ResourceUpload;
