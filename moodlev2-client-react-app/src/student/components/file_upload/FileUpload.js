import React, { Fragment, useState } from "react";
import axios from "axios";

import Message from "./Message";
import Progress from "./Progress";
import "./FileUpload.css";

const FileUpload = () => {
  const [file, setFile] = useState("");
  const [filename, setFilename] = useState("Choose File");
  const [uploadedFile, setUploadedFile] = useState({});
  const [message, setMessage] = useState("");
  const [uploadPercentage, setUploadPercentage] = useState(0);

  const onChange = (e) => {
    setFile(e.target.files[0]);
    if (e.target.files[0] !== undefined) {
      setFilename(e.target.files[0].name);
    } else {
      setFilename("Choose File");
    }
  };

  const onSubmit = async (e) => {
    e.preventDefault();

    try {
      const formData = new FormData();
      if (file === "" || file === undefined) {
        console.log("No file selected");
        // raise error
        setMessage("Please select a file");
        // clear message
        setTimeout(() => setMessage(""), 2000);
        return;
      }
      formData.append("file", file);
      const res = await axios.post("/upload", formData, {
        headers: {
          "Content-Type": "multipart/form-data",
        },
        onUploadProgress: (progressEvent) => {
          setUploadPercentage(
            parseInt(
              Math.round((progressEvent.loaded * 100) / progressEvent.total)
            )
          );
        },
      });

      // Clear percentage
      setTimeout(() => setUploadPercentage(0), 1000);
      const { fileName, filePath } = res.data;
      setUploadedFile({ fileName, filePath });
      setMessage("File Uploaded");
      // clear message
      setTimeout(() => setMessage(""), 2000);
      setFile("");
      setFilename("Choose File");
    } catch (err) {
      if (err.response.status === 500) {
        setMessage("There was a problem with the server");
      } else {
        setMessage(err.response.data.msg);
      }
      setUploadPercentage(0);
      // clear message
      setTimeout(() => setMessage(""), 2000);
    }
  };
  return (
    <div
      style={{
        display: "flex",
        flexDirection: "row",
        gap: "1rem",
        alignItems: "center",
      }}
    >
      <form onSubmit={onSubmit}>
        <div className="custom-file">
          <input
            className="custom-file-input"
            type="file"
            // style={{ display: "none" }}
            id="customFile"
            onChange={onChange}
          />

          <label className="custom-file-label" htmlFor="customFile">
            {filename}
          </label>
        </div>
        <br />
        <Progress percentage={uploadPercentage} />
        <input
          type="submit"
          value="Upload"
          className="btn btn-primary btn-block mt-4"
        />
      </form>
      {message ? <Message msg={message} showVal={true} /> : null}
    </div>
  );
};

export default FileUpload;
