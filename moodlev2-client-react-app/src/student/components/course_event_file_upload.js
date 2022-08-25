import React, { useState } from "react";
import FileUpload from "./file_upload/FileUpload";
import FileEdit from "./file_edit/FileEdit";
// import "./course_home.css";

const courseEvalueationEventInfoInit = {
  id: 1,
  event_type: "Assignment",
  event_description: "Homework on Chapter 1",
  completed: false,
  event_date: "2022-08-20",
  submitted: true,
  fileIDs: [1],
};

const StudentCourseEventFileUpload = ({ studentNo, courseId, eventId }) => {
  // const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
  //   {}
  // );
  const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
    courseEvalueationEventInfoInit
  );
  //   useEffect(() => {
  //     const fetchData = async () => {
  //       try {
  //         const response = await fetch(`/api/course/${courseId}/event/${eventId}`);
  //         const jsonData = await response.json();
  //         setCourseEvalueationEventInfo(jsonData.data);
  //       } catch (err) {
  //         console.log(err);
  //       }
  //     };
  //     fetchData();
  //   }, []);
  return (
    <div className="course__event__container">
      <div className="course__event__info">
        <div className="course__home__container__event__title">
          {courseEvalueationEventInfo.event_type}
        </div>
        <div className="course__home__container__event__subtitle">
          {courseEvalueationEventInfo.event_date}
        </div>

        <div
          className="course__home__container__item__2"
          // style={{ paddingLeft: "1rem" }}
        >
          {courseEvalueationEventInfo.event_description}
        </div>
      </div>
      <div
        className="course__home__container__item__2"
        style={{
          paddingTop: "1rem",
          paddingBottom: "1rem",
          fontWeight: "bold",
        }}
      >
        Submission
      </div>
      <div className="course__event__submission">
        <div className="course__event__submission__info">
          <div className="col_left">
            Due date:
            <br />
            Time remaining:
            <br />
            File upload:
          </div>
          <div className="col_right">
            bla bla bla
            <br />
            bla bla bla
            <br />
            {!courseEvalueationEventInfo.submitted && <FileUpload />}
            {courseEvalueationEventInfo.submitted && (
              <FileEdit fileIDs={courseEvalueationEventInfo.fileIDs} />
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default StudentCourseEventFileUpload;
