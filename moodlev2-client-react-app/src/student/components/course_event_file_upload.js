import React, { useEffect, useState } from "react";
import moment from "moment";
import FileUpload from "./file_upload/FileUpload";
import FileEdit from "./file_edit/FileEdit";
// import "./course_home.css";

const courseEvalueationEventInfoInit = {
  id: 1,
  event_type: "Assignment",
  event_description: "Homework on Chapter 1",
  completed: false,
  event_date: "2022-08-20",
  submitted: false,
  fileIDs: 1, // why array?
};

const StudentCourseEventFileUpload = ({ studentNo, courseId, eventId }) => {
  const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
    {}
  );
  //   const [courseEvalueationEventInfo, setCourseEvalueationEventInfo] = useState(
  //     courseEvalueationEventInfoInit
  //   );
  useEffect(() => {
    const fetchData = async (eventId) => {
      try {
        const response = await fetch(`/api/course/event/${eventId}`);
        const jsonData = await response.json();
        setCourseEvalueationEventInfo(jsonData.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData(eventId);
  }, [eventId]);
  return (
    <div className="course__event__container">
      <div className="course__event__info">
        <div className="course__home__container__event__title">
          {courseEvalueationEventInfo.event_type}
        </div>
        <div className="course__home__container__event__subtitle">
          {moment(courseEvalueationEventInfo.event_date).format("YYYY-MM-DD")}
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
          <div className="course__event__submission__info__col">
            <div>Due date:</div>
            <div>Time remaining:</div>
            <div>File upload:</div>
          </div>
          <div className="course__event__submission__info__col">
            <div>
              {moment(courseEvalueationEventInfo.event_date).format(
                "YYYY-MM-DD HH:mm:ss"
              )}
            </div>
            <>
              {courseEvalueationEventInfo.completed ? (
                <>
                  {courseEvalueationEventInfo.submitted ? (
                    <div className="early__remaining__time">
                      Submitted early by{" "}
                      {courseEvalueationEventInfo.remaining_time}
                    </div>
                  ) : (
                    <div className="overdue__remaining__time">
                      Overdue by {courseEvalueationEventInfo.remaining_time}
                    </div>
                  )}
                </>
              ) : (
                <div className="normal__remaining__time">
                  {courseEvalueationEventInfo.remaining_time}
                </div>
              )}
              {/* <div className="remaining__time" style={{}}>
              {courseEvalueationEventInfo.remaining_time}
            </div> */}
            </>
            {!courseEvalueationEventInfo.submitted &&
            !courseEvalueationEventInfo.completed ? (
              <FileUpload
                studentNo={studentNo}
                courseId={courseId}
                eventId={eventId}
              />
            ) : (
              <>
                {!courseEvalueationEventInfo.submitted ? (
                  <>{/* blank */}</>
                ) : (
                  <FileEdit fileIDs={courseEvalueationEventInfo.fileIDs} />
                )}
              </>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default StudentCourseEventFileUpload;
