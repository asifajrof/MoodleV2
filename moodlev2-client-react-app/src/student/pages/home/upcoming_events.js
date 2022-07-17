import React from "react";
import UpcomingEvent from "./upcoming/upcoming_event";

const events = [
    {
        type: "Class",
        course_code: "CSE 405",
        time: "09:00 am"
    },
    {
        type: "Class Test",
        course_code: "CSE 409",
        time: "09:00 am"
    }
]

const UpcomingEvents = ({studentNo})=>{
    const getEvents = (studentNo) =>{
        return events;
    }
    const eventList = getEvents(studentNo)
    return (
        <>
        thalfrasldf
        {eventList.forEach((event) =>{
            console.log('sgfsdgjsg');
            <UpcomingEvent event={event} />
        })}
        </>
    )
}

export default UpcomingEvents;