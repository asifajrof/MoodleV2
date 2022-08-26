-- create database moodle_v2;

create table department(
    dept_code INTEGER PRIMARY KEY,
    dept_name VARCHAR(64) UNIQUE NOT NULL,
    dept_shortname VARCHAR(8) UNIQUE NOT NULL
);
create table student(
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(255) NOT NULL,
    password CHAR(60) NOT NULL CHECK(password SIMILAR TO '[a-zA-Z0-9+./$]%' and password SIMILAR TO '%[a-zA-Z0-9+./$]'
        and password SIMILAR TO '%[a-zA-Z0-9+./$]%'),
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
    password CHAR(60) NOT NULL CHECK(password SIMILAR TO '[a-zA-Z0-9+./$]%' and password SIMILAR TO '%[a-zA-Z0-9+./$]'
        and password SIMILAR TO '%[a-zA-Z0-9+./$]%'),
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
create table teacher_routine(
    teacher_class_id SERIAL PRIMARY KEY,
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    class_id INTEGER NOT NULL REFERENCES course_routine(class_id),
    unique (instructor_id,class_id)
);
create table canceled_class(
    canceled_class_id SERIAL PRIMARY KEY,
    class_id INTEGER NOT NULL,
    _date DATE NOT NULL DEFAULT CURRENT_DATE,
    instructor_id INTEGER NOT NULL,
    FOREIGN KEY (class_id,instructor_id) REFERENCES teacher_routine(class_id,instructor_id),
    unique(class_id,_date)
);
create table extra_class(
    extra_class_id SERIAL PRIMARY KEY ,
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    start TIMESTAMP with time zone  NOT NULL CHECK(start>=CURRENT_TIMESTAMP),
    _end TIMESTAMP with time zone NOT NULL CHECK(_end>start),
    _date DATE NOT NULL DEFAULT CURRENT_DATE,
    unique(section_no,instructor_id,start,_end,_date)
);
create table extra_class_teacher(
    assignment_id SERIAL PRIMARY KEY ,
    extra_class_id INTEGER NOT NULL REFERENCES extra_class(extra_class_id),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    unique(extra_class_id,instructor_id)
);
create table evaluation_type(
    type_id SERIAL PRIMARY KEY ,
    type_name VARCHAR(64) UNIQUE NOT NULL,
    notification_time_type BOOLEAN NOT NULL DEFAULT TRUE
);
create table  evaluation(
    evaluation_id SERIAL PRIMARY KEY ,
    type_id INTEGER NOT NULL REFERENCES evaluation_type(type_id),
    section_no INTEGER NOT NULL REFERENCES section(section_no),
    instructor_id INTEGER NOT NULL REFERENCES instructor(instructor_id),
    caption_extension VARCHAR(32) DEFAULT NULL,
    start TIMESTAMP with time zone  NOT NULL,
    _end TIMESTAMP with time zone NOT NULL CHECK(_end>start),
    _date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_marks FLOAT NOT NULL CHECK(total_marks>0),
    description VARCHAR(2048),
	link VARCHAR(1024) UNIQUE DEFAULT NULL,
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
    _date DATE NOT NULL DEFAULT CURRENT_DATE,
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
    event_no INTEGER NOT NULL,
    event_type INTEGER NOT NULL,
    _date DATE NOT NULL DEFAULT CURRENT_DATE,
    notifucation_time TIMESTAMP with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    unique (type_id,event_no,event_type,_date)
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

create materialized view all_courses as
select c.course_id as _id,term_name(term) as _term,_year as __year,dept_shortname as _dept_shortname,(level*100+course_num) as _course_code, course_name as _course_name from course c join department d on c.dept_code = d.dept_code
 with data;

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
where e.section_id!=f.section_id
group by e.section_id,f.section_id with data ;
create or replace function get_dept_list ()
    returns table (dept_code integer,dept_name varchar,dept_shortname varchar) as $$
begin
    return query
    select * from department;
end
$$ language plpgsql;
create or replace function get_account_type (uname varchar)
    returns table (id integer,type varchar,hashed_password char(60)) as $$
begin
    return query
    select t.teacher_id as _id,cast('Teacher' as varchar) as _type, password from teacher t join official_users ou on t.user_no=ou.user_no
where ou.username=uname
union
select a.admin_id as _id,cast('Admin' as varchar) as _type,password from admins a join official_users ou on a.user_no=ou.user_no
where ou.username=uname
union
select student_id as _id, cast('Student' as varchar) as _type,password from student where cast((mod(_year,100)*100000+dept_code*1000+roll_num) as varchar)=uname;
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
create function add_admin(admin_name character varying, uname character varying, hashed_password character varying, email character varying) returns void
    language plpgsql
as
$$
    declare
        uno integer;
    begin
        insert into official_users(user_no, username, password, email_address)
        values (default,uname,hashed_password,email);
        select user_no into uno from official_users
        where username=uname;
        insert into admins(admin_id, name, user_no)
        values (default,admin_name,uno);
    end;
$$;
create or replace function add_course(cname varchar,cnum integer,dept integer,offered_dept integer,offered_batch integer,offered_year integer,offered_level integer,offered_term integer) returns void as $$
    begin
        insert into course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term)
        values(default,cname,cnum,dept,offered_dept,offered_batch,offered_year,offered_level,offered_term);
    end;
$$ language plpgsql;
create or replace function overlapped_timestamp(first_begin timestamp with time zone,first_end timestamp with time zone,second_begin timestamp with time zone,second_end timestamp with time zone) returns boolean as $$
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
left outer join evaluation ev on (ev.section_no=e.section_id and ev._end>current_timestamp)) left outer join submission s2 on (s2.enrol_id=e.enrol_id)
group by _id,_term,__year,_dept_shortname,_course_code,_course_name;
end
$$ language plpgsql;
create or replace function get_all_course (std_id integer)
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar,submitted integer) as $$
begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name,count(ev.evaluation_id)::integer
from ((
    (select student_id from student
    where (mod(student._year,100)*100000+dept_code*1000+roll_num)=std_id
     ) s join (
         select enrol_id,student_id,section_id from enrolment
    ) e on s.student_id=e.student_id join section sec on e.section_id=sec.section_no join all_courses cc on sec.course_id=cc._id)
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
                                                    where day = extract(isodow from current_date) - 1 and start::time>current_time
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = current_date
                                                        ))
                                                   union
                                                   (select section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type
                                                    from extra_class
                                                    where start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, start::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, _end::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = true)
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

