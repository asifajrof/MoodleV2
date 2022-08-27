const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const fs = require("fs");
const Path = require("path");

// const fileInfoDummy = {
// 	id: 1,
// 	file_name: "file name 1.pdf",
// };

//work to be done after getting query -- done
const getStudentAssignmentSubmittedFileInfo = async (req, res, next) => {
	// console.log(req.params.fileID);
	// console.log("getFileInfo");
	try {
		const submissionId = req.params.fileID;
		// console.log("submissionId " + submissionId);

		let result = await pool.query(
			"select link from submission where sub_id = $1",
			[submissionId]
		);
		const path = result.rows[0].link;
		const filePath = `${__dirname}${path}`;
		// console.log(filePath);
		// const fileInfo = fileInfoDummy;

		if (!fs.existsSync(filePath)) {
			// --> change it to filePath
			res.json({ message: "No filePath!", data: [] });
		} else {
			const fileName = Path.basename(filePath);
			// console.log(filenName);
			const fileInfo = {
				id: submissionId,
				file_name: fileName,
			};
			res.json({
				message: "getStudentAssignmentSubmittedFileInfo",
				data: fileInfo,
			});
			// res.json({
			// 	message: "getFileInfo",
			// 	data: fileInfo,
			// });
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

//work to be done after getting query -- done
const getStudentCourseAssignmentSubmittedFile = async (req, res, next) => {
	// console.log("getFile");
	try {
		const submissionId = req.params.fileID;
		// const fileName = "file.pdf";
		// const folderPath = `${__dirname}/../../moodlev2-client-react-app/public/uploads/`;
		// const fileURL = `${folderPath}/file.pdf`;
		// console.log(fileURL);

		let result = await pool.query(
			"select link from submission where sub_id = $1",
			[submissionId]
		);
		const path = result.rows[0].link;
		const filePath = `${__dirname}${path}`;
		const fileName = Path.basename(filePath);
		// console.log(filePath);

		const stream = fs.createReadStream(filePath);
		res.set({
			"Content-Disposition": `attachment; filename='${fileName}'`,
		});
		res.contentType(`${fileName}`);
		stream.pipe(res);
	} catch (e) {
		console.error(e);
		res.status(500).end();
	}
};

const StudentCourseAssignmentSubmit = async (req, res, next) => {
	try {
		if (req.files === null) {
			return new HttpError("No file uploaded", 400);
		}
		// console.log(req);
		const studentNo = req.body.studentNo;
		const courseId = req.body.courseId;
		const eventId = req.body.eventId;
		const file = req.files.file;

		// console.log(studentNo, courseId, eventId);

		const folderPath = `${__dirname}/../Files/course/${courseId}/event/${eventId}/student/${studentNo}/`;
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
		const submission_path = `/../Files/course/${courseId}/event/${eventId}/student/${studentNo}/${file.name}`;
		const result = await pool.query(
			"SELECT json_agg(t) FROM make_submission($1, $2, $3) as t",
			[eventId, studentNo, submission_path]
		);
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

const TeacherEvaluationSubmit = async (req, res, next) => {
	try {
		if (req.files === null) {
			return new HttpError("No file uploaded", 400);
		}
		// console.log(req);
		const userName = req.body.userName;
		const courseId = req.body.courseId;
		const eventId = req.body.eventId;
		const file = req.files.file;

		// console.log(studentNo, courseId, eventId);

		const folderPath = `${__dirname}/../Files/course/${courseId}/event/${eventId}/teacher/${userName}/`;
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
		const submission_path = `/../Files/course/${courseId}/event/${eventId}/teacher/${userName}/${file.name}`;
		const result = await pool.query(
			"SELECT json_agg(t) FROM upload_evaluation($1, $2) as t",
			[eventId, submission_path]
		);
		res.json({
			message: "file successfully added",
			data: { fileId: eventId },
		});
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};
exports.getStudentCourseAssignmentSubmittedFile =
	getStudentCourseAssignmentSubmittedFile;
exports.getStudentAssignmentSubmittedFileInfo =
	getStudentAssignmentSubmittedFileInfo;
exports.StudentCourseAssignmentSubmit = StudentCourseAssignmentSubmit;
exports.TeacherEvaluationSubmit = TeacherEvaluationSubmit;
