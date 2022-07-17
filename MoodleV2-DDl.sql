-- create database moodle_v2;

create table department(
    dept_code INTEGER PRIMARY KEY,
    dept_name VARCHAR(64) UNIQUE NOT NULL,
    dept_shortname VARCHAR(8) UNIQUE NOT NULL
);
create table student(
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL,
    password CHAR(64) NOT NULL CHECK(password SIMILAR TO '[a-zA-Z0-9+/]%' and password SIMILAR TO '%[a-zA-Z0-9+/]'
        and password SIMILAR TO '%[a-zA-Z0-9+/]%'),
    _year INTEGER NOT NULL CHECK (_year>1900 and _year<=date_part('year', CURRENT_DATE)),
    roll_num INTEGER NOT NULL CHECK(roll_num>0),
    dept_code INTEGER NOT NULL REFERENCES department(dept_code),
    notification_last_seen TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    email_address VARCHAR(128) UNIQUE CHECK(email_address LIKE '_%@%_._%' AND email_address NOT LIKE '%@%@%' AND email_address NOT LIKE '% %'),
    unique (roll_num,_year,dept_code)
);
create table official_users(
    user_no SERIAL PRIMARY KEY,
    username VARCHAR(32) UNIQUE NOT NULL CHECK(username SIMILAR TO '[a-zA-Z]%' and username SIMILAR TO '%[a-zA-Z0-9]'
        and username SIMILAR TO '%[a-zA-Z0-9]%'),
    password CHAR(64) NOT NULL CHECK(password SIMILAR TO '[a-zA-Z0-9+/]%' and password SIMILAR TO '%[a-zA-Z0-9+/]'
        and password SIMILAR TO '%[a-zA-Z0-9+/]%'),
    email_address VARCHAR(128) UNIQUE CHECK(email_address LIKE '_%@%_._%' AND email_address NOT LIKE '%@%@%' AND email_address NOT LIKE '% %')
);
create table teacher(
    teacher_id SERIAL PRIMARY KEY,
    teacher_name VARCHAR(255) NOT NULL,
    user_no INTEGER NOT NULL REFERENCES official_users(user_no),
    dept_code INTEGER NOT NULL REFERENCES department(dept_code),
    notification_last_seen TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unique(user_no)
);
create table course(
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    course_num INTEGER NOT NULL CHECK(course_num>=0 and course_num<100),
    dept_code INTEGER NOT NULL REFERENCES department(dept_code),
    _year INTEGER NOT NULL CHECK (_year>1900 and _year<=date_part('year', CURRENT_DATE)),
    level INTEGER NOT NULL CHECK(level>0 and level<6),
    term INTEGER NOT NULL CHECK(term=1 or term=2),
    unique (course_num,dept_code,_year,level)
);
create table instructor(
    instructor_id SERIAL PRIMARY KEY,
    teacher_id INTEGER NOT NULL REFERENCES teacher(teacher_id),
    course_id INTEGER  NOT NULL REFERENCES course(course_id),
    _date DATE NOT NULL DEFAULT CURRENT_DATE CHECK(_date<=CURRENT_DATE),
    unique (teacher_id,course_id)
);
create table section(
    section_no SERIAL PRIMARY KEY ,
    section_name VARCHAR(64) NOT NULL,
    course_id INTEGER NOT NULL REFERENCES course(course_id),
    cr_id INTEGER REFERENCES student(student_id),
    unique (course_id,cr_id)
);
create table enrolment(
    enrol_id SERIAL PRIMARY KEY ,
    student_id INTEGER NOT NULL REFERENCES student(student_id),
    section_id INTEGER NOT NULL REFERENCES section(section_no),
    _date DATE NOT NULL DEFAULT CURRENT_DATE CHECK(_date<=CURRENT_DATE),
    unique (section_id,student_id)
);
create table course_routine(
    class_id SERIAL PRIMARY KEY ,
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    alternation INTEGER CHECK(alternation>0),
    start TIME NOT NULL,
    _end TIME NOT NULL CHECK(_end>start),
    day INTEGER NOT NULL CHECK(day>=0 and day<7),
    unique (day,section_no)
);
create table course_post(
    post_id SERIAL PRIMARY KEY,
    parent_post INTEGER REFERENCES course_post(post_id) DEFAULT NULL,
    poster_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    post_name VARCHAR(255) NOT NULL,
    post_content VARCHAR(8192) NOT NULL,
    post_time TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unique (poster_id,post_time)
);
create table course_post_file(
    file_id SERIAL PRIMARY KEY ,
    post_id INTEGER NOT NULL REFERENCES course_post(post_id),
    file_name VARCHAR(255) NOT NULL,
    file_link VARCHAR(1024) UNIQUE NOT NULL
);
create table topic(
    topic_num SERIAL PRIMARY KEY,
    topic_name VARCHAR(255) NOT NULL,
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    description VARCHAR(2048),
    unique (instructor_id,topic_name)
);
create table resource(
    res_id SERIAL,
    res_name VARCHAR(255) NOT NULL,
    res_link VARCHAR(1024) NOT NULL,
    owner_id INTEGER NOT NULL
);
create table instructor_resource(
    PRIMARY KEY(res_id),
    FOREIGN KEY(owner_id) REFERENCES instructor(instructor_id),
    unique(res_link)
) inherits (resource);
create table student_resource(
    PRIMARY KEY(res_id),
    FOREIGN KEY(owner_id) REFERENCES enrolment(enrol_id),
    unique(res_link)
) inherits (resource);
create table private_file(
    file_id SERIAL,
    owner_id INTEGER NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_link VARCHAR(1024) NOT NULL
);
create table teacher_file(
    PRIMARY KEY (file_id),
    FOREIGN KEY (owner_id) REFERENCES teacher(teacher_id),
    unique(file_link)
) inherits (private_file);
create table student_file(
    PRIMARY KEY (file_id),
    FOREIGN KEY (owner_id) REFERENCES student(student_id),
    unique(file_link)
) inherits (private_file);
create table canceled_class(
    canceled_class_id SERIAL PRIMARY KEY,
    class_id INTEGER NOT NULL REFERENCES course_routine(class_id),
    _date DATE NOT NULL,
    unique(class_id,_date)
);
create table teacher_routine(
    teacher_class_id SERIAL PRIMARY KEY,
    insturctor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    class_id INTEGER NOT NULL REFERENCES course_routine(class_id),
    unique (insturctor_id,class_id)
);
create table extra_class(
    extra_class_id SERIAL PRIMARY KEY ,
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    start TIMESTAMP with time zone  NOT NULL CHECK(start>=CURRENT_TIMESTAMP),
    _end TIMESTAMP with time zone NOT NULL CHECK(_end>start),
    _date DATE NOT NULL,
    unique(section_no,instructor_id,start,_end,_date)
);
create table extra_class_teacher(
    assignment_id SERIAL PRIMARY KEY ,
    extra_class_id INTEGER NOT NULL REFERENCES extra_class(extra_class_id),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    unique(extra_class_id,instructor_id)
);
create table evaluation_type(
    typt_id SERIAL PRIMARY KEY ,
    type_name VARCHAR(64) UNIQUE NOT NULL
);
create table  evaluation(
    evaluation_id SERIAL PRIMARY KEY ,
    type_id INTEGER NOT NULL REFERENCES evaluation_type(typt_id),
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    start TIMESTAMP with time zone  NOT NULL,
    _end TIMESTAMP with time zone NOT NULL CHECK(_end>start),
    _date DATE NOT NULL,
    total_marks FLOAT NOT NULL CHECK(total_marks>0),
    description VARCHAR(2048),
    unique (_date,type_id,section_no,start,_end)
);
create table request_type(
    type_id SERIAL PRIMARY KEY ,
    type_name VARCHAR(64) UNIQUE NOT NULL
);
create table request_event(
    req_id SERIAL PRIMARY KEY ,
    type_id INTEGER NOT NULL REFERENCES request_type(type_id),
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    start TIMESTAMP with time zone  NOT NULL CHECK(start>=CURRENT_TIMESTAMP),
    _end TIMESTAMP with time zone NOT NULL CHECK(_end>start),
    _date DATE NOT NULL,
    notifucation_time TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_marks FLOAT NOT NULL CHECK(total_marks>0),
    unique (type_id,section_no,instructor_id,start,_end,_date)
);
create table visibility(
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(64) UNIQUE NOT NULL
);
create table notification_type(
    type_id SERIAL PRIMARY KEY ,
    type_name VARCHAR(64) NOT NULL,
    visibility INTEGER NOT NULL REFERENCES visibility(type_id),
    unique (visibility,type_name)
);
create table notification_event(
    not_id SERIAL PRIMARY KEY ,
    type_id INTEGER NOT NULL REFERENCES notification_type(type_id),
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    start TIMESTAMP with time zone  NOT NULL CHECK(start>=CURRENT_TIMESTAMP),
    _end TIMESTAMP with time zone NOT NULL CHECK(_end>start),
    _date DATE NOT NULL,
    notifucation_time TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unique (type_id,section_no,instructor_id,start,_end,_date)
);
create table submission(
     sub_id SERIAL PRIMARY KEY ,
     event_id INTEGER NOT NULL REFERENCES evaluation(evaluation_id),
     enrol_id INTEGER NOT NULL REFERENCES enrolment(enrol_id),
     link VARCHAR(1024) UNIQUE NOT NULL,
     sub_time TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
     unique(event_id,enrol_id)
);
create table grading(
    grading_id SERIAL PRIMARY KEY ,
    sub_id INTEGER NOT NULL REFERENCES submission(sub_id),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    total_marks FLOAT NOT NULL CHECK(total_marks>0),
    obtained_marks FLOAT NOT NULL CHECK(obtained_marks<=total_marks),
    remarks VARCHAR(2048),
    _date DATE NOT NULL DEFAULT CURRENT_DATE CHECK(_date<=CURRENT_DATE),
    unique(sub_id,instructor_id)
);
create table admins(
    admin_id SERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    user_no INTEGER NOT NULL REFERENCES official_users(user_no),
    unique(user_no)
);
create table forum_post(
    post_id SERIAL PRIMARY KEY,
    parent_post INTEGER REFERENCES forum_post(post_id) DEFAULT NULL,
    poster INTEGER NOT NULL REFERENCES official_users(user_no),
    post_name VARCHAR(255) NOT NULL,
    post_content VARCHAR(8192) NOT NULL,
    post_time TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unique (poster,post_time)
);
create table forum_post_files(
    file_id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES forum_post(post_id),
    file_name VARCHAR(255) NOT NULL,
    file_link VARCHAR(1024) UNIQUE NOT NULL
);

-- drop table forum_post_files;
-- drop table forum_post;
-- drop table admins;
-- drop table grading;
-- drop table submission;
-- drop table notification_event;
-- drop table notification_type;
-- drop table visibility;
-- drop table request_event;
-- drop table request_type;
--drop table evaluation;
--drop table evaluation_type;
--drop table extra_class_teacher;
--drop table extra_class;
--drop table teacher_routine;
--drop table canceled_class;
--drop table student_file;
--drop table teacher_file;
--drop table private_file;
--drop table student_resource;
--drop table instructor_resource;
--drop table resource;
--drop table topic;
--drop table course_post_file;
--drop table course_post;
--drop table course_routine;
--drop table enrolment;
--drop table section;
--drop table instructor;
--drop table course;
--drop table teacher;
--drop table official_users;
--drop table student;
--drop table department;
--drop database moodle_v2;