create or replace function extra_class_check() returns trigger as $extra_class_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    if (event_class_conflict(new.start::time,new._end::time,new.start::date,new.section_no,new.instructor_id)) then
        raise exception 'Invalid data insertion or update';
    end if;
    if (event_event_conflict(new.start,new._end,new.section_no,new.instructor_id)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$extra_class_validation$ language plpgsql;

create trigger extra_class_validation before insert or update on extra_class
     for each row execute function extra_class_check();

create or replace function evaluation_check() returns trigger as $evaluation_validation$
declare
    b boolean;
begin
    b:=true;
    select et.notification_time_type into b from evaluation_type et
    where et.type_id=new.type_id;
    if (b=true) then
        return new;
    elsif (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update line 11';
    elsif (event_class_conflict(new.start::time,new._end::time,new.start::date,new.section_no,new.instructor_id)) then
        raise exception 'Invalid data insertion or update line 16';
    elsif (event_event_conflict(new.start,new._end,new.section_no,new.instructor_id)) then
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
    ins_id integer;
    start_timestamp timestamp with time zone;
    end_timestamp timestamp with time zone;
begin
    if (new.extra_class_id is null or new.instructor_id is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    select section_no,instructor_id,start,_end into sec_no,ins_id,start_timestamp,end_timestamp from extra_class
    where extra_class_id=new.extra_class_id;
    if (ins_id=new.instructor_id) then
        raise exception 'Invalid data insertion or update';
    elsif (instructor_section_compare(new.instructor_id,sec_no,old.instructor_id,null) or ins_id=new.instructor_id) then
        raise exception 'Invalid data insertion or update';
    elsif (event_event_conflict(start_timestamp,end_timestamp,sec_no,ins_id)) then
        raise exception 'Invalid data insertion or update';
    elsif (event_class_conflict(start_timestamp::time,end_timestamp::time,start_timestamp::date,sec_no,ins_id)) then
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
    if (event_class_conflict(new.start::time,new._end::time,new.start::date,new.section_no,new.instructor_id)) then
        raise exception 'Invalid data insertion or update';
    end if;
    if (event_event_conflict(new.start,new._end,new.section_no,new.instructor_id)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$request_event_validation$ language plpgsql;

create trigger request_event_validation before insert or update on request_event
     for each row execute function request_event_check();


create or replace function notification_event_check() returns trigger as $notification_event_validation$
declare
    cnt integer;
begin
cnt:=0;
    if (new.event_type=0) then
        select count(*) into cnt from request_event where req_id=new.event_no;
    elsif (new.event_type=1) then
        select count(*) into cnt from extra_class where extra_class_id=new.event_no;
    elsif (new.event_type=2) then
        select count(*) into cnt from evaluation where evaluation_id=new.event_no;
    elsif (new.event_type=3) then
        select count(*) into cnt from canceled_class where canceled_class_id=new.event_no;
    elsif (new.event_type=4) then
        select count(*) into cnt from course_post where post_id=new.event_no;
    elsif (new.event_type=5) then
        select count(*) into cnt from instructor_resource where res_id=new.event_no;
    elsif (new.event_type=6) then
        select count(*) into cnt from student_resource where res_id=new.event_no;
    elsif (new.event_type=7) then
        select count(*) into cnt from grading where grading_id=new.event_no;
    elsif (new.event_type=8) then
        select count(*) into cnt from forum_post where post_id=new.event_no;
    elsif (new.event_type=9) then
        select count(*) into cnt from topic where topic_num=new.event_no;
    else
        raise exception 'Invalid data insertion or update';
    end if;
    if (cnt=0) then
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
	refresh materialized view all_courses;
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

create or replace function get_teacher_id(teacher_uname varchar) returns integer as $$
    declare
        ans integer;
    begin
        select teacher_id into ans from teacher join official_users ou on teacher.user_no = ou.user_no
        where username=teacher_uname;
        return ans;
    end
$$ language plpgsql;

create or replace function instructor_to_teacher(ins_id integer) returns integer as $$
    declare
        ans integer;
    begin
        select teacher_id into ans from instructor where instructor_id=ins_id;
        return ans;
    end
$$ language plpgsql;

create or replace function event_class_conflict(start_time time,end_time time,curr_date date,sec_id integer,ins_id integer) returns boolean as $$
    declare
        ans integer;
        tid integer;
    begin
        ans = 0;
        tid = instructor_to_teacher(ins_id);
        select count(*) into ans from course_routine cr join intersected_sections iss on cr.section_no=iss.second_section
where iss.first_section=sec_id and cr.day=extract(isodow from curr_date)-1 and overlapped_time(cr.start,cr._end,start_time,end_time) and not exists (select canceled_class_id from canceled_class cc
    where cc.class_id=cr.class_id and cc._date=curr_date);
        if (ans>0) then
            return true;
        end if;
        select count(*) into ans from course_routine cr join teacher_routine tr on cr.class_id = tr.class_id join instructor i on tr.instructor_id = i.instructor_id
where i.teacher_id=tid and i.instructor_id!=ins_id and cr.day=extract(isodow from curr_date)-1 and overlapped_time(cr.start,cr._end,start_time,end_time) and not exists (select canceled_class_id from canceled_class cc
    where cc.class_id=cr.class_id and cc._date=curr_date);
        if (ans>0) then
            return true;
        end if;
        return false;
    end
$$ language plpgsql;


create or replace function event_event_conflict(start_timestamp timestamp with time zone,end_timestamp timestamp with time zone,sec_id integer,ins_id integer) returns boolean as $$
    declare
        ans integer;
        tid integer;
    begin
        ans = 0;
        tid = instructor_to_teacher(ins_id);
        select count(*) into ans from extra_class ec join intersected_sections iss on ec.section_no=iss.second_section
where iss.first_section=sec_id and overlapped_timestamp(ec.start,ec._end,start_timestamp,end_timestamp);
        if (ans>0) then
            return true;
        end if;
    select count(*) into ans from extra_class ec join teacher_routine tr on ec.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id
where overlapped_timestamp(ec.start,ec._end,start_timestamp,end_timestamp) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from extra_class_teacher ect join extra_class ec on ect.extra_class_id=ec.extra_class_id join teacher_routine tr on ect.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id
where overlapped_timestamp(ec.start,ec._end,start_timestamp,end_timestamp) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from evaluation ec join intersected_sections iss on ec.section_no=iss.second_section
where iss.first_section=sec_id and overlapped_timestamp(ec.start,ec._end,start_timestamp,end_timestamp);
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from evaluation ec join teacher_routine tr on ec.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id join evaluation_type et on (et.type_id = ec.type_id and et.notification_time_type = false)
where overlapped_timestamp(ec.start,ec._end,start_timestamp,end_timestamp) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from extra_evaluation_instructor ect join evaluation ec on ect.evaluation_id=ec.evaluation_id join teacher_routine tr on ect.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id join evaluation_type et on (et.type_id = ec.type_id and et.notification_time_type = false)
where overlapped_timestamp(ec.start,ec._end,start_timestamp,end_timestamp) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
        return false;
    end
$$ language plpgsql;

create or replace function class_class_conflict_teacher(start_time time,end_time time,weekday integer,ins_id integer) returns boolean as $$
    declare
        ans integer;
        tid integer;
    begin
        ans = 0;
        tid = instructor_to_teacher(ins_id);
        select count(*) into ans from course_routine cr join teacher_routine tr on cr.class_id = tr.class_id join instructor i on tr.instructor_id = i.instructor_id
where i.teacher_id=tid and i.instructor_id!=ins_id and cr.day=weekday and overlapped_time(cr.start,cr._end,start_time,end_time);
        if (ans>0) then
            return true;
        end if;
        return false;
    end
$$ language plpgsql;

create or replace function class_event_conflict_teacher(start_time time,end_time time,weekday integer,ins_id integer) returns boolean as $$
    declare
        ans integer;
        tid integer;
    begin
        ans = 0;
        tid = instructor_to_teacher(ins_id);
select count(*) into ans from extra_class ec join teacher_routine tr on ec.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id
where extract(isodow from ec._date)=weekday+1 and overlapped_time(ec.start::time,ec._end::time,start_time,end_time) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from extra_class_teacher ect join extra_class ec on ect.extra_class_id=ec.extra_class_id join teacher_routine tr on ect.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id
where extract(isodow from ec._date)=weekday+1 and overlapped_time(ec.start::time,ec._end::time,start_time,end_time) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from evaluation ec join teacher_routine tr on ec.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id join evaluation_type et on (et.type_id = ec.type_id and et.notification_time_type = false)
where extract(isodow from ec._date)=weekday+1 and overlapped_time(ec.start::time,ec._end::time,start_time,end_time) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from extra_evaluation_instructor ect join evaluation ec on ect.evaluation_id=ec.evaluation_id join teacher_routine tr on ect.instructor_id = tr.instructor_id join instructor i on tr.instructor_id = i.instructor_id join evaluation_type et on (et.type_id = ec.type_id and et.notification_time_type = false)
where extract(isodow from ec._date)=weekday+1 and overlapped_time(ec.start::time,ec._end::time,start_time,end_time) and i.teacher_id=tid and tr.instructor_id!=ins_id;
        if (ans>0) then
            return true;
        end if;
        return false;
    end
$$ language plpgsql;

create or replace function class_class_conflict_student(start_time time,end_time time,weekday integer,sec_id integer) returns boolean as $$
    declare
        ans integer;
    begin
        ans = 0;
        select count(*) into ans from course_routine cr join intersected_sections iss on cr.section_no=iss.second_section
where iss.first_section=sec_id and cr.day=weekday and overlapped_time(cr.start,cr._end,start_time,end_time);
        if (ans>0) then
            return true;
        end if;
        return false;
    end
$$ language plpgsql;

create or replace function class_event_conflict_student(start_time time,end_time time,weekday integer,sec_id integer) returns boolean as $$
    declare
        ans integer;
    begin
        ans = 0;
select count(*) into ans from extra_class ec join intersected_sections iss on ec.section_no=iss.second_section
where iss.first_section=sec_id and extract(isodow from ec._date)=weekday+1 and overlapped_time(ec.start::time,ec._end::time,start_time,end_time);
        if (ans>0) then
            return true;
        end if;
select count(*) into ans from evaluation ec join intersected_sections iss on ec.section_no=iss.second_section join evaluation_type et on (et.type_id = ec.type_id and et.notification_time_type = false)
where iss.first_section=sec_id and extract(isodow from ec._date)=weekday+1 and overlapped_time(ec.start::time,ec._end::time,start_time,end_time);
        if (ans>0) then
            return true;
        end if;
        return false;
    end
$$ language plpgsql;

create or replace function teacher_routine_check() returns trigger as $teacher_routine_validation$
declare
    sec_no integer;
    start_time time;
    end_time time;
    weekday integer;
begin
    if (new.class_id is null or new.instructor_id is null) then
        raise exception 'Invalid data insertion or update from line 9';
    end if;
    select section_no,start,_end,day into sec_no,start_time,end_time,weekday from course_routine
    where class_id=new.class_id;
    if (instructor_section_compare(new.instructor_id,sec_no,old.instructor_id,null)) then
        raise exception 'Invalid data insertion or update from line 12';
    end if;
    if (class_class_conflict_teacher(start_time,end_time,weekday,new.instructor_id)) then
        raise exception 'Invalid data insertion or update';
    end if;
    if (class_event_conflict_teacher(start_time,end_time,weekday,new.instructor_id)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$teacher_routine_validation$ language plpgsql;

create trigger teacher_routine_validation before insert or update on teacher_routine
     for each row execute function teacher_routine_check();

create or replace function course_routine_check() returns trigger as $course_routine_validation$
declare
begin
    if (class_class_conflict_student(new.start,new._end,new.day,new.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    if (class_event_conflict_student(new.start,new._end,new.day,new.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$course_routine_validation$ language plpgsql;

create trigger course_routine_validation before insert or update on course_routine
     for each row execute function course_routine_check();

create or replace function get_current_course_teacher (teacher_username varchar)
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar) as $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from current_courses cc join instructor i on cc._id=i.course_id join teacher t on i.teacher_id = t.teacher_id
    where t.teacher_id=tid;
    end
$$ language plpgsql;

create or replace function get_all_course_teacher (teacher_username varchar)
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar) as $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from all_courses cc join instructor i on cc._id=i.course_id join teacher t on i.teacher_id = t.teacher_id
    where t.teacher_id=tid;
    end
$$ language plpgsql;

create or replace function extra_evaluation_instructor_check() returns trigger as $extra_evaluation_instructor_validation$
declare
    sec_no integer;
    ins_id integer;
    start_timestamp timestamp with time zone;
    end_timestamp timestamp with time zone;
begin
    if (new.evaluation_id is null or new.instructor_id is null) then
        raise exception 'Invalid data insertion or update';
    end if;
    select section_no,instructor_id,start,_end into sec_no,ins_id,start_timestamp,end_timestamp from evaluation join evaluation_type et on et.type_id = evaluation.type_id
    where evaluation_id=new.evaluation_id;
    if (ins_id=new.instructor_id) then
        raise exception 'Invalid data insertion or update';
    elsif (instructor_section_compare(new.instructor_id,sec_no,old.instructor_id,null) or ins_id=new.instructor_id) then
        raise exception 'Invalid data insertion or update';
    elsif (event_event_conflict(start_timestamp,end_timestamp,sec_no,ins_id)) then
        raise exception 'Invalid data insertion or update';
    elsif (event_class_conflict(start_timestamp::time,end_timestamp::time,start_timestamp::date,sec_no,ins_id)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$extra_evaluation_instructor_validation$ language plpgsql;

create trigger extra_evaluation_instructor_validation before insert or update on extra_evaluation_instructor
     for each row execute function extra_evaluation_instructor_check();

create or replace function get_upcoming_events_teacher (teacher_username varchar)
    returns table (id integer,dept_shortname varchar,course_code integer, lookup_time time,event_type varchar) as $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
    select cc._id,cc._dept_shortname,cc._course_code, _lookup_time,_event_type from (
                                                  ((select section_no, start::time as _lookup_time, cast('Class' as varchar) as _event_type, tr.instructor_id as instructor_id
                                                    from course_routine cr join teacher_routine tr on cr.class_id = tr.class_id
                                                    where day = extract(isodow from current_date) - 1 and start::time>current_time
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = current_date
                                                        ))
                                                   union
                                                   (select section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type,instructor_id as instructor_id
                                                    from extra_class
                                                    where start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type,ect.instructor_id as instructor_id
                                                    from extra_class join extra_class_teacher ect on extra_class.extra_class_id = ect.extra_class_id
                                                    where start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, start::time as _lookup_time, et.type_name as _event_type, e.instructor_id as instructor_id
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, start::time as _lookup_time, et.type_name as _event_type,eet.instructor_id
                                                    from evaluation e join extra_evaluation_instructor eet on e.evaluation_id = eet.evaluation_id
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and _end::date = current_date and _end::time>current_time))) ut join
    instructor i on i.instructor_id=ut.instructor_id join current_courses cc on (i.course_id=cc._id)
    where i.teacher_id=tid
    order by _lookup_time;
end
$$ language plpgsql;

create or replace function get_day_events (std_id integer,query_date date)
    returns table (id integer,dept_shortname varchar,course_code integer, lookup_time time,event_type varchar) as $$
begin
    return query
    select cc._id,cc._dept_shortname,cc._course_code, _lookup_time,_event_type from (
                                                  ((select section_no, start::time as _lookup_time, cast('Class' as varchar) as _event_type
                                                    from course_routine cr
                                                    where day = extract(isodow from query_date) - 1
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = query_date
                                                        ))
                                                   union
                                                   (select section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type
                                                    from extra_class
                                                    where start::date = query_date)
                                                   union
                                                   (select section_no, start::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and start::date = query_date)
                                                   union
                                                   (select section_no, _end::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = true)
                                                                      and _end::date = query_date))) ut join
    (
        select section_id from enrolment join student on (enrolment.student_id = student.student_id) where mod(_year,100)*100000+dept_code*1000+roll_num=std_id
    ) ss on (ut.section_no=ss.section_id) join section s on (ss.section_id=s.section_no) join current_courses cc on (s.course_id=cc._id)
    order by _lookup_time;
end
$$ language plpgsql;

create or replace function get_day_events_teacher (teacher_username varchar, query_date date)
    returns table (id integer,dept_shortname varchar,course_code integer, lookup_time time,event_type varchar) as $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
    select cc._id,cc._dept_shortname,cc._course_code, _lookup_time,_event_type from (
                                                  ((select section_no, start::time as _lookup_time, cast('Class' as varchar) as _event_type, tr.instructor_id as instructor_id
                                                    from course_routine cr join teacher_routine tr on cr.class_id = tr.class_id
                                                    where day = extract(isodow from query_date) - 1
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = query_date
                                                        ))
                                                   union
                                                   (select section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type,instructor_id as instructor_id
                                                    from extra_class
                                                    where start::date = query_date)
                                                   union
                                                   (select section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type,ect.instructor_id as instructor_id
                                                    from extra_class join extra_class_teacher ect on extra_class.extra_class_id = ect.extra_class_id
                                                    where start::date = query_date)
                                                   union
                                                   (select section_no, start::time as _lookup_time, et.type_name as _event_type, e.instructor_id as instructor_id
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and start::date = query_date)
                                                   union
                                                   (select section_no, start::time as _lookup_time, et.type_name as _event_type,eet.instructor_id
                                                    from evaluation e join extra_evaluation_instructor eet on e.evaluation_id = eet.evaluation_id
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and _end::date = query_date))) ut join
    instructor i on i.instructor_id=ut.instructor_id join current_courses cc on (i.course_id=cc._id)
    where i.teacher_id=tid
    order by _lookup_time;
end
$$ language plpgsql;

create or replace function notify_cancel_class() returns trigger as $cancel_class_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.canceled_class_id,3,new._date);
    return null;
end;
$cancel_class_notification$ language plpgsql;

create trigger cancel_class_notification after insert on canceled_class
     for each row execute function notify_cancel_class();

create or replace function notify_cancel_class_update() returns trigger as $cancel_class_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new._date
    where event_no=new.canceled_class_id and event_type=3;
    return null;
end;
$cancel_class_notification_update$ language plpgsql;

create trigger cancel_class_notification_update after update on canceled_class
     for each row execute function notify_cancel_class_update();

create or replace function notify_extra_class() returns trigger as $extra_class_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.extra_class_id,1,new.start::date);
    return null;
end;
$extra_class_notification$ language plpgsql;

create trigger extra_class_notification after insert on extra_class
     for each row execute function notify_extra_class();

create or replace function notify_extra_class_update() returns trigger as $extra_class_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.start::date
    where event_no=new.extra_class_id and event_type=1;
    return null;
end;
$extra_class_notification_update$ language plpgsql;

create trigger extra_class_notification_update after update on extra_class
     for each row execute function notify_extra_class_update();

create or replace function notify_evaluation() returns trigger as $evaluation_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.evaluation_id,2,new.start::date);
    return null;
end;
$evaluation_notification$ language plpgsql;

create trigger evaluation_notification after insert on evaluation
     for each row execute function notify_evaluation();

create or replace function notify_evaluation_update() returns trigger as $evaluation_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.start::date
    where event_no=new.evaluation_id and event_type=2;
    return null;
end;
$evaluation_notification_update$ language plpgsql;

create trigger evaluation_notification_update after update on evaluation
     for each row execute function notify_evaluation_update();

create or replace function get_course_evaluations (std_id integer,crs_id integer)
    returns table (id integer, event_type varchar,event_date date,event_description varchar,published boolean,completed boolean) as $$
    declare
    begin
    return query
    select ev.evaluation_id as _id,et.type_name,ev.start::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp) from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id join current_courses cc on cc._id=s.course_id
