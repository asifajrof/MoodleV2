import React from "react";
import SectionCalendar from "./section_calendar";

const ShowSchedule = ({ userName, courseId, sectionList }) => {
  return (
    <div className="timeline__container">
      <div className="timeline__calendar__container">
        <div className="timeline__calendar__month">
          {sectionList === undefined || sectionList.length === 0 ? (
            <></>
          ) : (
            <SectionCalendar
              userName={userName}
              courseId={courseId}
              sectionList={sectionList}
            />
          )}
        </div>
      </div>
    </div>
  );
};

export default ShowSchedule;
