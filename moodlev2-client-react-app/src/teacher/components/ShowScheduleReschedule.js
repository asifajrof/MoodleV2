import React from "react";
import SectionCalendarReschedule from "./SectionCalendarReschedule";

const ShowScheduleReschedule = ({
  userName,
  courseId,
  sectionList,
  rescheduleType,
}) => {
  return (
    <div className="timeline__container">
      <div className="timeline__calendar__container">
        <div className="timeline__calendar__month">
          {sectionList === undefined || sectionList.length === 0 ? (
            <></>
          ) : (
            <SectionCalendarReschedule
              userName={userName}
              courseId={courseId}
              sectionList={sectionList}
              rescheduleType={rescheduleType}
            />
          )}
        </div>
      </div>
    </div>
  );
};

export default ShowScheduleReschedule;