where cc._id=crs_id and et.notification_time_type=false and mod(_year,100)*100000+dept_code*1000+roll_num=std_id
union
select ev.evaluation_id as _id,et.type_name,ev._end::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp) from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id join current_courses cc on cc._id=s.course_id
where cc._id=crs_id and et.notification_time_type=true and mod(_year,100)*100000+dept_code*1000+roll_num=std_id
order by _date;
end
$$ language plpgsql;

create or replace function notify_topic_added() returns trigger as $topic_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.topic_num,9,new.started::date);
    return null;
end;
$topic_notification$ language plpgsql;

create trigger topic_notification after insert on topic
     for each row execute function notify_topic_added();


create or replace function notify_topic_updated() returns trigger as $topic_update_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.started::date
    where event_no=new.topic_num and event_type=9;
    return null;
end;
$topic_update_notification_update$ language plpgsql;

create trigger topic_update_notification_update after update on topic
     for each row execute function notify_topic_updated();

create or replace function notify_course_post_added() returns trigger as $course_post_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.post_id,4,new.post_time::date);
    return null;
end;
$course_post_notification$ language plpgsql;

create trigger course_post_notification after insert on course_post
     for each row execute function notify_course_post_added();

create or replace function notify_course_post_updated() returns trigger as $course_post_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.post_time::date
    where event_no=new.post_id and event_type=4;
    return null;
