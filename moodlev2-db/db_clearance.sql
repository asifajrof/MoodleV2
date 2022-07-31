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
    offered_dept_code INTEGER NOT NULL REFERENCES department(dept_code),
    batch INTEGER NOT NULL CHECK (_year>1900 and _year<=date_part('year', CURRENT_DATE)),
    _year INTEGER NOT NULL CHECK (_year>1900 and _year<=date_part('year', CURRENT_DATE)),
    level INTEGER NOT NULL CHECK(level>0 and level<6),
    term INTEGER NOT NULL CHECK(term=1 or term=2),
    unique (course_num,dept_code,_year,level,offered_dept_code)
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
    unique (day,section_no,start,_end)
);
create table course_post(
    post_id SERIAL PRIMARY KEY,
    parent_post INTEGER REFERENCES course_post(post_id) DEFAULT NULL,
    poster_id INTEGER NOT NULL,
    student_post BOOLEAN NOT NULL DEFAULT FALSE,
    post_name VARCHAR(255) NOT NULL,
    post_content VARCHAR(8192) NOT NULL,
    post_time TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unique (poster_id,post_time,student_post)
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
    finished BOOLEAN NOT NULL DEFAULT FALSE,
    description VARCHAR(2048),
	started TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    class_id INTEGER NOT NULL REFERENCES course_routine(class_id),
    unique (instructor_id,class_id)
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
    type_name VARCHAR(64) UNIQUE NOT NULL,
    notification_time_type BOOLEAN NOT NULL DEFAULT TRUE
);
create table  evaluation(
    evaluation_id SERIAL PRIMARY KEY ,
    type_id INTEGER NOT NULL REFERENCES evaluation_type(typt_id),
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    caption_extension VARCHAR(32) DEFAULT NULL,
    start TIMESTAMP with time zone  NOT NULL,
    _end TIMESTAMP with time zone NOT NULL CHECK(_end>start),
    _date DATE NOT NULL,
    total_marks FLOAT NOT NULL CHECK(total_marks>0),
    description VARCHAR(2048),
    unique (_date,type_id,section_no,start,_end)
);
create table extra_evaluation_instructor(
    assignment_id SERIAL PRIMARY KEY ,
    evaluation_id INTEGER NOT NULL REFERENCES evaluation(evaluation_id),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    unique(evaluation_id,instructor_id)
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
     link VARCHAR(1024) UNIQUE DEFAULT NULL,
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
create or replace function term_name(term_num integer) returns varchar(64) as $$
    declare
        ans varchar(64);
    begin
        ans := 'January';
        if (term_num = 2) then
            ans := 'July';
        end if;
        return ans;
    end
$$ language plpgsql;

create materialized view current_courses as
select c.course_id as _id,term_name(term) as _term,_year as __year,dept_shortname as _dept_shortname,(level*100+course_num) as _course_code, course_name as _course_name from course c join department d on c.dept_code = d.dept_code
where not exists(
    select course_id from course cc
    where cc._year>c._year or (cc._year=c._year and cc.term>c.term)
) with data;

create materialized view intersected_sections as
select e.section_id first_section, f.section_id second_section, count(*) common_students
from
    (
        select e.section_id,e.student_id
        from section s join enrolment e on s.section_no = e.section_id join course c on c.course_id = s.course_id join student s2 on e.student_id = s2.student_id
        where s2._year=c.batch
    ) e join
    (
        select e.section_id,e.student_id
        from section s join enrolment e on s.section_no = e.section_id join course c on c.course_id = s.course_id join student s2 on e.student_id = s2.student_id
        where s2._year=c.batch
    ) f on e.student_id = f.student_id
group by e.section_id,f.section_id with data ;
create or replace function get_dept_list ()
    returns table (dept_code integer,dept_name varchar,dept_shortname varchar) as $$
begin
    return query
    select * from department;
end
$$ language plpgsql;
create or replace function add_student(name varchar,hashed_password varchar,roll integer,dept integer,batch integer, email varchar) returns void as $$
    begin
        insert into student(student_id,student_name, password, _year, roll_num, dept_code, email_address)
        values (default,name,hashed_password,batch,roll,dept,email);
    end;
$$ language plpgsql;
create or replace function add_teacher(name varchar,uname varchar,hashed_password varchar,dept integer, email varchar) returns void as $$
    declare
        uno integer;
    begin
        insert into official_users(user_no, username, password, email_address)
        values (default,uname,hashed_password,email);
        select user_no into uno from official_users
        where username=uname;
        insert into teacher(teacher_id, teacher_name, user_no, dept_code)
        values (default,name,uno,dept);
    end;
$$ language plpgsql;
create or replace function add_course(cname varchar,cnum integer,dept integer,offered_dept integer,offered_batch integer,offered_year integer,offered_level integer,offered_term integer) returns void as $$
    begin
        insert into course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term)
        values(default,cname,cnum,dept,offered_dept,offered_batch,offered_year,offered_level,offered_term);
    end;
