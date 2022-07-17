import React from "react";


const UpcomingEvent = ({event})=>{

    console.log('Before Entering HTML');
    return (
        <>
            <h1>
            {event.type}
            </h1>
            <h1>
            {event.course_code}
            </h1>
            <h1>
            {event.time}
            </h1>
        </>
    )
}

export default UpcomingEvent;