import React from "react";

import './upcoming_event.css';

const UpcomingEvent = ({event})=>{
    return (
        <div className='event__container__item'>
            <div className='event__container__item__1'>
                <div >
                {event.type}
                </div>
            </div>
            <div className='event__container__item__2'>
                <div>
                {event.course_code}
                </div>
                <div>
                {event.time}
                </div>
            </div>
        </div>
    )
}

export default UpcomingEvent;