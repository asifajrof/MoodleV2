import React, { useState } from "react";
import TheCalendar from "./calendar/TheCalendar";

const mark = ["15-08-2022", "16-08-2022", "17-08-2022", "01-09-2022"];

const MiniCalendar = ({ uId }) => {
  return <TheCalendar uId={uId} markDateList={mark} />;
};

export default MiniCalendar;