$$ language plpgsql;
create or replace function overlapped_timestamp(first_begin timestamp,first_end timestamp,second_begin timestamp,second_end timestamp) returns boolean as $$
    declare
        ans boolean;
    begin
        ans=false;
        if (first_begin<= second_begin and second_begin<first_end) then
            ans=true;
        elsif (first_begin< second_end and second_end<=first_end) then
            ans=true;
        elsif (second_begin<= first_begin and first_begin<second_end) then
            ans=true;
        elsif (second_begin< first_end and first_end<=second_end) then
            ans=true;
        end if;
        return ans;
    end;
$$ language plpgsql;
create or replace function overlapped_time(first_begin time,first_end time,second_begin time,second_end time) returns boolean as $$
    declare
        ans boolean;
    begin
        ans=false;
        if (first_begin<= second_begin and second_begin<first_end) then
            ans=true;
        elsif (first_begin< second_end and second_end<=first_end) then
            ans=true;
        elsif (second_begin<= first_begin and first_begin<second_end) then
            ans=true;
        elsif (second_begin< first_end and first_end<=second_end) then
            ans=true;
        end if;
        return ans;
    end;
$$ language plpgsql;
create or replace function section_to_course(sec_no integer) returns integer as $$
    declare
        ans integer;
    begin
        select course_id into ans from section
            where section_no=sec_no;
        return ans;
    end
$$ language plpgsql;
create or replace function get_current_course (std_id integer)
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar,submitted integer) as $$
begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name,count(ev.evaluation_id)::integer
from ((
    (select student_id from student
    where (mod(student._year,100)*100000+dept_code*1000+roll_num)=std_id
     ) s join (
         select enrol_id,student_id,section_id from enrolment
    ) e on s.student_id=e.student_id join section sec on e.section_id=sec.section_no join current_courses cc on sec.course_id=cc._id)
left outer join evaluation ev on (ev.section_no=e.section_id and ev._end<current_timestamp)) left outer join submission s2 on (s2.enrol_id=e.enrol_id)
group by _id,_term,__year,_dept_shortname,_course_code,_course_name;
end
$$ language plpgsql;
create or replace function get_upcoming_events (std_id integer)
    returns table (id integer,dept_shortname varchar,course_code integer, lookup_time time,event_type varchar) as $$
begin
    return query
    select cc._id,cc._dept_shortname,cc._course_code, _lookup_time,_event_type from (
                                                  ((select section_no, start::time as _lookup_time, cast('Class' as varchar) as _event_type
                                                    from course_routine cr
                                                    where day = extract(isodow from current_date) - 1
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = current_date and start::time>current_time
                                                        ))
                                                   union
                                                   (select section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type
                                                    from extra_class
                                                    where start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, start::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.typt_id = e.type_id and et.notification_time_type = false)
                                                                      and start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, _end::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.typt_id = e.type_id and et.notification_time_type = true)
                                                                      and _end::date = current_date and _end::time>current_time))) ut join
    (
        select section_id from enrolment join student on (enrolment.student_id = student.student_id) where mod(_year,100)*100000+dept_code*1000+roll_num=std_id
    ) ss on (ut.section_no=ss.section_id) join section s on (ss.section_id=s.section_no) join current_courses cc on (s.course_id=cc._id)
    order by _lookup_time;
end
$$ language plpgsql;
create or replace function get_course_topics (courseID integer)
    returns table (topic_number integer,teacher_number integer,instructor_number integer,title varchar,topic_description varchar,teacherName varchar,isFinished boolean, start_time timestamp with time zone) as $$
    begin
	return query
    select topic_num, t.teacher_id, i.instructor_id, topic_name,description,teacher_name,finished,started
from topic tp join instructor i on tp.instructor_id = i.instructor_id join current_courses c on c._id = i.course_id join teacher t on i.teacher_id = t.teacher_id
where course_id = courseID
order by started;
    end
$$ language plpgsql;
create or replace function instructor_check() returns trigger as $instructor_assignment$
declare
    teacher_dept integer;
    course_dept integer;
begin
    select dept_code into teacher_dept from teacher
    where teacher_id=new.teacher_id;
    select dept_code into course_dept from course
    where course_id=new.course_id;
    if (teacher_dept!=course_dept or teacher_dept is null or course_dept is null) then
        raise exception 'Invalid data insertion or update';
    elsif (old.course_id is not null and old.course_id!=new.course_id) then
        raise exception 'Invalid data insertion or update';
    elsif (old.teacher_id is not null and old.teacher_id!=new.teacher_id) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$instructor_assignment$ language plpgsql;

