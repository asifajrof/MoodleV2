import React from "react";
import { Link } from "react-router-dom";
import {FaAngleRight} from 'react-icons/fa';

import UpcomingEvent from "./upcoming_events/upcoming_event";

import './upcoming_events.css';

const events = [
    {
        type: "Class Test",
        course_code: "CSE 405",
        time: "08:00 am"
    },
    {
        type: "Class",
        course_code: "CSE 409",
        time: "09:00 am"
    },
    {
        type: "Online",
        course_code: "CSE 408",
        time: "02:00 pm"
    },
    {
        type: "Offline",
        course_code: "CSE 410",
        time: "11:00 pm"
    }

]

const UpcomingEvents = ({studentNo})=>{
    const getEvents = (studentNo) =>{
        return events;
    }
    const eventList = getEvents(studentNo)
    return (
        <>
        <div className='event__container__title'>Upcoming Classes/Events</div>
        <div className='event__container'>

            {eventList.map((event, index) =>(
                <UpcomingEvent key={index} event={event} />
            ))}
            <div>
                <Link to='/timeline' style={{width:'5rem',display:'flex', flexDirection:'row', justifyContent:'space-between', fontSize:'0.8rem'}}>See All   <FaAngleRight /></Link>
            </div>
        </div>
        </>
    )
}

export default UpcomingEvents;