end;
$course_post_notification_update$ language plpgsql;

create trigger course_post_notification_update after update on course_post
     for each row execute function notify_course_post_updated();

create or replace function notify_instructor_resource_added() returns trigger as $instructor_resource_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.res_id,5,current_timestamp::date);
    return null;
end;
$instructor_resource_notification$ language plpgsql;

create trigger instructor_resource_notification after insert on instructor_resource
     for each row execute function notify_instructor_resource_added();

create or replace function notify_instructor_resource_updated() returns trigger as $instructor_resource_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=current_timestamp::date
    where event_no=new.res_id and event_type=5;
    return null;
end;
$instructor_resource_notification_update$ language plpgsql;

create trigger instructor_resource_notification_update after update on instructor_resource
     for each row execute function notify_instructor_resource_updated();

create or replace function notify_student_resource_added() returns trigger as $student_resource_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.res_id,6,current_timestamp::date);
    return null;
end;
$student_resource_notification$ language plpgsql;

create trigger student_resource_notification after insert on student_resource
     for each row execute function notify_student_resource_added();

create or replace function notify_student_resource_updated() returns trigger as $student_resource_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=current_timestamp::date
    where event_no=new.res_id and event_type=6;
    return null;
end;
$student_resource_notification_update$ language plpgsql;

create trigger student_resource_notification_update after update on student_resource
     for each row execute function notify_student_resource_updated();

create or replace function notify_forum_post_added() returns trigger as $forum_post_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.post_id,8,new.post_time::date);
    return null;
end;
$forum_post_notification$ language plpgsql;

create trigger forum_post_notification after insert on forum_post
     for each row execute function notify_forum_post_added();

create or replace function notify_forum_post_updated() returns trigger as $forum_post_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.post_time::date
    where event_no=new.post_id and event_type=8;
    return null;
end;
$forum_post_notification_update$ language plpgsql;

create trigger forum_post_notification_update after update on forum_post
     for each row execute function notify_forum_post_updated();

create or replace function notify_grading() returns trigger as $grading_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.grading_id,7,new._date);
    return null;
end;
$grading_notification$ language plpgsql;

create trigger grading_notification after insert on grading
     for each row execute function notify_grading();

create or replace function notify_grading_update() returns trigger as $grading_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new._date
    where event_no=new.grading_id and event_type=7;
    return null;
end;
$grading_notification_update$ language plpgsql;

create trigger grading_notification_update after update on grading
     for each row execute function notify_grading_update();

create or replace function notify_request_event() returns trigger as $request_event_notification$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.req_id,0,new.start::date);
    return null;
end;
$request_event_notification$ language plpgsql;

