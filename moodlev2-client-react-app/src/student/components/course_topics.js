import React, {useEffect, useState} from "react";
// import CourseTopic from "./course_topics/course_topic";
import CourseTopicsTable from "./course_topics/course_topics_table";

// import './course_topics.css';

const CourseTopics = ({studentNo, courseId}) => {
    // const [currentCoursesList, setCurrentCoursesList] = useState(course_list);
    const [courseTopicList, setCourseTopicList] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch(`/api/course/topics/${courseId}`);
                const jsonData = await response.json();
                setCourseTopicList(jsonData.data);
            } catch (err) {
                console.log(err);
            }
        };
        fetchData();
    }, []);

    return (
        // <div className='course__container'>
        //     {currentCoursesList.map( (course, index) => (
        //         <RegisteredCourse key={index} course={course} />
        //     ))}
        // </div>
        <div style={{ width:'100%', paddingRight: '4rem' }}>
            <CourseTopicsTable courseTopicList={courseTopicList}/>
        </div>
    )
}

export default CourseTopics;
