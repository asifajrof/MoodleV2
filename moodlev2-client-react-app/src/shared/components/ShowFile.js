import React, { useEffect, useState } from "react";
import FileDownloadIcon from "@mui/icons-material/FileDownload";
import { Button } from "@mui/material";

const ShowFile = ({ fileID }) => {
  const [fileInfo, setFileInfo] = useState([]);
  //   useEffect(() => {
  //     const fetchData = async (fileID) => {
  //       try {
  //         // console.log(fileID);
  //         const response = await fetch(
  //           `/api/file/edit/student/course/evaluation/${fileID}`
  //         );
  //         const jsonData = await response.json();
  //         setFileInfo(jsonData.data);
  //         // console.log(jsonData.data);
  //       } catch (err) {
  //         console.log(err);
  //       }
  //     };
  //     fetchData(fileID);
  //   }, [fileID]);
  // const downloadFile = async (fileID) => {
  //     console.log(fileInfo);
  //     try {
  //         const response = await fetch(
  //             `/api/file/download/student/course/evaluation/${fileID}`
  //         );
  //         const blobData = await response.blob();
  //         let url = window.URL.createObjectURL(blobData);
  //         let a = document.createElement("a");
  //         a.href = url;
  //         a.download = fileInfo.file_name;
  //         a.click();
  //     } catch (err) {
  //         console.log(err);
  //     }
  // };
  return (
    <div>
      <Button variant="outlined">
        <FileDownloadIcon />
        filedownload
      </Button>
      {/* <button onClick={() => downloadFile(fileID)}>{fileInfo.file_name}</button> */}
    </div>
  );
};

export default ShowFile;