create trigger request_event_notification after insert on request_event
     for each row execute function notify_request_event();

create or replace function notify_request_event_update() returns trigger as $request_event_notification_update$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.start::date
    where event_no=new.req_id and event_type=0;
    return null;
end;
$request_event_notification_update$ language plpgsql;

create trigger request_event_notification_update after update on request_event
     for each row execute function notify_request_event_update();

create or replace function get_forum_posts_teacher (uname varchar)
    returns table (id integer,teacher boolean,name varchar,postID integer,postName varchar,postContent varchar,postTime timestamp with time zone) as $$
begin
    return query
    select t.teacher_id,cast(true as boolean) as isTeacher,t.teacher_name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where ou.username!=uname and fp.parent_post is null
union
select a.admin_id,cast(false as boolean) as isTeacher,a.name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where  fp.parent_post is null;
end
$$ language plpgsql;

create or replace function get_course_posts_teacher (uname varchar)
    returns table (teacherID integer,courseID integer,courseDept varchar,courseNum integer,courseTerm varchar,courseYear integer,name varchar,postID integer,postName varchar,postContent varchar,postTime timestamp with time zone) as $$
begin
    return query
    select t.teacher_id,c._id,c._dept_shortname,c._course_code,c._term,c.__year,t.teacher_name,cp.post_id,cp.post_name,cp.post_content,cp.post_time from course_post cp join instructor i on i.instructor_id=cp.poster_id join teacher t on i.teacher_id = t.teacher_id join official_users ou on t.user_no = ou.user_no join current_courses c on i.course_id = c._id
where ou.username!=uname and cp.parent_post is null;
end
$$ language plpgsql;

create or replace function get_my_marks (userID integer,eID integer)
    returns table (eventID integer,event_type varchar,event_desc varchar,term varchar,year integer,deptCode varchar,courseNum integer,event_date date,totalMarks float,obtainedMarks float) as $$
begin
    return query
    (select e.evaluation_id, et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e.start::date,e.total_marks,e.total_marks*(sum(g.obtained_marks)/sum(g.total_marks)) from evaluation e join evaluation_type et on et.type_id = e.type_id join submission s on e.evaluation_id = s.event_id join grading g on s.sub_id = g.sub_id join enrolment e2 on s.enrol_id = e2.enrol_id join student s2 on e2.student_id = s2.student_id join section s3 on e.section_no = s3.section_no join current_courses c on c._id=s3.course_id
where (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=userID and e.evaluation_id=eID and et.notification_time_type=false
group by e.evaluation_id, et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e.start::date,e.total_marks)
    union
    (select e.evaluation_id, et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e._end::date,e.total_marks,e.total_marks*(sum(g.obtained_marks)/sum(g.total_marks)) from evaluation e join evaluation_type et on et.type_id = e.type_id join submission s on e.evaluation_id = s.event_id join grading g on s.sub_id = g.sub_id join enrolment e2 on s.enrol_id = e2.enrol_id join student s2 on e2.student_id = s2.student_id join section s3 on e.section_no = s3.section_no join current_courses c on c._id=s3.course_id
where (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=userID and e.evaluation_id=eID and et.notification_time_type=true
group by e.evaluation_id, et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e.start::date,e.total_marks)
    ;
end
$$ language plpgsql;

create or replace function get_course_marks (uname varchar,eID integer)
    returns table (eventID integer,userID integer,studentName varchar,event_type varchar,event_desc varchar,term varchar,year integer,deptCode varchar,courseNum integer,event_date date,totalMarks float,obtainedMarks float) as $$
begin
    return query
    select e.evaluation_id, (mod(s2._year,100)*100000+s2.dept_code*1000+roll_num) as uid,s2.student_name,et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e.start::date,e.total_marks,e.total_marks*(sum(g.obtained_marks)/sum(g.total_marks)) from evaluation e join evaluation_type et on et.type_id = e.type_id join submission s on e.evaluation_id = s.event_id join grading g on s.sub_id = g.sub_id join enrolment e2 on s.enrol_id = e2.enrol_id join student s2 on e2.student_id = s2.student_id join section s3 on e.section_no = s3.section_no join current_courses c on c._id=s3.course_id join instructor i on c._id = i.course_id join teacher t on i.teacher_id = t.teacher_id join official_users ou on t.user_no = ou.user_no
where et.notification_time_type=false and ou.username=uname and e.evaluation_id=eID
group by e.evaluation_id,  (mod(s2._year,100)*100000+s2.dept_code*1000+roll_num),s2.student_name,et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e.start::date,e.total_marks
union
    select e.evaluation_id, (mod(s2._year,100)*100000+s2.dept_code*1000+roll_num) as uid,s2.student_name,et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e._end::date,e.total_marks,e.total_marks*(sum(g.obtained_marks)/sum(g.total_marks)) from evaluation e join evaluation_type et on et.type_id = e.type_id join submission s on e.evaluation_id = s.event_id join grading g on s.sub_id = g.sub_id join enrolment e2 on s.enrol_id = e2.enrol_id join student s2 on e2.student_id = s2.student_id join section s3 on e.section_no = s3.section_no join current_courses c on c._id=s3.course_id join instructor i on c._id = i.course_id join teacher t on i.teacher_id = t.teacher_id join official_users ou on t.user_no = ou.user_no
where et.notification_time_type=true and ou.username=uname and e.evaluation_id=eID
group by e.evaluation_id,  (mod(s2._year,100)*100000+s2.dept_code*1000+roll_num),s2.student_name,et.type_name, e.description,c._term,c.__year,c._dept_shortname,c._course_code,e.start::date,e.total_marks;
end
$$ language plpgsql;

create or replace function get_forum_posts ()
    returns table (id integer,teacher boolean,name varchar,postID integer,postName varchar,postContent varchar,postTime timestamp with time zone) as $$
begin
    return query
    select t.teacher_id,cast(true as boolean) as isTeacher,t.teacher_name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where fp.parent_post is null
union
select a.admin_id,cast(false as boolean) as isTeacher,a.name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where  fp.parent_post is null;
end
$$ language plpgsql;

create or replace function get_course_posts(userID integer)
    returns table (teacherID integer,courseID integer,courseDept varchar,courseNum integer,courseTerm varchar,courseYear integer,name varchar,postID integer,postName varchar,postContent varchar,postTime timestamp with time zone) as $$
begin
    return query
    select t.teacher_id,c._id,c._dept_shortname,c._course_code,c._term,c.__year,t.teacher_name,cp.post_id,cp.post_name,cp.post_content,cp.post_time from course_post cp join instructor i on i.instructor_id=cp.poster_id join teacher t on i.teacher_id = t.teacher_id join official_users ou on t.user_no = ou.user_no join current_courses c on i.course_id = c._id join section s on i.course_id = s.course_id join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id
where cp.parent_post is null and (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=userID;
end
$$ language plpgsql;

create or replace function add_course_topic(tname varchar,courseID integer,username varchar,topicDescription varchar,ended boolean) returns void as $$
declare
    tid integer;
    ins_id integer;
begin
    tid = get_teacher_id(username);
    select instructor_id into ins_id from instructor where teacher_id=tid and course_id=courseID;
    insert into topic(topic_num, topic_name, instructor_id, finished, description)
    values (default,tname,ins_id,ended,topicDescription);
end;
$$ language plpgsql;

create or replace function get_course_evaluations_teacher (uname varchar,crs_id integer)
    returns table (id integer, event_type varchar,event_date date,event_description varchar,published boolean,completed boolean,sec_no integer,sec_name varchar) as $$
    declare
        tid integer;
    begin
        tid=get_teacher_id(uname);
    return query
    select ev.evaluation_id as _id,et.type_name,ev.start::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp),s.section_no,s.section_name from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on ev.instructor_id = i.instructor_id
where cc._id=crs_id and i.teacher_id=tid
union
select ev.evaluation_id as _id,et.type_name,ev._end::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp),s.section_no,s.section_name from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on ev.instructor_id = i.instructor_id
where cc._id=crs_id and i.teacher_id=tid
order by _date;
end
$$ language plpgsql;

create or replace function get_evaluation_notifications_teacher (teacher_username varchar)
    returns table (eventType integer,eventNo integer,courseID integer,teacherID integer,dept_shortname varchar,course_code integer,eventTypeName varchar,teacherNamr varchar, notificationTime timestamp with time zone,scheduledDate date) as $$
    declare
    begin
    return query
    select ne.event_type,ne.event_no,cc._id,t.teacher_id,cc._dept_shortname,cc._course_code,et.type_name,t.teacher_name,ne.notifucation_time, ne._date from notification_event ne join evaluation ec on ne.event_no=ec.evaluation_id join evaluation_type et on ec.type_id = et.type_id
   join extra_evaluation_instructor eei on ec.evaluation_id = eei.evaluation_id join section s on ec.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on eei.instructor_id = i.instructor_id join instructor j on j.instructor_id=ec.instructor_id join teacher t on j.teacher_id = t.teacher_id join teacher t2 on t2.teacher_id=i.teacher_id join official_users ou on t2.user_no = ou.user_no
where ne.event_type=2 and ou.username=teacher_username and t2.notification_last_seen<ne.notifucation_time
order by ne.notifucation_time desc;
end
$$ language plpgsql;

create or replace function get_evaluation_notifications (std_id integer)
    returns table (eventType integer,eventNo integer,courseID integer,teacherID integer,dept_shortname varchar,course_code integer,eventTypeName varchar,teacherNamr varchar, notificationTime timestamp with time zone,scheduledDate date) as $$
    declare
    begin
    return query
    select ne.event_type,ne.event_no,cc._id,t.teacher_id,cc._dept_shortname,cc._course_code,et.type_name,t.teacher_name,ne.notifucation_time, ne._date from notification_event ne join evaluation ec on ne.event_no=ec.evaluation_id join evaluation_type et on ec.type_id = et.type_id
    join section s on ec.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on ec.instructor_id = i.instructor_id join teacher t on i.teacher_id = t.teacher_id join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id
where ne.event_type=2 and  (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=std_id and s2.notification_last_seen<ne.notifucation_time
order by ne.notifucation_time desc;
end
$$ language plpgsql;

create or replace function get_current_course_admin ()
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar) as $$
    begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from current_courses cc
    ;
    end
$$ language plpgsql;

create or replace function get_all_course_admin ()
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar) as $$
    begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from all_courses cc
    ;
    end
