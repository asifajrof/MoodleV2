const pool = require("../models/db_connect");
const HttpError = require("../models/http-error");
const fs = require("fs");
const Path = require("path");

const fileInfoDummy = {
	id: 1,
	file_name: "file name 1.pdf",
};

//work to be done after getting query
const getStudentAssignmentSubmittedFileInfo = async (req, res, next) => {
	// console.log("getFileInfo");
	try {
		const submissionId = req.params.fileID;
		// console.log("fileID " + fileID);

		// let result1 = await pool.query(
		//   "SELECT json_agg(t) FROM get_account_type($1) as t",
		//   [fileID]
		// );
		// const filePath = result1.rows[0].json_agg;
		const fileInfo = fileInfoDummy;

		if (!fileInfo) {
			// --> change it to filePath
			res.json({ message: "No fileInfo!", data: [] });
		} else {
			// const filenNme = Path.basename(filePath);
			// res.json({
			// 	message: "getStudentAssignmentSubmittedFileInfo",
			// 	data: filenNme,
			// });
			res.json({
				message: "getFileInfo",
				data: fileInfo,
			});
		}
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

//work to be done after getting query
const getStudentCourseAssignmentSubmittedFile = async (req, res, next) => {
	// console.log("getFile");
	try {
		const submissionId = req.params.fileID;
		const fileName = "file.pdf";
		const folderPath = `${__dirname}/../../moodlev2-client-react-app/public/uploads/`;
		const fileURL = `${folderPath}/file.pdf`;
		const stream = fs.createReadStream(fileURL);
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

		console.log(studentNo, courseId, eventId);

		const folderPath = `${__dirname}/../Files/course/${courseId}/event/${eventId}/student/${studentNo}/`;
		if (!fs.existsSync(folderPath)) {
			console.log("folder does not exist");
			fs.mkdirSync(folderPath, { recursive: true });
		}
		let fileMovePath = `${folderPath}${file.name}`;
		// check if already exists
		if (fs.existsSync(fileMovePath)) {
			console.log("file exists");
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
	} catch (error) {
		return next(new HttpError(error.message, 500));
	}
};

exports.getStudentCourseAssignmentSubmittedFile =
	getStudentCourseAssignmentSubmittedFile;
exports.getStudentAssignmentSubmittedFileInfo =
	getStudentAssignmentSubmittedFileInfo;
exports.StudentCourseAssignmentSubmit = StudentCourseAssignmentSubmit;