create trigger instructor_assignment before insert or update on instructor
     for each row execute function instructor_check();

create or replace function instructor_section_compare(new_ins_id integer,new_sec_no integer,old_ins_id integer,old_sec_no integer)
    returns boolean as $$
    declare
    instructor_course integer;
    section_course integer;
    begin
        if (new_sec_no is null or new_ins_id is null) then
            return true;
        elsif (old_ins_id is not null and old_ins_id!=new_ins_id) then
            return true;
        elsif (old_sec_no is not null and old_sec_no!=new_sec_no) then
            return true;
        end if;
        select course_id into instructor_course from instructor
        where instructor_id=new_ins_id;
        select course_id into section_course from section
        where section_no=new_sec_no;
        if (instructor_course is null or section_course is null) then
            return true;
        elsif (instructor_course!=section_course) then
            return true;
        end if;
        return false;
    end;
    $$ language plpgsql;
create or replace function cr_assignment_check() returns trigger as $cr_assignment$
declare
    course_cnt integer;
begin
    if (new.section_no is null) then
        raise exception 'Invalid data insertion or update';
    elsif (new.cr_id is null) then
        return new;
    else
        select count(*) into course_cnt
        from enrolment
        where student_id=new.cr_id and section_id=new.section_no;
        if (course_cnt=0) then
            raise exception 'Invalid data insertion or update';
        end if;
    end if;
    return new;
end;
$cr_assignment$ language plpgsql;

create trigger cr_assignment before insert or update on section
     for each row execute function cr_assignment_check();

create or replace function teacher_routine_check() returns trigger as $teacher_routine_validation$
declare
    sec_no integer;