$$ language plpgsql;

create or replace function get_student_no(std_id integer) returns integer as $$
    declare
        ans integer;
    begin
        select student_id into ans from student where (mod(_year,100)*100000+dept_code*1000+roll_num)=std_id;
        return ans;
    end
$$ language plpgsql;

create or replace function get_course_students (courseID integer)
    returns table (std_id integer,std_name varchar,enrolID integer,sec_no integer,sec_name varchar) as $$
    begin
    return query
    select (mod(s._year,100)*100000+s.dept_code*1000+s.roll_num) as sid, s.student_name,e.enrol_id,s2.section_no,s2.section_name from student s join enrolment e on s.student_id = e.student_id join section s2 on e.section_id = s2.section_no join course c on s2.course_id = c.course_id
where c.course_id=courseID;
    end
$$ language plpgsql;

create or replace function get_course_teachers (courseID integer)
    returns table (uname varchar,teacherName varchar) as $$
    begin
    return query
    select ou.username, t.teacher_name from teacher t join official_users ou on t.user_no = ou.user_no join instructor i on t.teacher_id = i.teacher_id join course c on i.course_id = c.course_id
where c.course_id=courseID;
    end
$$ language plpgsql;

create or replace function add_course_teacher(uname varchar,courseID integer) returns void as $$
    declare
    tid integer;
    begin
        tid:=get_teacher_id(uname);
        insert into instructor(instructor_id, teacher_id, course_id)
        values (default,tid,courseID);
    end;
$$ language plpgsql;

create or replace function remove_course_teacher(uname varchar,courseID integer) returns void as $$
    declare
    tid integer;
    begin
        tid:=get_teacher_id(uname);
        delete from instructor
        where teacher_id=tid and course_id=courseID;
    end;
$$ language plpgsql;

create or replace function add_course_student(std_id integer,sectionNo integer) returns void as $$
    declare
    std_no integer;
    begin
        std_no:=get_student_no(std_id);
        insert into enrolment(enrol_id, student_id, section_id)
        values (default,std_no,sectionNo);
    end;
$$ language plpgsql;

create or replace function remove_course_student(std_id integer,courseNo integer) returns void as $$
    declare
    std_no integer;
    sectionNo integer;
    begin
        std_no:=get_student_no(std_id);
        select s.section_no into sectionNo from enrolment e join section s on s.section_no = e.section_id
        where e.student_id=std_no and s.course_id=courseNo;
        update section set cr_id = null where cr_id=std_no and section_no=sectionNo;
        delete from enrolment
        where student_id=std_no and section_id=sectionNo;
    end;
$$ language plpgsql;

create or replace function update_cr(std_id integer,sectionNo integer) returns void as $$
    declare
    std_no integer;
    begin
        std_no:=get_student_no(std_id);
        update section
        set cr_id=std_no
        where section_no=sectionNo;
    end;
$$ language plpgsql;

create or replace function get_all_teacher_admin ()
    returns table (teacher_username varchar,name varchar,dept varchar,email varchar) as $$
    begin
    return query
    select ou.username,t.teacher_name, d.dept_shortname,ou.email_address from teacher t join department d on t.dept_code = d.dept_code join official_users ou on t.user_no = ou.user_no;
    end
$$ language plpgsql;

create or replace function get_all_student_admin ()
    returns table (std_id integer,name varchar,dept varchar,email varchar) as $$
    begin
    return query
    select (mod(_year,100)*100000+d.dept_code*1000+roll_num) as id,student_name,email_address,d.dept_shortname from student join department d on student.dept_code = d.dept_code;
    end
$$ language plpgsql;

create or replace function mark_topic_done(top_num integer) returns void as $$
    declare
    begin
        update topic
        set finished=true
        where topic_num=top_num;
    end;
$$ language plpgsql;

create or replace function get_submissions (event integer)
    returns table (subID integer,studentID integer,studentName varchar,subLink varchar,subTime timestamp with time zone) as $$
    begin
    return query
        select sub_id,(mod(_year,100)*100000+dept_code*1000+roll_num) as id,student_name,sub.link,sub_time from submission sub join enrolment e on e.enrol_id = sub.enrol_id join student s on e.student_id = s.student_id join evaluation e2 on sub.event_id = e2.evaluation_id
where event_id=event;
    end
$$ language plpgsql;

create or replace function get_event_description (event integer)
    returns table (eventID integer,eventType varchar,description varchar,subTime timestamp with time zone) as $$
    begin
    return query
    select e.evaluation_id,et.type_name,e.description,e._end from evaluation e join evaluation_type et on et.type_id = e.type_id
    where e.evaluation_id=event;
    end
$$ language plpgsql;

