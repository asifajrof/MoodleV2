import { Button, ToggleButton, ToggleButtonGroup } from "@mui/material";
import React, { Fragment, useState } from "react";
import PropTypes from "prop-types";

import "./student_timeline.css";
import MonthlyCalendar from "../../shared/components/monthly_calendar";

const StudentTimeline = ({ studentNo, currentView }) => {
  // will show weekly view by default
  const [view, setView] = useState(currentView);
  const handleToggleChange = (event, newView) => {
    setView(newView);
  };

  return (
    <div className="timeline__container">
      <div className="timeline__title">Timeline</div>
      <div className="timeline__calendar__container">
        <div className="timeline__calendar__button__container">
          <div></div>
          <ToggleButtonGroup
            color="primary"
            value={view}
            exclusive
            onChange={handleToggleChange}
          >
            <ToggleButton value="week">Week</ToggleButton>
            <ToggleButton value="month">Month</ToggleButton>
          </ToggleButtonGroup>
          <div>filter idk :/</div>
        </div>

        {view === "week" && (
          <div className="timeline__calendar__week">weekly view</div>
        )}
        {view === "month" && (
          <div className="timeline__calendar__month">
            <MonthlyCalendar uId={studentNo} />
          </div>
        )}
      </div>
    </div>
  );
};

export default StudentTimeline;

StudentTimeline.protoTypes = {
  studentNo: PropTypes.number.isRequired,
  currentView: PropTypes.string,
};

StudentTimeline.defaultProps = {
  currentView: "week",
};
