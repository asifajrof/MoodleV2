import React, { useEffect, useState } from "react";

const FileEdit = ({ fileID }) => {
  const [fileInfo, setFileInfo] = useState([]);
  useEffect(() => {
    const fetchData = async (fileID) => {
      try {
        const response = await fetch(`/api/file/${fileID}`);
        const jsonData = await response.json();
        setFileInfo(jsonData.data);
        console.log(fileInfo);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData(fileID);
  }, [fileID]);
  const downloadFile = async (fileID) => {
    console.log(fileInfo);
    try {
      const response = await fetch(`/api/file/download/${fileID}`);
      const blobData = await response.blob();
      let url = window.URL.createObjectURL(blobData);
      let a = document.createElement("a");
      a.href = url;
      a.download = fileInfo.file_name;
      a.click();
    } catch (err) {
      console.log(err);
    }
  };
  return (
    <div>
      <button onClick={() => downloadFile(fileID)}>{fileInfo.file_name}</button>
    </div>
  );
};

export default FileEdit;