create or replace function get_submission_info (eventID integer,stdID integer)
    returns table (subID integer,subTime timestamp with time zone,subLink varchar) as $$
    declare
        stdNo integer;
        secNo integer;
        enrolID integer;
    begin
        select section_no into secNo from evaluation where evaluation_id=eventID;
        stdNo:=get_student_no(stdID);
        select enrol_id into enrolID from enrolment
        where student_id=stdNo and section_id=secNo;
    return query
        select sub_id,sub_time,link from submission
        where enrol_id=enrolID and event_id=eventID;
    end
$$ language plpgsql;

create or replace function get_submitted_file_link (subID integer)
    returns varchar as $$
    declare
        ans varchar;
    begin
        select link into ans from submission where sub_id=subID;
        return ans;
    end
$$ language plpgsql;

create or replace function grade_submission(subID integer,teacher_username varchar,courseID integer,totalMarks float,obtainedMarks float,remark varchar) returns void as $$
    declare
        tid integer;
        insID integer;
    begin
        tid:=get_teacher_id(teacher_username);
        select instructor_id into insID from instructor where course_id=courseID and teacher_id=tid;
        insert into grading(grading_id, sub_id, instructor_id, total_marks, obtained_marks, remarks)
        values (default,subID,insID,totalMarks,obtainedMarks,remark);
    end;
$$ language plpgsql;

create or replace function make_submission(eventID integer,stdID integer,subLink varchar) returns void as $$
    declare
        stdNo integer;
        secNo integer;
        enrolID integer;
    begin
        stdNo:=get_student_no(stdID);
        select section_no into secNo from evaluation where evaluation_id=eventID;
        select enrol_id into enrolID from enrolment
        where student_id=stdNo and section_id=secNo;
        insert into submission(sub_id, event_id, enrol_id, link)
        values (default,eventID,enrolID,subLink);
    end;
$$ language plpgsql;

create or replace function get_root_course_posts (courseID integer)
    returns table (postID integer,posterID integer,teacherID integer,title varchar,posterName varchar,postTime timestamp with time zone) as $$
    begin
    return query
        select post_id,poster_id,t.teacher_id,post_name,t.teacher_name, post_time from course_post cp join instructor i on i.instructor_id=cp.poster_id join teacher t on i.teacher_id = t.teacher_id join course c on i.course_id = c.course_id
        where c.course_id=courseID and cp.parent_post is null;
    end
$$ language plpgsql;

