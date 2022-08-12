const express = require("express");
const bodyParser = require("body-parser");
const fileUpload = require("express-fileupload");
const cors = require("cors");

const studentRoutes = require("./routes/student-routes");
const sharedRoutes = require("./routes/shared-routes");
const adminRoutes = require("./routes/admin-routes");
const HttpError = require("./models/http-error");

const pool = require("./models/db_connect");

const app = express();
app.use(bodyParser.json());
app.use(fileUpload());
app.use(cors());

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server started on port ${PORT}`));

app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, DELETE");
  next();
});

app.use("/api/student", studentRoutes);
app.use("/api/course", sharedRoutes);
app.use("/api/admin", adminRoutes);

app.use("/api/login", (req, res) => {
  res.send({
    token: "test123",
    type: "student",
    id: 1705119,
  });
});

// upload endpoint
app.post("/upload", (req, res) => {
  if (req.files === null) {
    return new HttpError("No file uploaded", 400);
  }
  const file = req.files.file;
  file.mv(
    `${__dirname}/../moodlev2-client-react-app/public/uploads/${file.name}`,
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).send(err);
      }
      res.json({ fileName: file.name, filePath: `/uploads/${file.name}` });
    }
  );
});

app.use((req, res, next) => {
  const error = new HttpError("Could not find this route.", 404);
  next(error);
});

// default error handler
app.use((error, req, res, next) => {
  if (res.headerSent) {
    return next(error);
  }
  res.status(error.status || 500);
  res.json({ message: error.message || "An unknown error occurred!" });
});