begin
    if (new.class_id is null or new.instructor_id is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    select section_no into sec_no from course_routine
    where class_id=new.class_id;
    if (instructor_section_compare(new.instructor_id,sec_no,old.instructor_id,null)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$teacher_routine_validation$ language plpgsql;

create trigger teacher_routine_validation before insert or update on teacher_routine
     for each row execute function teacher_routine_check();

create or replace function extra_class_check() returns trigger as $extra_class_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$extra_class_validation$ language plpgsql;

create trigger extra_class_validation before insert or update on extra_class
     for each row execute function extra_class_check();

create or replace function evaluation_check() returns trigger as $evaluation_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$evaluation_validation$ language plpgsql;

create trigger evaluation_validation before insert or update on evaluation
     for each row execute function evaluation_check();

create or replace function extra_teacher_check() returns trigger as $extra_teacher_validation$
declare
    sec_no integer;
begin
    if (new.extra_class_id is null or new.instructor_id is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    select section_no into sec_no from extra_class
    where extra_class_id=new.extra_class_id;
    if (instructor_section_compare(new.instructor_id,sec_no,old.instructor_id,null)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$extra_teacher_validation$ language plpgsql;

create trigger extra_teacher_validation before insert or update on extra_class_teacher
     for each row execute function extra_teacher_check();

create or replace function request_event_check() returns trigger as $request_event_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$request_event_validation$ language plpgsql;

create trigger request_event_validation before insert or update on request_event
     for each row execute function request_event_check();

create or replace function notification_event_check() returns trigger as $notification_event_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$notification_event_validation$ language plpgsql;

create trigger notification_event_validation before insert or update on notification_event
     for each row execute function notification_event_check();

create or replace function submission_check() returns trigger as $submission_validation$
declare
    sec_no_event integer;
    sec_no_enrol integer;
    course_id_event integer;
    course_id_enrol integer;
begin
    if (new.event_id is null or new.enrol_id is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    select section_no into sec_no_event from evaluation
    where evaluation_id=new.event_id;
    select section_id into sec_no_enrol from enrolment
    where enrol_id=new.enrol_id;
    if (sec_no_enrol is null or sec_no_event is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    select course_id into course_id_event from section
    where section_no=sec_no_event;
    select course_id into course_id_enrol from section
    where section_no=sec_no_enrol;
    if (course_id_enrol is null or course_id_event is null) then
        raise exception 'Invalid data insertion or update';
    elsif(course_id_event!=course_id_enrol) then
        raise exception 'Invalid data insertion or update';
    end if;

    return new;
end;
$submission_validation$ language plpgsql;

create trigger submission_validation before insert or update on submission
     for each row execute function submission_check();

create or replace function grading_check() returns trigger as $grading_validation$
declare
    enrol integer;
    sec_no integer;
    course_sub integer;
    course_ins integer;
begin
    if (new.sub_id is null or new.instructor_id is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    -- submission id to enrol id
    select enrol_id into enrol from submission
    where sub_id=new.sub_id;
    if (enrol is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    -- enrolment to section
    select section_id into sec_no from enrolment
    where enrol_id=enrol;
    if (sec_no is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    --section to course
    select course_id into course_sub from section
    where section_no=sec_no;
    --instructor to course
    select course_id into course_ins from instructor
    where instructor_id=new.instructor_id;
    if (course_ins is null or course_sub is null) then
        raise exception 'Invalid data insertion or update';
    elsif (course_ins!=course_sub) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$grading_validation$ language plpgsql;

create trigger grading_validation before insert or update on grading
     for each row execute function grading_check();

create or replace function curr_course_update () returns trigger as $curr_course_validation$
declare
begin
    refresh materialized view current_courses;
    return null;
end;
$curr_course_validation$ language plpgsql;

create trigger curr_course_validation after insert or update or delete on course
     for each statement execute function curr_course_update();

create or replace function intersected_section_update () returns trigger as $intersected_section_validation$
declare
begin
    refresh materialized view intersected_sections;
    return null;
end;
$intersected_section_validation$ language plpgsql;

create trigger intersected_section_validation after insert or update or delete on enrolment
     for each statement execute function intersected_section_update();

create or replace function cancel_class_day_check() returns trigger as $cancel_class_validation$
declare
    ccd integer;
	cnt integer;
begin
	ccd:=extract(isodow from new._date) - 1;
    select count(class_id) into cnt from course_routine
    where class_id=new.class_id and day=ccd;
    if (cnt=0 or new.class_id is null or ccd is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$cancel_class_validation$ language plpgsql;

create trigger cancel_class_validation before insert or update on canceled_class
     for each row execute function cancel_class_day_check();

create or replace function poster_check() returns trigger as $post_check$
declare
    cnt integer;
begin
    if (new.poster_id is null or new.student_post is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    cnt:=0;
    if (new.student_post) then
        if (new.parent_post is null) then
            raise exception 'Invalid data insertion or update';
        end if;
        select count(*) into cnt from enrolment
        where enrol_id=new.poster_id;
    else
        select count(*) into cnt from instructor
        where instructor_id=new.poster_id;
    end if;
    if (cnt = 0) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$post_check$ language plpgsql;

create trigger post_check before insert or update on course_post
     for each row execute function poster_check();

-- drop trigger post_check on course_post;
-- drop function poster_check();
-- drop trigger cancel_class_validation on canceled_class;
-- drop function cancel_class_day_check();
-- drop trigger intersected_section_validation on enrolment;
-- drop function intersected_section_update();
-- drop trigger curr_course_validation on course;
-- drop function curr_course_update();
-- drop trigger grading_validation on grading;
-- drop function grading_check();
-- drop trigger submission_validation on submission;
-- drop function submission_check();
-- drop trigger notification_event_validation on notification_event;
-- drop function notification_event_check();
-- drop trigger request_event_validation on request_event;
-- drop function request_event_check();
-- drop trigger extra_teacher_validation on extra_class_teacher;
-- drop function extra_teacher_check();
-- drop trigger evaluation_validation on evaluation;
-- drop function evaluation_check();
-- drop trigger extra_class_validation on extra_class;
-- drop function extra_class_check();
-- drop trigger teacher_routine_validation on teacher_routine;
-- drop function teacher_routine_check();
-- drop trigger cr_assignment on section;
-- drop function cr_assignment_check();
-- drop function instructor_section_compare(new_ins_id integer, new_sec_no integer, old_ins_id integer, old_sec_no integer);
-- drop trigger instructor_assignment on instructor;
-- drop function instructor_check();
-- drop function get_course_topics(courseID integer);
-- drop function get_upcoming_events(std_id integer);
-- drop function get_current_course(std_id integer);
-- drop function section_to_course(sec_no integer);
-- drop function overlapped_time(first_begin time,first_end time,second_begin time,second_end time);
-- drop function overlapped_timestamp(first_begin timestamp,first_end timestamp,second_begin timestamp,second_end timestamp);
-- drop function add_course(cname varchar, cnum integer, dept integer, offered_dept integer, offered_batch integer, offered_year integer, offered_level integer, offered_term integer);
-- drop function add_teacher(name varchar, uname varchar, hashed_password varchar, dept integer, email varchar);
-- drop function add_student(name varchar,hashed_password varchar,roll integer,dept integer,batch integer, email varchar);
-- drop function get_dept_list();
-- drop materialized view intersected_sections;
-- drop materialized view current_courses;
-- drop function term_name(term_num integer);
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
-- drop table extra_evaluation_instructor;
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