create or replace function get_root_forum_posts ()
    returns table (postID integer,posterID integer,title varchar,teacherOrAdminID integer,posterName varchar,postTime timestamp with time zone,isAdmin boolean) as $$
    begin
    return query
        (select fp.post_id,fp.poster,fp.post_name,t.teacher_id,t.teacher_name,fp.post_time,cast(false as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where fp.parent_post is null)
union
(select fp.post_id,fp.poster,fp.post_name,a.admin_id,a.name,fp.post_time,cast(true as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where fp.parent_post is null);
    end
$$ language plpgsql;

create or replace function get_current_forum_post(pID integer)
    returns table (postID integer,posterID integer,title varchar,description varchar,uname varchar,posterName varchar,postTime timestamp with time zone,isAdmin boolean) as $$
    begin
    return query
        (select fp.post_id,fp.poster,fp.post_name,fp.post_content,ou.username,t.teacher_name,fp.post_time,cast(false as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where post_id=pID)
union
(select fp.post_id,fp.poster,fp.post_name,fp.post_content,ou.username,a.name,fp.post_time,cast(true as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where post_id=pID);
    end
$$ language plpgsql;

create or replace function get_current_course_post(pID integer)
    returns table (postID integer,posterID integer,title varchar,description varchar,teacherOrStudentID varchar,posterName varchar,postTime timestamp with time zone,isAdmin boolean) as $$
    begin
    return query
        (select cp.post_id,cp.poster_id,cp.post_name,cp.post_content,ou.username,t.teacher_name,cp.post_time,student_post
from course_post cp join instructor i on cp.poster_id=i.instructor_id join teacher t on i.teacher_id = t.teacher_id join official_users ou on t.user_no = ou.user_no
where cp.post_id=pID and student_post=false)
union
(select cp.post_id,cp.poster_id,cp.post_name,cp.post_content,cast((mod(_year,100)*100000+dept_code*1000+roll_num) as varchar),s.student_name,cp.post_time,student_post
from course_post cp join enrolment e on cp.poster_id=e.enrol_id join student s on e.enrol_id = s.student_id
where cp.post_id=pID and student_post=true);
    end
$$ language plpgsql;

create or replace function get_course_post_file(pID integer)
    returns table (fileID integer,fileName varchar,fileLink varchar) as $$
    begin
    return query
        select file_id,file_name,file_link from course_post_file where post_id=pID;
    end
$$ language plpgsql;

create or replace function get_forum_post_file(pID integer)
    returns table (fileID integer,fileName varchar,fileLink varchar) as $$
    begin
    return query
        select file_id,file_name,file_link from forum_post_files where post_id=pID;
    end
$$ language plpgsql;

create or replace function get_forum_children_post(parent integer)
    returns table (postID integer) as $$
    begin
    return query
        select post_id from forum_post where parent_post=parent;
    end
$$ language plpgsql;

create or replace function get_course_children_post(parent integer)
    returns table (postID integer) as $$
    begin
    return query
        select post_id from course_post where parent_post=parent;
    end
$$ language plpgsql;

create or replace function add_course_post(courseID integer,userID varchar,isStudent boolean,title varchar,content varchar,parentPost integer) returns integer as $$
    declare
        posterID integer;
        entityPK integer;
        ans integer;
    begin
        if (isStudent) then
            entityPK:=get_student_no(cast(userID as integer));
            select enrol_id into posterID from enrolment e join section s on e.section_id = s.section_no
            where e.student_id=entityPK and s.course_id=courseID;
        else
            entityPK:=get_teacher_id(userID);
            select instructor_id into posterID from instructor
            where teacher_id=entityPK and course_id=courseID;
        end if;
        insert into course_post(post_id, parent_post, poster_id, student_post, post_name, post_content)
        values(default,parentPost,posterID,isStudent,title,content) returning post_id into ans;
        return ans;
    end;
$$ language plpgsql;

create or replace function add_forum_post(uname varchar,title varchar,content varchar,parentPost integer) returns integer as $$
    declare
        posterID integer;
        ans integer;
    begin
        select ou.user_no into posterID from official_users ou
        where ou.username=uname;
        insert into forum_post(post_id, parent_post, poster, post_name, post_content)
        values(default,parentPost,posterID,title,content) returning post_id into ans;
        return ans;
    end;
$$ language plpgsql;

create or replace function add_forum_post_file(postID integer,fileName varchar,fileLink varchar) returns void as $$
    begin
        insert into forum_post_files(file_id, post_id, file_name, file_link)
        values(default,postID,fileName,fileLink);
    end;
$$ language plpgsql;

create or replace function add_course_post_file(postID integer,fileName varchar,fileLink varchar) returns void as $$
    begin
        insert into course_post_file(file_id, post_id, file_name, file_link)
        values(default,postID,fileName,fileLink);
    end;
$$ language plpgsql;

create or replace function get_course_cr (courseID integer)
    returns table (sectionID integer,sectionName varchar,CRID integer,CRName varchar) as $$
    begin
    return query
    select sec.section_no,sec.section_name,(mod(s._year,100)*100000+s.dept_code*1000+s.roll_num) as sid,s.student_name from section sec left outer join student s on sec.cr_id = s.student_id where sec.course_id=courseID;
    end
$$ language plpgsql;

-- drop function get_course_cr(courseID integer);
-- drop function add_course_post_file(postID integer, fileName varchar, fileLink varchar);
-- drop function add_forum_post_file(postID integer, fileName varchar, fileLink varchar);
-- drop function add_forum_post(uname varchar, title varchar, content varchar, parentPost integer);
--drop function add_course_post(courseID integer, userID varchar, isStudent boolean, title varchar, content varchar, parentPost integer);
--drop function get_course_children_post(parent integer);
--drop function get_forum_children_post(parent integer);
--drop function get_forum_post_file(pID integer);
--drop function get_course_post_file(pID integer);
--drop function get_current_course_post(pID integer);
--drop function get_current_forum_post(pID integer);
-- drop function get_root_forum_posts();
--drop function get_root_course_posts(courseID integer);
--drop function make_submission(eventID integer, stdID integer, subLink varchar);
-- drop function grade_submission(eventID integer, teacher_username varchar, courseID integer, totalMarks float, obtainedMarks float, remark varchar);
--drop function get_submitted_file_link (subID integer);
--drop function get_submission_info(eventID integer, stdID integer);
--drop function get_event_description(event integer);
-- drop function get_submissions(event integer);
-- drop function mark_topic_done(top_num integer);
-- drop function get_all_student_admin();
-- drop function get_all_teacher_admin();
-- drop function update_cr(std_id integer,sectionNo integer);
-- drop function remove_course_student(std_id integer,courseNo integer);
-- drop function add_course_student(std_id integer,sectionNo integer);
-- drop function remove_course_teacher(uname varchar,courseID integer);
--drop function add_course_teacher(uname varchar,courseID integer);
--drop function get_course_teachers(courseID integer);
-- drop function get_course_students(courseID integer);
-- drop function get_student_no(std_id integer);
-- drop function get_all_course_admin();
-- drop function get_current_course_admin();
-- drop function get_evaluation_notifications(std_id integer);
--drop function get_evaluation_notifications_teacher(teacher_username varchar);
-- drop function get_course_evaluations_teacher(uname varchar, crs_id integer);
--drop function add_course_topic(tname varchar, courseID integer, username varchar, topicDescription varchar, ended boolean);
-- drop function get_course_posts(userID integer);
-- drop function get_forum_posts();
-- drop function get_course_marks(uname varchar, eID integer);
--drop function get_my_marks(userID integer, eID integer);
-- drop function get_course_posts_teacher(uname varchar);
--drop function get_forum_posts_teacher(uname varchar);
-- drop trigger request_event_notification_update on request_event;
-- drop function notify_request_event_update();
-- drop trigger request_event_notification on request_event;
-- drop function notify_request_event();
-- drop trigger grading_notification_update on grading;
-- drop function notify_grading_update();
-- drop trigger grading_notification on grading;
-- drop function notify_grading();
-- drop trigger forum_post_notification_update on forum_post;
-- drop function notify_forum_post_updated();
-- drop trigger forum_post_notification on forum_post;
-- drop function notify_forum_post_added();
-- drop trigger student_resource_notification_update on student_resource;
-- drop function notify_student_resource_updated();
-- drop trigger student_resource_notification on student_resource;
-- drop function notify_student_resource_added();
-- drop trigger instructor_resource_notification_update on instructor_resource;
-- drop function notify_instructor_resource_updated();
-- drop trigger instructor_resource_notification on instructor_resource;
-- drop function notify_instructor_resource_added();
-- drop trigger course_post_notification_update on course_post;
-- drop function notify_course_post_updated();
-- drop trigger course_post_notification on course_post;
-- drop function notify_course_post_added();
-- drop trigger topic_update_notification_update on topic;
-- drop function notify_topic_updated();
-- drop trigger topic_notification on topic;
-- drop function notify_topic_added();
-- drop function get_course_evaluations(std_id integer, crs_id integer);
-- drop trigger evaluation_notification_update on evaluation;
-- drop function notify_evaluation_update();
-- drop trigger evaluation_notification on evaluation;
-- drop function notify_evaluation();
-- drop trigger extra_class_notification_update on extra_class;
-- drop function notify_extra_class_update();
-- drop trigger extra_class_notification on extra_class;
-- drop function notify_extra_class();
-- drop trigger cancel_class_notification_update on canceled_class;
-- drop function notify_cancel_class_update();
-- drop trigger cancel_class_notification on canceled_class;
-- drop function notify_cancel_class();
-- drop function get_day_events_teacher(teacher_username varchar, query_date date);
-- drop function get_day_events(std_id integer, query_date date);
-- drop function get_upcoming_events_teacher(teacher_username varchar);
-- drop trigger extra_evaluation_instructor_validation on extra_evaluation_instructor;
-- drop function extra_evaluation_instructor_check();
-- drop function get_all_course_teacher(teacher_username varchar);
-- drop function get_current_course_teacher(teacher_username varchar);
-- drop trigger course_routine_validation on course_routine;
-- drop function course_routine_check();
-- drop trigger teacher_routine_validation on teacher_routine;
-- drop function teacher_routine_check();
-- drop function class_event_conflict_student(start_time time, end_time time, weekday integer, sec_id integer);
-- drop function class_class_conflict_student(start_time time, end_time time, weekday integer, sec_id integer);
-- drop function class_event_conflict_teacher(start_time time, end_time time, weekday integer, ins_id integer);
-- drop function class_class_conflict_teacher(start_time time, end_time time, weekday integer, ins_id integer);
-- drop function event_event_conflict(start_timestamp timestamp with time zone, end_timestamp timestamp with time zone, sec_id integer, ins_id integer);
-- drop function event_class_conflict(start_time time,end_time time,curr_date date,sec_id integer,ins_id integer);
-- drop function instructor_to_teacher(ins_id integer);
-- drop function get_teacher_id(teacher_uname varchar);
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
-- drop trigger cr_assignment on section;
-- drop function cr_assignment_check();
-- drop function instructor_section_compare(new_ins_id integer, new_sec_no integer, old_ins_id integer, old_sec_no integer);
-- drop trigger instructor_assignment on instructor;
-- drop function instructor_check();
-- drop function get_course_topics(courseID integer);
-- drop function get_upcoming_events(std_id integer);
-- drop function get_all_course(std_id integer);
-- drop function get_current_course(std_id integer);
-- drop function section_to_course(sec_no integer);
-- drop function overlapped_time(first_begin time,first_end time,second_begin time,second_end time);
-- drop function overlapped_timestamp(first_begin timestamp with time zone, first_end timestamp with time zone, second_begin timestamp with time zone, second_end timestamp with time zone);
-- drop function add_course(cname varchar, cnum integer, dept integer, offered_dept integer, offered_batch integer, offered_year integer, offered_level integer, offered_term integer);
-- drop function add_admin(admin_name character varying, uname character varying, hashed_password character varying, email character varying);
-- drop function add_teacher(name varchar, uname varchar, hashed_password varchar, dept integer, email varchar);
-- drop function add_student(name varchar,hashed_password varchar,roll integer,dept integer,batch integer, email varchar);
-- drop function get_account_type(uname varchar);
-- drop function get_dept_list();
-- drop materialized view intersected_sections;
-- drop materialized view all_courses;
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
-- drop table evaluation;
-- drop table evaluation_type;
-- drop table extra_class_teacher;
-- drop table extra_class;
-- drop table canceled_class;
-- drop table teacher_routine;
-- drop table student_file;
-- drop table teacher_file;
-- drop table private_file;
-- drop table student_resource;
-- drop table instructor_resource;
-- drop table resource;
-- drop table topic;
-- drop table course_post_file;
-- drop table course_post;
-- drop table course_routine;
-- drop table enrolment;
-- drop table section;
-- drop table instructor;
-- drop table course;
-- drop table teacher;
-- drop table official_users;
-- drop table student;
-- drop table department;
--drop database moodle_v2;
