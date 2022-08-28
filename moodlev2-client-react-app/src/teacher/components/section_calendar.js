import React, { useEffect, useState } from "react";
import { Calendar } from "react-calendar";
import moment from "moment";
import "./section_calendar.css";
import SectionTileContent from "./section_tile_content";

const SectionCalendar = ({ userName, courseId, sectionList }) => {
  const [sectionNames, setSectionNames] = useState("");
  const [sectionIDs, setSectionIDs] = useState([]);
  useEffect(() => {
    const sectionNamesNew = sectionList.map((s) => s.secname);
    setSectionNames(sectionNamesNew.join(", "));
    const sectionIDsNew = sectionList.map((s) => s.secno);
    setSectionIDs(sectionIDsNew);
  }, [sectionList]);

  const [dateState, setDateState] = useState(new Date());
  const changeDate = (e) => {
    setDateState(e);
  };

  const tileContent = ({ date, view }) => {
    return (
      <div className="calendar__monthly__event__container">
        <SectionTileContent
          date={date}
          view={view}
          sectionIDList={sectionIDs}
        />
      </div>
    );
  };

  const tileClassName = ({ date, view }) => {
    if (view === "month") {
      let returnStr = "";
      const dateMoment = moment(date);
      const day = dateMoment.day();
      if (day === 4) {
        // thursday
        returnStr += " react-calendar__month-view__buet__weekend";
      } else if (day === 5) {
        // friday
        returnStr += " react-calendar__month-view__buet__weekend";
      }
      return returnStr;
    }
  };

  return (
    <div>
      <div className="sched__calendar__title">
        Schedule for Sections: {sectionNames}
      </div>
      <div className="calendar__monthly__container">
        <Calendar
          calendarType="Arabic"
          value={dateState}
          onChange={changeDate}
          tileClassName={tileClassName}
          tileContent={tileContent}
        />
      </div>
    </div>
  );
};

export default SectionCalendar;
