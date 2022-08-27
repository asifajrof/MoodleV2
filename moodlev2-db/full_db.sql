DROP SCHEMA public CASCADE; 
CREATE SCHEMA public; 
GRANT ALL ON SCHEMA public TO postgres; 
GRANT ALL ON SCHEMA public TO public; 
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_admin(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_admin(admin_name character varying, uname character varying, hashed_password character varying, email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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


ALTER FUNCTION public.add_admin(admin_name character varying, uname character varying, hashed_password character varying, email character varying) OWNER TO postgres;

--
-- Name: add_course(character varying, integer, integer, integer, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_course(cname character varying, cnum integer, dept integer, offered_dept integer, offered_batch integer, offered_year integer, offered_level integer, offered_term integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    begin
        insert into course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term)
        values(default,cname,cnum,dept,offered_dept,offered_batch,offered_year,offered_level,offered_term);
    end;
$$;


ALTER FUNCTION public.add_course(cname character varying, cnum integer, dept integer, offered_dept integer, offered_batch integer, offered_year integer, offered_level integer, offered_term integer) OWNER TO postgres;

--
-- Name: add_course_post(integer, character varying, boolean, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_course_post(courseid integer, userid character varying, isstudent boolean, title character varying, content character varying, parentpost integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_course_post(courseid integer, userid character varying, isstudent boolean, title character varying, content character varying, parentpost integer) OWNER TO postgres;

--
-- Name: add_course_post_file(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_course_post_file(postid integer, filename character varying, filelink character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    begin
        insert into course_post_file(file_id, post_id, file_name, file_link)
        values(default,postID,fileName,fileLink);
    end;
$$;


ALTER FUNCTION public.add_course_post_file(postid integer, filename character varying, filelink character varying) OWNER TO postgres;

--
-- Name: add_course_student(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_course_student(std_id integer, sectionno integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
    std_no integer;
    begin
        std_no:=get_student_no(std_id);
        insert into enrolment(enrol_id, student_id, section_id)
        values (default,std_no,sectionNo);
    end;
$$;


ALTER FUNCTION public.add_course_student(std_id integer, sectionno integer) OWNER TO postgres;

--
-- Name: add_course_teacher(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_course_teacher(uname character varying, courseid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
    tid integer;
    begin
        tid:=get_teacher_id(uname);
        insert into instructor(instructor_id, teacher_id, course_id)
        values (default,tid,courseID);
    end;
$$;


ALTER FUNCTION public.add_course_teacher(uname character varying, courseid integer) OWNER TO postgres;

--
-- Name: add_course_topic(character varying, integer, character varying, character varying, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_course_topic(tname character varying, courseid integer, username character varying, topicdescription character varying, ended boolean) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
    tid integer;
    ins_id integer;
begin
    tid = get_teacher_id(username);
    select instructor_id into ins_id from instructor where teacher_id=tid and course_id=courseID;
    insert into topic(topic_num, topic_name, instructor_id, finished, description)
    values (default,tname,ins_id,ended,topicDescription);
end;
$$;


ALTER FUNCTION public.add_course_topic(tname character varying, courseid integer, username character varying, topicdescription character varying, ended boolean) OWNER TO postgres;

--
-- Name: add_evaluation(integer, integer, character varying, character varying, timestamp with time zone, timestamp with time zone, double precision, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_evaluation(typeid integer, sectionno integer, uname character varying, caption_exten character varying, start_time timestamp with time zone, end_time timestamp with time zone, marks double precision, descrip character varying, filelink character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
        insID integer;
        courseNO integer;
        ans integer;
    begin
        select course_id into courseNO from section
        where section_no=sectionNo;
        tid:=get_teacher_id(uname);
        select instructor_id into insID from instructor
        where course_id=courseNO and teacher_id=tid;
        insert into evaluation(evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, total_marks, description, link)
        values(default,typeID,sectionNo,insID,caption_exten,start_time,end_time,marks,descrip,fileLink) returning evaluation_id into ans;
        return ans;
    end;
$$;


ALTER FUNCTION public.add_evaluation(typeid integer, sectionno integer, uname character varying, caption_exten character varying, start_time timestamp with time zone, end_time timestamp with time zone, marks double precision, descrip character varying, filelink character varying) OWNER TO postgres;

--
-- Name: add_extra_class(integer, character varying, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_extra_class(sectionno integer, uname character varying, start_time timestamp with time zone, end_time timestamp with time zone) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
        insID integer;
        courseNO integer;
        ans integer;
    begin
        select course_id into courseNO from section
        where section_no=sectionNo;
        tid:=get_teacher_id(uname);
        select instructor_id into insID from instructor
        where course_id=courseNO and teacher_id=tid;
        insert into extra_class(extra_class_id, section_no, instructor_id, start, _end)
        values(default,sectionNo,insID,start_time,end_time) returning extra_class_id into ans;
        return ans;
    end;
$$;


ALTER FUNCTION public.add_extra_class(sectionno integer, uname character varying, start_time timestamp with time zone, end_time timestamp with time zone) OWNER TO postgres;

--
-- Name: add_forum_post(character varying, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_forum_post(uname character varying, title character varying, content character varying, parentpost integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_forum_post(uname character varying, title character varying, content character varying, parentpost integer) OWNER TO postgres;

--
-- Name: add_forum_post_file(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_forum_post_file(postid integer, filename character varying, filelink character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    begin
        insert into forum_post_files(file_id, post_id, file_name, file_link)
        values(default,postID,fileName,fileLink);
    end;
$$;


ALTER FUNCTION public.add_forum_post_file(postid integer, filename character varying, filelink character varying) OWNER TO postgres;

--
-- Name: add_student(character varying, character varying, integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_student(name character varying, hashed_password character varying, roll integer, dept integer, batch integer, email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    begin
        insert into student(student_id,student_name, password, _year, roll_num, dept_code, email_address)
        values (default,name,hashed_password,batch,roll,dept,email);
    end;
$$;


ALTER FUNCTION public.add_student(name character varying, hashed_password character varying, roll integer, dept integer, batch integer, email character varying) OWNER TO postgres;

--
-- Name: add_teacher(character varying, character varying, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_teacher(name character varying, uname character varying, hashed_password character varying, dept integer, email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.add_teacher(name character varying, uname character varying, hashed_password character varying, dept integer, email character varying) OWNER TO postgres;

--
-- Name: cancel_class_day_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cancel_class_day_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.cancel_class_day_check() OWNER TO postgres;

--
-- Name: cancel_class_teacher(character varying, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cancel_class_teacher(uname character varying, classno integer, canceldate date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        courseNo integer;
        tid integer;
        insID integer;
        ans integer;
    begin
        select s.course_id into courseNo from course_routine cr join section s on cr.section_no = s.section_no;
        tid:=get_teacher_id(uname);
        select instructor_id into insID from instructor
        where course_id=courseNo and teacher_id=tid;
        insert into canceled_class(canceled_class_id, class_id, _date, instructor_id)
        values (default,classNo,cancelDate,insID) returning canceled_class_id into ans;
        return  ans;
    end;
$$;


ALTER FUNCTION public.cancel_class_teacher(uname character varying, classno integer, canceldate date) OWNER TO postgres;

--
-- Name: class_class_conflict_student(time without time zone, time without time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.class_class_conflict_student(start_time time without time zone, end_time time without time zone, weekday integer, sec_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.class_class_conflict_student(start_time time without time zone, end_time time without time zone, weekday integer, sec_id integer) OWNER TO postgres;

--
-- Name: class_class_conflict_teacher(time without time zone, time without time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.class_class_conflict_teacher(start_time time without time zone, end_time time without time zone, weekday integer, ins_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.class_class_conflict_teacher(start_time time without time zone, end_time time without time zone, weekday integer, ins_id integer) OWNER TO postgres;

--
-- Name: class_event_conflict_student(time without time zone, time without time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.class_event_conflict_student(start_time time without time zone, end_time time without time zone, weekday integer, sec_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.class_event_conflict_student(start_time time without time zone, end_time time without time zone, weekday integer, sec_id integer) OWNER TO postgres;

--
-- Name: class_event_conflict_teacher(time without time zone, time without time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.class_event_conflict_teacher(start_time time without time zone, end_time time without time zone, weekday integer, ins_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.class_event_conflict_teacher(start_time time without time zone, end_time time without time zone, weekday integer, ins_id integer) OWNER TO postgres;

--
-- Name: course_routine_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.course_routine_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.course_routine_check() OWNER TO postgres;

--
-- Name: cr_assignment_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cr_assignment_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.cr_assignment_check() OWNER TO postgres;

--
-- Name: curr_course_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.curr_course_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
    refresh materialized view current_courses;
	refresh materialized view all_courses;
    return null;
end;
$$;


ALTER FUNCTION public.curr_course_update() OWNER TO postgres;

--
-- Name: evaluation_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.evaluation_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.evaluation_check() OWNER TO postgres;

--
-- Name: event_class_conflict(time without time zone, time without time zone, date, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.event_class_conflict(start_time time without time zone, end_time time without time zone, curr_date date, sec_id integer, ins_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.event_class_conflict(start_time time without time zone, end_time time without time zone, curr_date date, sec_id integer, ins_id integer) OWNER TO postgres;

--
-- Name: event_event_conflict(timestamp with time zone, timestamp with time zone, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.event_event_conflict(start_timestamp timestamp with time zone, end_timestamp timestamp with time zone, sec_id integer, ins_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.event_event_conflict(start_timestamp timestamp with time zone, end_timestamp timestamp with time zone, sec_id integer, ins_id integer) OWNER TO postgres;

--
-- Name: extra_class_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.extra_class_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.extra_class_check() OWNER TO postgres;

--
-- Name: extra_evaluation_instructor_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.extra_evaluation_instructor_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.extra_evaluation_instructor_check() OWNER TO postgres;

--
-- Name: extra_teacher_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.extra_teacher_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.extra_teacher_check() OWNER TO postgres;

--
-- Name: get_account_type(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_account_type(uname character varying) RETURNS TABLE(id integer, type character varying, hashed_password character)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_account_type(uname character varying) OWNER TO postgres;

--
-- Name: get_all_course(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_course(std_id integer) RETURNS TABLE(id integer, term character varying, _year integer, dept_shortname character varying, course_code integer, course_name character varying, submitted integer)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name,count(ev.evaluation_id)::integer
from ((
    (select student_id from student
    where (mod(student._year,100)*100000+dept_code*1000+roll_num)=std_id
     ) s join (
         select enrol_id,student_id,section_id from enrolment
    ) e on s.student_id=e.student_id join section sec on e.section_id=sec.section_no join all_courses cc on sec.course_id=cc._id)
left outer join evaluation ev on (ev.section_no=e.section_id and ev._end>current_timestamp)) left outer join submission s2 on (s2.enrol_id=e.enrol_id)
group by _id,_term,__year,_dept_shortname,_course_code,_course_name;
end
$$;


ALTER FUNCTION public.get_all_course(std_id integer) OWNER TO postgres;

--
-- Name: get_all_course_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_course_admin() RETURNS TABLE(id integer, term character varying, _year integer, dept_shortname character varying, course_code integer, course_name character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from all_courses cc
    ;
    end
$$;


ALTER FUNCTION public.get_all_course_admin() OWNER TO postgres;

--
-- Name: get_all_course_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_course_teacher(teacher_username character varying) RETURNS TABLE(id integer, term character varying, _year integer, dept_shortname character varying, course_code integer, course_name character varying)
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from all_courses cc join instructor i on cc._id=i.course_id join teacher t on i.teacher_id = t.teacher_id
    where t.teacher_id=tid;
    end
$$;


ALTER FUNCTION public.get_all_course_teacher(teacher_username character varying) OWNER TO postgres;

--
-- Name: get_all_student_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_student_admin() RETURNS TABLE(std_id integer, name character varying, dept character varying, email character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select (mod(_year,100)*100000+d.dept_code*1000+roll_num) as id,student_name,email_address,d.dept_shortname from student join department d on student.dept_code = d.dept_code;
    end
$$;


ALTER FUNCTION public.get_all_student_admin() OWNER TO postgres;

--
-- Name: get_all_teacher_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_teacher_admin() RETURNS TABLE(teacher_username character varying, name character varying, dept character varying, email character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select ou.username,t.teacher_name, d.dept_shortname,ou.email_address from teacher t join department d on t.dept_code = d.dept_code join official_users ou on t.user_no = ou.user_no;
    end
$$;


ALTER FUNCTION public.get_all_teacher_admin() OWNER TO postgres;

--
-- Name: get_cancel_class_notifications(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_cancel_class_notifications(std_id integer) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, teacherid integer, dept_shortname character varying, course_code integer, eventtypename character varying, teachernamr character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select ne.event_type,ne.event_no,c._id,tp.teacher_id,c._dept_shortname,c._course_code,cast('Canceled Class' as varchar),tp.teacher_name,ne.notifucation_time, ne._date
from canceled_class cc join notification_event ne on cc.canceled_class_id=ne.not_id
join instructor i on cc.instructor_id = i.instructor_id
join teacher tp on i.teacher_id = tp.teacher_id
join current_courses c on c._id=i.course_id
join course_routine cr on cc.class_id=cr.class_id
join section s on cr.section_no=s.section_no
join enrolment e on s.section_no=e.section_id
join student s2 on e.student_id = s2.student_id
where ne.event_type=3 and  (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=std_id and s2.notification_last_seen<ne.notifucation_time;
    end
$$;


ALTER FUNCTION public.get_cancel_class_notifications(std_id integer) OWNER TO postgres;

--
-- Name: get_cancel_class_notifications_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_cancel_class_notifications_teacher(teacher_username character varying) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, teacherid integer, dept_shortname character varying, course_code integer, eventtypename character varying, teachernamr character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
        select ne.event_type,ne.event_no,c._id,tp.teacher_id,c._dept_shortname,c._course_code,cast('Canceled Class' as varchar),tp.teacher_name,ne.notifucation_time, ne._date
        from canceled_class cc join notification_event ne on cc.canceled_class_id=ne.not_id
        join instructor ip on cc.instructor_id = ip.instructor_id
        join current_courses c on c._id=ip.course_id
        join teacher_routine tr on cc.class_id = tr.class_id
        join teacher tp on ip.teacher_id = tp.teacher_id
        join instructor iv on tr.instructor_id = iv.instructor_id
        join teacher tv on iv.teacher_id=tv.teacher_id
        where ne.event_type=3 and tv.teacher_id!=tp.teacher_id and tv.teacher_id=tid
        and tv.notification_last_seen<ne.notifucation_time;
    end
$$;


ALTER FUNCTION public.get_cancel_class_notifications_teacher(teacher_username character varying) OWNER TO postgres;

--
-- Name: get_classes_teacher(character varying, integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_classes_teacher(uname character varying, secno integer, checkdate date) RETURNS TABLE(classid integer, start_time time without time zone, end_time time without time zone)
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(uname);
    return query
    select cr.class_id,cr.start,cr._end
from course_routine cr join teacher_routine tr on cr.class_id = tr.class_id
join instructor i on tr.instructor_id = i.instructor_id
join teacher t on i.teacher_id = t.teacher_id
where t.teacher_id=tid and cr.section_no=secNo and cr.day=extract(isodow from checkDate)-1
and not exists(
    select * from canceled_class
    where class_id=cr.class_id and _date=checkDate
);
    end;
$$;


ALTER FUNCTION public.get_classes_teacher(uname character varying, secno integer, checkdate date) OWNER TO postgres;

--
-- Name: get_course_children_post(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_children_post(parent integer) RETURNS TABLE(postid integer)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select post_id from course_post where parent_post=parent;
    end
$$;


ALTER FUNCTION public.get_course_children_post(parent integer) OWNER TO postgres;

--
-- Name: get_course_cr(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_cr(courseid integer) RETURNS TABLE(sectionid integer, sectionname character varying, crid integer, crname character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select sec.section_no,sec.section_name,(mod(s._year,100)*100000+s.dept_code*1000+s.roll_num) as sid,s.student_name from section sec left outer join student s on sec.cr_id = s.student_id where sec.course_id=courseID;
    end
$$;


ALTER FUNCTION public.get_course_cr(courseid integer) OWNER TO postgres;

--
-- Name: get_course_evaluations(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_evaluations(std_id integer, crs_id integer) RETURNS TABLE(id integer, event_type character varying, event_date date, event_description character varying, published boolean, completed boolean, filelink character varying)
    LANGUAGE plpgsql
    AS $$
    declare
    begin
    return query
    select ev.evaluation_id as _id,et.type_name,ev.start::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp),link from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id join current_courses cc on cc._id=s.course_id
where cc._id=crs_id and et.notification_time_type=false and mod(_year,100)*100000+dept_code*1000+roll_num=std_id
union
select ev.evaluation_id as _id,et.type_name,ev._end::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp),link from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id join current_courses cc on cc._id=s.course_id
where cc._id=crs_id and et.notification_time_type=true and mod(_year,100)*100000+dept_code*1000+roll_num=std_id
order by _date;
end
$$;


ALTER FUNCTION public.get_course_evaluations(std_id integer, crs_id integer) OWNER TO postgres;

--
-- Name: get_course_evaluations_teacher(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_evaluations_teacher(uname character varying, crs_id integer) RETURNS TABLE(id integer, event_type character varying, event_date date, event_description character varying, published boolean, completed boolean, sec_no integer, sec_name character varying, filelink character varying)
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
    begin
        tid=get_teacher_id(uname);
    return query
    select ev.evaluation_id as _id,et.type_name,ev.start::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp),s.section_no,s.section_name,ev.link from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on ev.instructor_id = i.instructor_id
where cc._id=crs_id and i.teacher_id=tid and et.notification_time_type=false
union
select ev.evaluation_id as _id,et.type_name,ev._end::date as _date,ev.description,(ev.start<=current_timestamp),(ev._end<=current_timestamp),s.section_no,s.section_name,ev.link from evaluation ev join evaluation_type et on ev.type_id = et.type_id join section s on ev.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on ev.instructor_id = i.instructor_id
where cc._id=crs_id and i.teacher_id=tid and et.notification_time_type=true
order by _date;
end
$$;


ALTER FUNCTION public.get_course_evaluations_teacher(uname character varying, crs_id integer) OWNER TO postgres;

--
-- Name: get_course_marks(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_marks(uname character varying, eid integer) RETURNS TABLE(eventid integer, userid integer, studentname character varying, event_type character varying, event_desc character varying, term character varying, year integer, deptcode character varying, coursenum integer, event_date date, totalmarks double precision, obtainedmarks double precision)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_course_marks(uname character varying, eid integer) OWNER TO postgres;

--
-- Name: get_course_post_file(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_post_file(pid integer) RETURNS TABLE(fileid integer, filename character varying, filelink character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select file_id,file_name,file_link from course_post_file where post_id=pID;
    end
$$;


ALTER FUNCTION public.get_course_post_file(pid integer) OWNER TO postgres;

--
-- Name: get_course_post_notifications(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_post_notifications(std_id integer) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, userid integer, dept_shortname character varying, course_code integer, eventtypename character varying, postername character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    declare
    begin
    return query
    (select ne.event_type,ne.event_no,c._id,t.teacher_id,c._dept_shortname,c._course_code,cast('Course Forum Post' as varchar),t.teacher_name,ne.notifucation_time, ne._date
    from notification_event ne join course_post cp on ne.event_no=cp.post_id join instructor i on i.instructor_id=cp.poster_id
    join current_courses c on i.course_id = c._id join section s on c._id = s.course_id
    join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id
    join teacher t on i.teacher_id = t.teacher_id
    where student_post=false and ne.event_type=4 and  (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=std_id and s2.notification_last_seen<ne.notifucation_time)
    union
    (select ne.event_type,ne.event_no,c._id,ps.student_id,c._dept_shortname,c._course_code,cast('Course Forum Post' as varchar),ps.student_name,ne.notifucation_time, ne._date
    from notification_event ne join course_post cp on ne.event_no=cp.post_id join enrolment ep on ep.enrol_id=cp.poster_id
    join section sec1 on ep.section_id = sec1.section_no join current_courses c on sec1.course_id=c._id
    join student ps on ps.student_id = ep.student_id
    join section s on s.course_id = c._id
    join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id
    where student_post=true and ps.student_id!=s2.student_id and ne.event_type=4 and  (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=std_id and s2.notification_last_seen<ne.notifucation_time);
end
$$;


ALTER FUNCTION public.get_course_post_notifications(std_id integer) OWNER TO postgres;

--
-- Name: get_course_post_notifications_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_post_notifications_teacher(uname character varying) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, userid integer, dept_shortname character varying, course_code integer, eventtypename character varying, postername character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    declare
    begin
    return query
    (select ne.event_type,ne.event_no,c._id,t.teacher_id,c._dept_shortname,c._course_code,cast('Course Forum Post' as varchar),t.teacher_name,ne.notifucation_time, ne._date
    from notification_event ne join course_post cp on ne.event_no=cp.post_id join instructor i on i.instructor_id=cp.poster_id
    join current_courses c on i.course_id = c._id
    join teacher t on i.teacher_id = t.teacher_id
    join instructor iv on iv.course_id=c._id
    join teacher tv on tv.teacher_id=iv.teacher_id
    join official_users ou on ou.user_no=tv.user_no
    where student_post=false and ne.event_type=4 and ou.username=uname and tv.teacher_id!=t.teacher_id and tv.notification_last_seen<ne.notifucation_time)
    union
    (select ne.event_type,ne.event_no,c._id,ps.student_id,c._dept_shortname,c._course_code,cast('Course Forum Post' as varchar),ps.student_name,ne.notifucation_time, ne._date
    from notification_event ne join course_post cp on ne.event_no=cp.post_id join enrolment ep on ep.enrol_id=cp.poster_id
    join section sec1 on ep.section_id = sec1.section_no join current_courses c on sec1.course_id=c._id
    join student ps on ps.student_id = ep.student_id
    join instructor iv on iv.course_id=c._id
    join teacher tv on tv.teacher_id=iv.teacher_id
    join official_users ou on ou.user_no=tv.user_no
    where student_post=true and ne.event_type=4 and ou.username=uname and  tv.notification_last_seen<ne.notifucation_time);
end
$$;


ALTER FUNCTION public.get_course_post_notifications_teacher(uname character varying) OWNER TO postgres;

--
-- Name: get_course_posts(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_posts(userid integer) RETURNS TABLE(teacherid integer, courseid integer, coursedept character varying, coursenum integer, courseterm character varying, courseyear integer, name character varying, postid integer, postname character varying, postcontent character varying, posttime timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    select t.teacher_id,c._id,c._dept_shortname,c._course_code,c._term,c.__year,t.teacher_name,cp.post_id,cp.post_name,cp.post_content,cp.post_time from course_post cp join instructor i on i.instructor_id=cp.poster_id join teacher t on i.teacher_id = t.teacher_id join official_users ou on t.user_no = ou.user_no join current_courses c on i.course_id = c._id join section s on i.course_id = s.course_id join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id
where cp.parent_post is null and (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=userID;
end
$$;


ALTER FUNCTION public.get_course_posts(userid integer) OWNER TO postgres;

--
-- Name: get_course_posts_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_posts_teacher(uname character varying) RETURNS TABLE(teacherid integer, courseid integer, coursedept character varying, coursenum integer, courseterm character varying, courseyear integer, name character varying, postid integer, postname character varying, postcontent character varying, posttime timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    select t.teacher_id,c._id,c._dept_shortname,c._course_code,c._term,c.__year,t.teacher_name,cp.post_id,cp.post_name,cp.post_content,cp.post_time from course_post cp join instructor i on i.instructor_id=cp.poster_id join teacher t on i.teacher_id = t.teacher_id join official_users ou on t.user_no = ou.user_no join current_courses c on i.course_id = c._id
where ou.username!=uname and cp.parent_post is null;
end
$$;


ALTER FUNCTION public.get_course_posts_teacher(uname character varying) OWNER TO postgres;

--
-- Name: get_course_students(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_students(courseid integer) RETURNS TABLE(std_id integer, std_name character varying, enrolid integer, sec_no integer, sec_name character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select (mod(s._year,100)*100000+s.dept_code*1000+s.roll_num) as sid, s.student_name,e.enrol_id,s2.section_no,s2.section_name from student s join enrolment e on s.student_id = e.student_id join section s2 on e.section_id = s2.section_no join course c on s2.course_id = c.course_id
where c.course_id=courseID;
    end
$$;


ALTER FUNCTION public.get_course_students(courseid integer) OWNER TO postgres;

--
-- Name: get_course_teachers(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_teachers(courseid integer) RETURNS TABLE(uname character varying, teachername character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select ou.username, t.teacher_name from teacher t join official_users ou on t.user_no = ou.user_no join instructor i on t.teacher_id = i.teacher_id join course c on i.course_id = c.course_id
where c.course_id=courseID;
    end
$$;


ALTER FUNCTION public.get_course_teachers(courseid integer) OWNER TO postgres;

--
-- Name: get_course_topics(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_course_topics(courseid integer) RETURNS TABLE(topic_number integer, teacher_number integer, instructor_number integer, title character varying, topic_description character varying, teachername character varying, isfinished boolean, start_time timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
    begin
	return query
    select topic_num, t.teacher_id, i.instructor_id, topic_name,description,teacher_name,finished,started
from topic tp join instructor i on tp.instructor_id = i.instructor_id join current_courses c on c._id = i.course_id join teacher t on i.teacher_id = t.teacher_id
where course_id = courseID
order by started;
    end
$$;


ALTER FUNCTION public.get_course_topics(courseid integer) OWNER TO postgres;

--
-- Name: get_current_course(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_current_course(std_id integer) RETURNS TABLE(id integer, term character varying, _year integer, dept_shortname character varying, course_code integer, course_name character varying, submitted integer)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_current_course(std_id integer) OWNER TO postgres;

--
-- Name: get_current_course_admin(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_current_course_admin() RETURNS TABLE(id integer, term character varying, _year integer, dept_shortname character varying, course_code integer, course_name character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from current_courses cc
    ;
    end
$$;


ALTER FUNCTION public.get_current_course_admin() OWNER TO postgres;

--
-- Name: get_current_course_post(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_current_course_post(pid integer) RETURNS TABLE(postid integer, posterid integer, title character varying, description character varying, teacherorstudentid character varying, postername character varying, posttime timestamp with time zone, isadmin boolean)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_current_course_post(pid integer) OWNER TO postgres;

--
-- Name: get_current_course_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_current_course_teacher(teacher_username character varying) RETURNS TABLE(id integer, term character varying, _year integer, dept_shortname character varying, course_code integer, course_name character varying)
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
    from current_courses cc join instructor i on cc._id=i.course_id join teacher t on i.teacher_id = t.teacher_id
    where t.teacher_id=tid;
    end
$$;


ALTER FUNCTION public.get_current_course_teacher(teacher_username character varying) OWNER TO postgres;

--
-- Name: get_current_forum_post(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_current_forum_post(pid integer) RETURNS TABLE(postid integer, posterid integer, title character varying, description character varying, uname character varying, postername character varying, posttime timestamp with time zone, isadmin boolean)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        (select fp.post_id,fp.poster,fp.post_name,fp.post_content,ou.username,t.teacher_name,fp.post_time,cast(false as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where post_id=pID)
union
(select fp.post_id,fp.poster,fp.post_name,fp.post_content,ou.username,a.name,fp.post_time,cast(true as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where post_id=pID);
    end
$$;


ALTER FUNCTION public.get_current_forum_post(pid integer) OWNER TO postgres;

--
-- Name: get_day_events(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_day_events(std_id integer, query_date date) RETURNS TABLE(eventid integer, sectionid integer, id integer, dept_shortname character varying, course_code integer, lookup_time time without time zone, event_type character varying)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    select ut.eid, ut.section_no,cc._id,cc._dept_shortname,cc._course_code, _lookup_time,_event_type from (
                                                  ((select cr.class_id as eid,section_no, start::time as _lookup_time, cast('Class' as varchar) as _event_type
                                                    from course_routine cr
                                                    where day = extract(isodow from query_date) - 1
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = query_date
                                                        ))
                                                   union
                                                   (select extra_class_id as eid,section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type
                                                    from extra_class
                                                    where start::date = query_date)
                                                   union
                                                   (select e.evaluation_id as eid,section_no, start::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and start::date = query_date)
                                                   union
                                                   (select e.evaluation_id as eid,section_no, _end::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = true)
                                                                      and _end::date = query_date))) ut join
    (
        select section_id from enrolment join student on (enrolment.student_id = student.student_id) where mod(_year,100)*100000+dept_code*1000+roll_num=std_id
    ) ss on (ut.section_no=ss.section_id) join section s on (ss.section_id=s.section_no) join current_courses cc on (s.course_id=cc._id)
    order by ut._lookup_time;
end
$$;


ALTER FUNCTION public.get_day_events(std_id integer, query_date date) OWNER TO postgres;

--
-- Name: get_day_events_teacher(character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_day_events_teacher(teacher_username character varying, query_date date) RETURNS TABLE(eventid integer, sectionid integer, id integer, dept_shortname character varying, course_code integer, lookup_time time without time zone, event_type character varying)
    LANGUAGE plpgsql
    AS $$
    declare
        tid integer;
    begin
        tid:=get_teacher_id(teacher_username);
    return query
    select ut.eid,ut.section_no,cc._id,cc._dept_shortname,cc._course_code, _lookup_time,_event_type from (
                                                  ((select cr.class_id as eid,section_no, start::time as _lookup_time, cast('Class' as varchar) as _event_type, tr.instructor_id as instructor_id
                                                    from course_routine cr join teacher_routine tr on cr.class_id = tr.class_id
                                                    where day = extract(isodow from query_date) - 1
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = query_date
                                                        ))
                                                   union
                                                   (select extra_class_id as eid,section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type,instructor_id as instructor_id
                                                    from extra_class
                                                    where start::date = query_date)
                                                   union
                                                   (select ect.extra_class_id as eid,section_no, start::time as _lookup_time, cast('Extra Class' as varchar) as _event_type,ect.instructor_id as instructor_id
                                                    from extra_class join extra_class_teacher ect on extra_class.extra_class_id = ect.extra_class_id
                                                    where start::date = query_date)
                                                   union
                                                   (select e.evaluation_id as eid,section_no, start::time as _lookup_time, et.type_name as _event_type, e.instructor_id as instructor_id
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and start::date = query_date)
                                                   union
                                                   (select eet.evaluation_id as eid,section_no, start::time as _lookup_time, et.type_name as _event_type,eet.instructor_id
                                                    from evaluation e join extra_evaluation_instructor eet on e.evaluation_id = eet.evaluation_id
                                                             join evaluation_type et
                                                                  on (et.type_id = e.type_id and et.notification_time_type = false)
                                                                      and _end::date = query_date))) ut join
    instructor i on i.instructor_id=ut.instructor_id join current_courses cc on (i.course_id=cc._id)
    where i.teacher_id=tid
    order by _lookup_time;
end
$$;


ALTER FUNCTION public.get_day_events_teacher(teacher_username character varying, query_date date) OWNER TO postgres;

--
-- Name: get_day_events_to_schedule(integer, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_day_events_to_schedule(secno integer, query_date date) RETURNS TABLE(eventid integer, secid integer, courseid integer, dept_shortname character varying, course_code integer, start_time time without time zone, end_time time without time zone, event_type character varying)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    (select class_id, cr.section_no, cc._id,cc._dept_shortname,cc._course_code, start::time,_end::time,cast('Class' as varchar) as _event_type
from course_routine cr join section sec on cr.section_no=sec.section_no join current_courses cc on cc._id=sec.course_id join intersected_sections isec on isec.second_section=sec.section_no
where isec.first_section=secNo
 and day = extract(isodow from query_date) - 1
  and not exists (select class_id from canceled_class cc
 where cc.class_id = cr.class_id and _date = query_date))
union
(select extra_class_id,ec.section_no, cc._id,cc._dept_shortname,cc._course_code, start::time,_end::time,cast('Extra Class' as varchar) as _event_type
from extra_class ec join section sec on ec.section_no = sec.section_no join current_courses cc on cc._id=sec.course_id join intersected_sections isec on isec.second_section=sec.section_no
where isec.first_section=secNo and _date= query_date)
union
(select evaluation_id,e.section_no, cc._id,cc._dept_shortname,cc._course_code, start::time,_end::time, et.type_name as _event_type
from evaluation e join evaluation_type et on (et.type_id = e.type_id and et.notification_time_type = false)
join section sec on e.section_no = sec.section_no join current_courses cc on cc._id=sec.course_id join intersected_sections isec on isec.second_section=sec.section_no
where isec.first_section=secNo and start::date = query_date);
end
$$;


ALTER FUNCTION public.get_day_events_to_schedule(secno integer, query_date date) OWNER TO postgres;

--
-- Name: get_dept_list(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_dept_list() RETURNS TABLE(dept_code integer, dept_name character varying, dept_shortname character varying)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    select * from department;
end
$$;


ALTER FUNCTION public.get_dept_list() OWNER TO postgres;

--
-- Name: get_evaluation_notifications(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_evaluation_notifications(std_id integer) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, teacherid integer, dept_shortname character varying, course_code integer, eventtypename character varying, teachernamr character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    declare
    begin
    return query
    select ne.event_type,ne.event_no,cc._id,t.teacher_id,cc._dept_shortname,cc._course_code,et.type_name,t.teacher_name,ne.notifucation_time, ne._date from notification_event ne join evaluation ec on ne.event_no=ec.evaluation_id join evaluation_type et on ec.type_id = et.type_id
    join section s on ec.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on ec.instructor_id = i.instructor_id join teacher t on i.teacher_id = t.teacher_id join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id
where ne.event_type=2 and  (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=std_id and s2.notification_last_seen<ne.notifucation_time
order by ne.notifucation_time desc;
end
$$;


ALTER FUNCTION public.get_evaluation_notifications(std_id integer) OWNER TO postgres;

--
-- Name: get_evaluation_notifications_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_evaluation_notifications_teacher(teacher_username character varying) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, teacherid integer, dept_shortname character varying, course_code integer, eventtypename character varying, teachernamr character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    declare
    begin
    return query
    select ne.event_type,ne.event_no,cc._id,t.teacher_id,cc._dept_shortname,cc._course_code,et.type_name,t.teacher_name,ne.notifucation_time, ne._date from notification_event ne join evaluation ec on ne.event_no=ec.evaluation_id join evaluation_type et on ec.type_id = et.type_id
   join extra_evaluation_instructor eei on ec.evaluation_id = eei.evaluation_id join section s on ec.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on eei.instructor_id = i.instructor_id join instructor j on j.instructor_id=ec.instructor_id join teacher t on j.teacher_id = t.teacher_id join teacher t2 on t2.teacher_id=i.teacher_id join official_users ou on t2.user_no = ou.user_no
where ne.event_type=2 and ou.username=teacher_username and t2.notification_last_seen<ne.notifucation_time
order by ne.notifucation_time desc;
end
$$;


ALTER FUNCTION public.get_evaluation_notifications_teacher(teacher_username character varying) OWNER TO postgres;

--
-- Name: get_event_description(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_event_description(event integer) RETURNS TABLE(eventid integer, eventtype character varying, description character varying, subtime timestamp with time zone, filelink character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    select e.evaluation_id,et.type_name,e.description,e._end,e.link from evaluation e join evaluation_type et on et.type_id = e.type_id
    where e.evaluation_id=event;
    end
$$;


ALTER FUNCTION public.get_event_description(event integer) OWNER TO postgres;

--
-- Name: get_extra_class_notifications(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_extra_class_notifications(std_id integer) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, teacherid integer, dept_shortname character varying, course_code integer, eventtypename character varying, teachernamr character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    declare
    begin
    return query
    select ne.event_type,ne.event_no,cc._id,t.teacher_id,cc._dept_shortname,cc._course_code,cast('Extra Class' as varchar),t.teacher_name,ne.notifucation_time, ne._date from notification_event ne join extra_class ec on ne.event_no=ec.extra_class_id
    join section s on ec.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on ec.instructor_id = i.instructor_id join teacher t on i.teacher_id = t.teacher_id join enrolment e on s.section_no = e.section_id join student s2 on e.student_id = s2.student_id
where ne.event_type=1 and  (mod(s2._year,100)*100000+s2.dept_code*1000+s2.roll_num)=std_id and s2.notification_last_seen<ne.notifucation_time
order by ne.notifucation_time desc;
end
$$;


ALTER FUNCTION public.get_extra_class_notifications(std_id integer) OWNER TO postgres;

--
-- Name: get_extra_class_notifications_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_extra_class_notifications_teacher(teacher_username character varying) RETURNS TABLE(eventtype integer, eventno integer, courseid integer, teacherid integer, dept_shortname character varying, course_code integer, eventtypename character varying, teachernamr character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    declare
    begin
    return query
    select ne.event_type,ne.event_no,cc._id,t.teacher_id,cc._dept_shortname,cc._course_code,cast('Extra Class' as varchar),t.teacher_name,ne.notifucation_time, ne._date from notification_event ne join evaluation ec on ne.event_no=ec.evaluation_id
   join extra_class_teacher eei on ec.evaluation_id = eei.extra_class_id join section s on ec.section_no = s.section_no join current_courses cc on cc._id=s.course_id join instructor i on eei.instructor_id = i.instructor_id join instructor j on j.instructor_id=ec.instructor_id join teacher t on j.teacher_id = t.teacher_id join teacher t2 on t2.teacher_id=i.teacher_id join official_users ou on t2.user_no = ou.user_no
where ne.event_type=1 and ou.username=teacher_username and t2.notification_last_seen<ne.notifucation_time
order by ne.notifucation_time desc;
end
$$;


ALTER FUNCTION public.get_extra_class_notifications_teacher(teacher_username character varying) OWNER TO postgres;

--
-- Name: get_forum_children_post(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_forum_children_post(parent integer) RETURNS TABLE(postid integer)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select post_id from forum_post where parent_post=parent;
    end
$$;


ALTER FUNCTION public.get_forum_children_post(parent integer) OWNER TO postgres;

--
-- Name: get_forum_post_file(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_forum_post_file(pid integer) RETURNS TABLE(fileid integer, filename character varying, filelink character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select file_id,file_name,file_link from forum_post_files where post_id=pID;
    end
$$;


ALTER FUNCTION public.get_forum_post_file(pid integer) OWNER TO postgres;

--
-- Name: get_forum_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_forum_posts() RETURNS TABLE(id integer, teacher boolean, name character varying, postid integer, postname character varying, postcontent character varying, posttime timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    select t.teacher_id,cast(true as boolean) as isTeacher,t.teacher_name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where fp.parent_post is null
union
select a.admin_id,cast(false as boolean) as isTeacher,a.name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where  fp.parent_post is null;
end
$$;


ALTER FUNCTION public.get_forum_posts() OWNER TO postgres;

--
-- Name: get_forum_posts_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_forum_posts_teacher(uname character varying) RETURNS TABLE(id integer, teacher boolean, name character varying, postid integer, postname character varying, postcontent character varying, posttime timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
begin
    return query
    select t.teacher_id,cast(true as boolean) as isTeacher,t.teacher_name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where ou.username!=uname and fp.parent_post is null
union
select a.admin_id,cast(false as boolean) as isTeacher,a.name,fp.post_id,fp.post_name,fp.post_content,fp.post_time from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where  fp.parent_post is null;
end
$$;


ALTER FUNCTION public.get_forum_posts_teacher(uname character varying) OWNER TO postgres;

--
-- Name: get_my_marks(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_my_marks(userid integer, eid integer) RETURNS TABLE(eventid integer, event_type character varying, event_desc character varying, term character varying, year integer, deptcode character varying, coursenum integer, event_date date, totalmarks double precision, obtainedmarks double precision)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_my_marks(userid integer, eid integer) OWNER TO postgres;

--
-- Name: get_root_course_posts(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_root_course_posts(courseid integer) RETURNS TABLE(postid integer, posterid integer, teacherid integer, title character varying, postername character varying, posttime timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select post_id,poster_id,t.teacher_id,post_name,t.teacher_name, post_time from course_post cp join instructor i on i.instructor_id=cp.poster_id join teacher t on i.teacher_id = t.teacher_id join course c on i.course_id = c.course_id
        where c.course_id=courseID and cp.parent_post is null;
    end
$$;


ALTER FUNCTION public.get_root_course_posts(courseid integer) OWNER TO postgres;

--
-- Name: get_root_forum_posts(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_root_forum_posts() RETURNS TABLE(postid integer, posterid integer, title character varying, teacheroradminid integer, postername character varying, posttime timestamp with time zone, isadmin boolean)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        (select fp.post_id,fp.poster,fp.post_name,t.teacher_id,t.teacher_name,fp.post_time,cast(false as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where fp.parent_post is null)
union
(select fp.post_id,fp.poster,fp.post_name,a.admin_id,a.name,fp.post_time,cast(true as boolean) from forum_post fp join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where fp.parent_post is null);
    end
$$;


ALTER FUNCTION public.get_root_forum_posts() OWNER TO postgres;

--
-- Name: get_sections(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_sections(courseid integer) RETURNS TABLE(secno integer, secname character varying)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select section_no,section_name from section
        where course_id=courseID;
end
$$;


ALTER FUNCTION public.get_sections(courseid integer) OWNER TO postgres;

--
-- Name: get_site_news_notifications(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_site_news_notifications() RETURNS TABLE(eventtype integer, eventno integer, username character varying, eventtypename character varying, postername character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    (select ne.event_type,ne.event_no,ou.username,cast ('Site News' as varchar),t.teacher_name,ne.notifucation_time,ne._date from notification_event ne join forum_post fp on ne.event_no=fp.post_id join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where ne.event_type=8)
union
(select ne.event_type,ne.event_no,ou.username,cast ('Site News' as varchar),a.name,ne.notifucation_time,ne._date from notification_event ne join forum_post fp on ne.event_no=fp.post_id join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where ne.event_type=8);
end
$$;


ALTER FUNCTION public.get_site_news_notifications() OWNER TO postgres;

--
-- Name: get_site_news_notifications_official(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_site_news_notifications_official(uname character varying) RETURNS TABLE(eventtype integer, eventno integer, username character varying, eventtypename character varying, postername character varying, notificationtime timestamp with time zone, scheduleddate date)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
    (select ne.event_type,ne.event_no,ou.username,cast ('Site News' as varchar),t.teacher_name,ne.notifucation_time,ne._date from notification_event ne join forum_post fp on ne.event_no=fp.post_id join official_users ou on fp.poster = ou.user_no join teacher t on ou.user_no = t.user_no
where ne.event_type=8 and ou.username!=uname)
union
(select ne.event_type,ne.event_no,ou.username,cast ('Site News' as varchar),a.name,ne.notifucation_time,ne._date from notification_event ne join forum_post fp on ne.event_no=fp.post_id join official_users ou on fp.poster = ou.user_no join admins a on ou.user_no = a.user_no
where ne.event_type=8 and ou.username!=uname);
end
$$;


ALTER FUNCTION public.get_site_news_notifications_official(uname character varying) OWNER TO postgres;

--
-- Name: get_student_no(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_student_no(std_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        ans integer;
    begin
        select student_id into ans from student where (mod(_year,100)*100000+dept_code*1000+roll_num)=std_id;
        return ans;
    end
$$;


ALTER FUNCTION public.get_student_no(std_id integer) OWNER TO postgres;

--
-- Name: get_submission_info(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_submission_info(eventid integer, stdid integer) RETURNS TABLE(subid integer, subtime timestamp with time zone, sublink character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_submission_info(eventid integer, stdid integer) OWNER TO postgres;

--
-- Name: get_submissions(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_submissions(event integer) RETURNS TABLE(subid integer, studentid integer, studentname character varying, sublink character varying, subtime timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
    begin
    return query
        select sub_id,(mod(_year,100)*100000+dept_code*1000+roll_num) as id,student_name,sub.link,sub_time from submission sub join enrolment e on e.enrol_id = sub.enrol_id join student s on e.student_id = s.student_id join evaluation e2 on sub.event_id = e2.evaluation_id
where event_id=event;
    end
$$;


ALTER FUNCTION public.get_submissions(event integer) OWNER TO postgres;

--
-- Name: get_submitted_file_link(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_submitted_file_link(subid integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    declare
        ans varchar;
    begin
        select link into ans from submission where sub_id=subID;
        return ans;
    end
$$;


ALTER FUNCTION public.get_submitted_file_link(subid integer) OWNER TO postgres;

--
-- Name: get_teacher_id(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_teacher_id(teacher_uname character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        ans integer;
    begin
        select teacher_id into ans from teacher join official_users ou on teacher.user_no = ou.user_no
        where username=teacher_uname;
        return ans;
    end
$$;


ALTER FUNCTION public.get_teacher_id(teacher_uname character varying) OWNER TO postgres;

--
-- Name: get_upcoming_events(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_upcoming_events(std_id integer) RETURNS TABLE(id integer, dept_shortname character varying, course_code integer, lookup_time time without time zone, event_type character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_upcoming_events(std_id integer) OWNER TO postgres;

--
-- Name: get_upcoming_events_teacher(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_upcoming_events_teacher(teacher_username character varying) RETURNS TABLE(id integer, dept_shortname character varying, course_code integer, lookup_time time without time zone, event_type character varying)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_upcoming_events_teacher(teacher_username character varying) OWNER TO postgres;

--
-- Name: grading_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.grading_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.grading_check() OWNER TO postgres;

--
-- Name: instructor_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.instructor_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.instructor_check() OWNER TO postgres;

--
-- Name: instructor_section_compare(integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.instructor_section_compare(new_ins_id integer, new_sec_no integer, old_ins_id integer, old_sec_no integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
    $$;


ALTER FUNCTION public.instructor_section_compare(new_ins_id integer, new_sec_no integer, old_ins_id integer, old_sec_no integer) OWNER TO postgres;

--
-- Name: instructor_to_teacher(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.instructor_to_teacher(ins_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        ans integer;
    begin
        select teacher_id into ans from instructor where instructor_id=ins_id;
        return ans;
    end
$$;


ALTER FUNCTION public.instructor_to_teacher(ins_id integer) OWNER TO postgres;

--
-- Name: intersected_section_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.intersected_section_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
    refresh materialized view intersected_sections;
    return null;
end;
$$;


ALTER FUNCTION public.intersected_section_update() OWNER TO postgres;

--
-- Name: make_submission(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.make_submission(eventid integer, stdid integer, sublink character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.make_submission(eventid integer, stdid integer, sublink character varying) OWNER TO postgres;

--
-- Name: mark_topic_done(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.mark_topic_done(top_num integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
    begin
        update topic
        set finished=true
        where topic_num=top_num;
    end;
$$;


ALTER FUNCTION public.mark_topic_done(top_num integer) OWNER TO postgres;

--
-- Name: notification_event_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notification_event_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.notification_event_check() OWNER TO postgres;

--
-- Name: notify_cancel_class(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_cancel_class() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.canceled_class_id,3,new._date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_cancel_class() OWNER TO postgres;

--
-- Name: notify_cancel_class_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_cancel_class_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new._date
    where event_no=new.canceled_class_id and event_type=3;
    return null;
end;
$$;


ALTER FUNCTION public.notify_cancel_class_update() OWNER TO postgres;

--
-- Name: notify_course_post_added(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_course_post_added() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.post_id,4,new.post_time::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_course_post_added() OWNER TO postgres;

--
-- Name: notify_course_post_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_course_post_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.post_time::date
    where event_no=new.post_id and event_type=4;
    return null;
end;
$$;


ALTER FUNCTION public.notify_course_post_updated() OWNER TO postgres;

--
-- Name: notify_evaluation(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_evaluation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.evaluation_id,2,new.start::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_evaluation() OWNER TO postgres;

--
-- Name: notify_evaluation_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_evaluation_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.start::date
    where event_no=new.evaluation_id and event_type=2;
    return null;
end;
$$;


ALTER FUNCTION public.notify_evaluation_update() OWNER TO postgres;

--
-- Name: notify_extra_class(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_extra_class() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.extra_class_id,1,new.start::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_extra_class() OWNER TO postgres;

--
-- Name: notify_extra_class_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_extra_class_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.start::date
    where event_no=new.extra_class_id and event_type=1;
    return null;
end;
$$;


ALTER FUNCTION public.notify_extra_class_update() OWNER TO postgres;

--
-- Name: notify_forum_post_added(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_forum_post_added() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.post_id,8,new.post_time::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_forum_post_added() OWNER TO postgres;

--
-- Name: notify_forum_post_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_forum_post_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.post_time::date
    where event_no=new.post_id and event_type=8;
    return null;
end;
$$;


ALTER FUNCTION public.notify_forum_post_updated() OWNER TO postgres;

--
-- Name: notify_grading(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_grading() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.grading_id,7,new._date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_grading() OWNER TO postgres;

--
-- Name: notify_grading_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_grading_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new._date
    where event_no=new.grading_id and event_type=7;
    return null;
end;
$$;


ALTER FUNCTION public.notify_grading_update() OWNER TO postgres;

--
-- Name: notify_instructor_resource_added(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_instructor_resource_added() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.res_id,5,current_timestamp::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_instructor_resource_added() OWNER TO postgres;

--
-- Name: notify_instructor_resource_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_instructor_resource_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=current_timestamp::date
    where event_no=new.res_id and event_type=5;
    return null;
end;
$$;


ALTER FUNCTION public.notify_instructor_resource_updated() OWNER TO postgres;

--
-- Name: notify_request_event(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_request_event() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.req_id,0,new.start::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_request_event() OWNER TO postgres;

--
-- Name: notify_request_event_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_request_event_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.start::date
    where event_no=new.req_id and event_type=0;
    return null;
end;
$$;


ALTER FUNCTION public.notify_request_event_update() OWNER TO postgres;

--
-- Name: notify_student_resource_added(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_student_resource_added() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.res_id,6,current_timestamp::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_student_resource_added() OWNER TO postgres;

--
-- Name: notify_student_resource_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_student_resource_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=current_timestamp::date
    where event_no=new.res_id and event_type=6;
    return null;
end;
$$;


ALTER FUNCTION public.notify_student_resource_updated() OWNER TO postgres;

--
-- Name: notify_topic_added(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_topic_added() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='New Declaration';
    insert into notification_event(not_id, type_id, event_no, event_type, _date)
    values(default,type_no,new.topic_num,9,new.started::date);
    return null;
end;
$$;


ALTER FUNCTION public.notify_topic_added() OWNER TO postgres;

--
-- Name: notify_topic_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_topic_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    type_no integer;
begin
    select type_id into type_no from notification_type where type_name='Updated Declaration';
    update notification_event
    set type_id=type_no,notifucation_time=current_timestamp,_date=new.started::date
    where event_no=new.topic_num and event_type=9;
    return null;
end;
$$;


ALTER FUNCTION public.notify_topic_updated() OWNER TO postgres;

--
-- Name: overlapped_time(time without time zone, time without time zone, time without time zone, time without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.overlapped_time(first_begin time without time zone, first_end time without time zone, second_begin time without time zone, second_end time without time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.overlapped_time(first_begin time without time zone, first_end time without time zone, second_begin time without time zone, second_end time without time zone) OWNER TO postgres;

--
-- Name: overlapped_timestamp(timestamp with time zone, timestamp with time zone, timestamp with time zone, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.overlapped_timestamp(first_begin timestamp with time zone, first_end timestamp with time zone, second_begin timestamp with time zone, second_end timestamp with time zone) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.overlapped_timestamp(first_begin timestamp with time zone, first_end timestamp with time zone, second_begin timestamp with time zone, second_end timestamp with time zone) OWNER TO postgres;

--
-- Name: poster_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.poster_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.poster_check() OWNER TO postgres;

--
-- Name: remove_course_student(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_course_student(std_id integer, courseno integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.remove_course_student(std_id integer, courseno integer) OWNER TO postgres;

--
-- Name: remove_course_teacher(character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.remove_course_teacher(uname character varying, courseid integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
    tid integer;
    begin
        tid:=get_teacher_id(uname);
        delete from instructor
        where teacher_id=tid and course_id=courseID;
    end;
$$;


ALTER FUNCTION public.remove_course_teacher(uname character varying, courseid integer) OWNER TO postgres;

--
-- Name: request_event_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.request_event_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.request_event_check() OWNER TO postgres;

--
-- Name: section_to_course(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.section_to_course(sec_no integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    declare
        ans integer;
    begin
        select course_id into ans from section
            where section_no=sec_no;
        return ans;
    end
$$;


ALTER FUNCTION public.section_to_course(sec_no integer) OWNER TO postgres;

--
-- Name: submission_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.submission_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.submission_check() OWNER TO postgres;

--
-- Name: teacher_routine_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.teacher_routine_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.teacher_routine_check() OWNER TO postgres;

--
-- Name: term_name(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.term_name(term_num integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
    declare
        ans varchar(64);
    begin
        ans := 'January';
        if (term_num = 2) then
            ans := 'July';
        end if;
        return ans;
    end
$$;


ALTER FUNCTION public.term_name(term_num integer) OWNER TO postgres;

--
-- Name: update_cr(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_cr(std_id integer, sectionno integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
    std_no integer;
    begin
        std_no:=get_student_no(std_id);
        update section
        set cr_id=std_no
        where section_no=sectionNo;
    end;
$$;


ALTER FUNCTION public.update_cr(std_id integer, sectionno integer) OWNER TO postgres;

--
-- Name: update_evaluation_link(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_evaluation_link(eventid integer, filelink character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    declare
    begin
        update evaluation
        set link=fileLink
        where evaluation_id=eventID;
    end;
$$;


ALTER FUNCTION public.update_evaluation_link(eventid integer, filelink character varying) OWNER TO postgres;

--
-- Name: upload_evaluation(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.upload_evaluation(eventid integer, filelink character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    begin
        update evaluation
        set link=fileLink
        where evaluation_id=eventID;
    end;
$$;


ALTER FUNCTION public.upload_evaluation(eventid integer, filelink character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    admin_id integer NOT NULL,
    name character varying(32) NOT NULL,
    user_no integer NOT NULL
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- Name: admins_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admins_admin_id_seq OWNER TO postgres;

--
-- Name: admins_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_admin_id_seq OWNED BY public.admins.admin_id;


--
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    course_id integer NOT NULL,
    course_name character varying(255) NOT NULL,
    course_num integer NOT NULL,
    dept_code integer NOT NULL,
    offered_dept_code integer NOT NULL,
    batch integer NOT NULL,
    _year integer NOT NULL,
    level integer NOT NULL,
    term integer NOT NULL,
    CONSTRAINT course__year_check CHECK (((_year > 1900) AND ((_year)::double precision <= date_part('year'::text, CURRENT_DATE)))),
    CONSTRAINT course__year_check1 CHECK (((_year > 1900) AND ((_year)::double precision <= date_part('year'::text, CURRENT_DATE)))),
    CONSTRAINT course_course_num_check CHECK (((course_num >= 0) AND (course_num < 100))),
    CONSTRAINT course_level_check CHECK (((level > 0) AND (level < 6))),
    CONSTRAINT course_term_check CHECK (((term = 1) OR (term = 2)))
);


ALTER TABLE public.course OWNER TO postgres;

--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    dept_code integer NOT NULL,
    dept_name character varying(64) NOT NULL,
    dept_shortname character varying(8) NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: all_courses; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.all_courses AS
 SELECT c.course_id AS _id,
    public.term_name(c.term) AS _term,
    c._year AS __year,
    d.dept_shortname AS _dept_shortname,
    ((c.level * 100) + c.course_num) AS _course_code,
    c.course_name AS _course_name
   FROM (public.course c
     JOIN public.department d ON ((c.dept_code = d.dept_code)))
  WITH NO DATA;


ALTER TABLE public.all_courses OWNER TO postgres;

--
-- Name: canceled_class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.canceled_class (
    canceled_class_id integer NOT NULL,
    class_id integer NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.canceled_class OWNER TO postgres;

--
-- Name: canceled_class_canceled_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.canceled_class_canceled_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.canceled_class_canceled_class_id_seq OWNER TO postgres;

--
-- Name: canceled_class_canceled_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.canceled_class_canceled_class_id_seq OWNED BY public.canceled_class.canceled_class_id;


--
-- Name: course_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_course_id_seq OWNER TO postgres;

--
-- Name: course_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_course_id_seq OWNED BY public.course.course_id;


--
-- Name: course_post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_post (
    post_id integer NOT NULL,
    parent_post integer,
    poster_id integer NOT NULL,
    student_post boolean DEFAULT false NOT NULL,
    post_name character varying(255) NOT NULL,
    post_content character varying(8192) NOT NULL,
    post_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.course_post OWNER TO postgres;

--
-- Name: course_post_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_post_file (
    file_id integer NOT NULL,
    post_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_link character varying(1024) NOT NULL
);


ALTER TABLE public.course_post_file OWNER TO postgres;

--
-- Name: course_post_file_file_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_post_file_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_post_file_file_id_seq OWNER TO postgres;

--
-- Name: course_post_file_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_post_file_file_id_seq OWNED BY public.course_post_file.file_id;


--
-- Name: course_post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_post_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_post_post_id_seq OWNER TO postgres;

--
-- Name: course_post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_post_post_id_seq OWNED BY public.course_post.post_id;


--
-- Name: course_routine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_routine (
    class_id integer NOT NULL,
    section_no integer NOT NULL,
    alternation integer,
    start time without time zone NOT NULL,
    _end time without time zone NOT NULL,
    day integer NOT NULL,
    CONSTRAINT course_routine_alternation_check CHECK ((alternation > 0)),
    CONSTRAINT course_routine_check CHECK ((_end > start)),
    CONSTRAINT course_routine_day_check CHECK (((day >= 0) AND (day < 7)))
);


ALTER TABLE public.course_routine OWNER TO postgres;

--
-- Name: course_routine_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_routine_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.course_routine_class_id_seq OWNER TO postgres;

--
-- Name: course_routine_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_routine_class_id_seq OWNED BY public.course_routine.class_id;


--
-- Name: current_courses; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.current_courses AS
 SELECT c.course_id AS _id,
    public.term_name(c.term) AS _term,
    c._year AS __year,
    d.dept_shortname AS _dept_shortname,
    ((c.level * 100) + c.course_num) AS _course_code,
    c.course_name AS _course_name
   FROM (public.course c
     JOIN public.department d ON ((c.dept_code = d.dept_code)))
  WHERE (NOT (EXISTS ( SELECT cc.course_id
           FROM public.course cc
          WHERE ((cc._year > c._year) OR ((cc._year = c._year) AND (cc.term > c.term))))))
  WITH NO DATA;


ALTER TABLE public.current_courses OWNER TO postgres;

--
-- Name: enrolment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrolment (
    enrol_id integer NOT NULL,
    student_id integer NOT NULL,
    section_id integer NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT enrolment__date_check CHECK ((_date <= CURRENT_DATE))
);


ALTER TABLE public.enrolment OWNER TO postgres;

--
-- Name: enrolment_enrol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enrolment_enrol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.enrolment_enrol_id_seq OWNER TO postgres;

--
-- Name: enrolment_enrol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enrolment_enrol_id_seq OWNED BY public.enrolment.enrol_id;


--
-- Name: evaluation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluation (
    evaluation_id integer NOT NULL,
    type_id integer NOT NULL,
    section_no integer NOT NULL,
    instructor_id integer NOT NULL,
    caption_extension character varying(32) DEFAULT NULL::character varying,
    start timestamp with time zone NOT NULL,
    _end timestamp with time zone NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    total_marks double precision NOT NULL,
    description character varying(2048),
    link character varying(1024) DEFAULT NULL::character varying,
    CONSTRAINT evaluation_check CHECK ((_end > start)),
    CONSTRAINT evaluation_total_marks_check CHECK ((total_marks > (0)::double precision))
);


ALTER TABLE public.evaluation OWNER TO postgres;

--
-- Name: evaluation_evaluation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluation_evaluation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluation_evaluation_id_seq OWNER TO postgres;

--
-- Name: evaluation_evaluation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluation_evaluation_id_seq OWNED BY public.evaluation.evaluation_id;


--
-- Name: evaluation_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.evaluation_type (
    type_id integer NOT NULL,
    type_name character varying(64) NOT NULL,
    notification_time_type boolean DEFAULT true NOT NULL
);


ALTER TABLE public.evaluation_type OWNER TO postgres;

--
-- Name: evaluation_type_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluation_type_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluation_type_type_id_seq OWNER TO postgres;

--
-- Name: evaluation_type_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluation_type_type_id_seq OWNED BY public.evaluation_type.type_id;


--
-- Name: extra_class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_class (
    extra_class_id integer NOT NULL,
    section_no integer NOT NULL,
    instructor_id integer NOT NULL,
    start timestamp with time zone NOT NULL,
    _end timestamp with time zone NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT extra_class_check CHECK ((_end > start)),
    CONSTRAINT extra_class_start_check CHECK ((start >= CURRENT_TIMESTAMP))
);


ALTER TABLE public.extra_class OWNER TO postgres;

--
-- Name: extra_class_extra_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.extra_class_extra_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extra_class_extra_class_id_seq OWNER TO postgres;

--
-- Name: extra_class_extra_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.extra_class_extra_class_id_seq OWNED BY public.extra_class.extra_class_id;


--
-- Name: extra_class_teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_class_teacher (
    assignment_id integer NOT NULL,
    extra_class_id integer NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.extra_class_teacher OWNER TO postgres;

--
-- Name: extra_class_teacher_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.extra_class_teacher_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extra_class_teacher_assignment_id_seq OWNER TO postgres;

--
-- Name: extra_class_teacher_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.extra_class_teacher_assignment_id_seq OWNED BY public.extra_class_teacher.assignment_id;


--
-- Name: extra_evaluation_instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_evaluation_instructor (
    assignment_id integer NOT NULL,
    evaluation_id integer NOT NULL,
    instructor_id integer NOT NULL
);


ALTER TABLE public.extra_evaluation_instructor OWNER TO postgres;

--
-- Name: extra_evaluation_instructor_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.extra_evaluation_instructor_assignment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.extra_evaluation_instructor_assignment_id_seq OWNER TO postgres;

--
-- Name: extra_evaluation_instructor_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.extra_evaluation_instructor_assignment_id_seq OWNED BY public.extra_evaluation_instructor.assignment_id;


--
-- Name: forum_post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forum_post (
    post_id integer NOT NULL,
    parent_post integer,
    poster integer NOT NULL,
    post_name character varying(255) NOT NULL,
    post_content character varying(8192) NOT NULL,
    post_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.forum_post OWNER TO postgres;

--
-- Name: forum_post_files; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forum_post_files (
    file_id integer NOT NULL,
    post_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_link character varying(1024) NOT NULL
);


ALTER TABLE public.forum_post_files OWNER TO postgres;

--
-- Name: forum_post_files_file_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.forum_post_files_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forum_post_files_file_id_seq OWNER TO postgres;

--
-- Name: forum_post_files_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.forum_post_files_file_id_seq OWNED BY public.forum_post_files.file_id;


--
-- Name: forum_post_post_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.forum_post_post_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.forum_post_post_id_seq OWNER TO postgres;

--
-- Name: forum_post_post_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.forum_post_post_id_seq OWNED BY public.forum_post.post_id;


--
-- Name: grading; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grading (
    grading_id integer NOT NULL,
    sub_id integer NOT NULL,
    instructor_id integer NOT NULL,
    total_marks double precision NOT NULL,
    obtained_marks double precision NOT NULL,
    remarks character varying(2048),
    _date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT grading__date_check CHECK ((_date <= CURRENT_DATE)),
    CONSTRAINT grading_check CHECK ((obtained_marks <= total_marks)),
    CONSTRAINT grading_total_marks_check CHECK ((total_marks > (0)::double precision))
);


ALTER TABLE public.grading OWNER TO postgres;

--
-- Name: grading_grading_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grading_grading_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.grading_grading_id_seq OWNER TO postgres;

--
-- Name: grading_grading_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grading_grading_id_seq OWNED BY public.grading.grading_id;


--
-- Name: ins_id; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ins_id (
    instructor_id integer
);


ALTER TABLE public.ins_id OWNER TO postgres;

--
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    instructor_id integer NOT NULL,
    teacher_id integer NOT NULL,
    course_id integer NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    CONSTRAINT instructor__date_check CHECK ((_date <= CURRENT_DATE))
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_instructor_id_seq OWNER TO postgres;

--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_instructor_id_seq OWNED BY public.instructor.instructor_id;


--
-- Name: resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resource (
    res_id integer NOT NULL,
    res_name character varying(255) NOT NULL,
    res_link character varying(1024) NOT NULL,
    owner_id integer NOT NULL
);


ALTER TABLE public.resource OWNER TO postgres;

--
-- Name: instructor_resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_resource (
)
INHERITS (public.resource);


ALTER TABLE public.instructor_resource OWNER TO postgres;

--
-- Name: section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.section (
    section_no integer NOT NULL,
    section_name character varying(64) NOT NULL,
    course_id integer NOT NULL,
    cr_id integer
);


ALTER TABLE public.section OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    student_id integer NOT NULL,
    student_name character varying(255) NOT NULL,
    password character(60) NOT NULL,
    _year integer NOT NULL,
    roll_num integer NOT NULL,
    dept_code integer NOT NULL,
    notification_last_seen timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email_address character varying(128),
    CONSTRAINT student__year_check CHECK (((_year > 1900) AND ((_year)::double precision <= date_part('year'::text, CURRENT_DATE)))),
    CONSTRAINT student_email_address_check CHECK ((((email_address)::text ~~ '_%@%_._%'::text) AND ((email_address)::text !~~ '%@%@%'::text) AND ((email_address)::text !~~ '% %'::text))),
    CONSTRAINT student_password_check CHECK (((password ~ similar_to_escape('[a-zA-Z0-9+./$]%'::text)) AND (password ~ similar_to_escape('%[a-zA-Z0-9+./$]'::text)) AND (password ~ similar_to_escape('%[a-zA-Z0-9+./$]%'::text)))),
    CONSTRAINT student_roll_num_check CHECK ((roll_num > 0))
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: intersected_sections; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.intersected_sections AS
 SELECT e.section_id AS first_section,
    f.section_id AS second_section,
    count(*) AS common_students
   FROM (( SELECT e_1.section_id,
            e_1.student_id
           FROM (((public.section s
             JOIN public.enrolment e_1 ON ((s.section_no = e_1.section_id)))
             JOIN public.course c ON ((c.course_id = s.course_id)))
             JOIN public.student s2 ON ((e_1.student_id = s2.student_id)))
          WHERE (s2._year = c.batch)) e
     JOIN ( SELECT e_1.section_id,
            e_1.student_id
           FROM (((public.section s
             JOIN public.enrolment e_1 ON ((s.section_no = e_1.section_id)))
             JOIN public.course c ON ((c.course_id = s.course_id)))
             JOIN public.student s2 ON ((e_1.student_id = s2.student_id)))
          WHERE (s2._year = c.batch)) f ON ((e.student_id = f.student_id)))
  WHERE (e.section_id <> f.section_id)
  GROUP BY e.section_id, f.section_id
  WITH NO DATA;


ALTER TABLE public.intersected_sections OWNER TO postgres;

--
-- Name: notification_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_event (
    not_id integer NOT NULL,
    type_id integer NOT NULL,
    event_no integer NOT NULL,
    event_type integer NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    notifucation_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.notification_event OWNER TO postgres;

--
-- Name: notification_event_not_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_event_not_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_event_not_id_seq OWNER TO postgres;

--
-- Name: notification_event_not_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_event_not_id_seq OWNED BY public.notification_event.not_id;


--
-- Name: notification_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_type (
    type_id integer NOT NULL,
    type_name character varying(64) NOT NULL,
    visibility integer NOT NULL
);


ALTER TABLE public.notification_type OWNER TO postgres;

--
-- Name: notification_type_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_type_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_type_type_id_seq OWNER TO postgres;

--
-- Name: notification_type_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_type_type_id_seq OWNED BY public.notification_type.type_id;


--
-- Name: official_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.official_users (
    user_no integer NOT NULL,
    username character varying(32) NOT NULL,
    password character(60) NOT NULL,
    email_address character varying(128),
    CONSTRAINT official_users_email_address_check CHECK ((((email_address)::text ~~ '_%@%_._%'::text) AND ((email_address)::text !~~ '%@%@%'::text) AND ((email_address)::text !~~ '% %'::text))),
    CONSTRAINT official_users_password_check CHECK (((password ~ similar_to_escape('[a-zA-Z0-9+./$]%'::text)) AND (password ~ similar_to_escape('%[a-zA-Z0-9+./$]'::text)) AND (password ~ similar_to_escape('%[a-zA-Z0-9+./$]%'::text)))),
    CONSTRAINT official_users_username_check CHECK ((((username)::text ~ similar_to_escape('[a-zA-Z]%'::text)) AND ((username)::text ~ similar_to_escape('%[a-zA-Z0-9]'::text)) AND ((username)::text ~ similar_to_escape('%[a-zA-Z0-9]%'::text))))
);


ALTER TABLE public.official_users OWNER TO postgres;

--
-- Name: official_users_user_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.official_users_user_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.official_users_user_no_seq OWNER TO postgres;

--
-- Name: official_users_user_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.official_users_user_no_seq OWNED BY public.official_users.user_no;


--
-- Name: private_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.private_file (
    file_id integer NOT NULL,
    owner_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    file_link character varying(1024) NOT NULL
);


ALTER TABLE public.private_file OWNER TO postgres;

--
-- Name: private_file_file_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.private_file_file_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.private_file_file_id_seq OWNER TO postgres;

--
-- Name: private_file_file_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.private_file_file_id_seq OWNED BY public.private_file.file_id;


--
-- Name: request_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.request_event (
    req_id integer NOT NULL,
    type_id integer NOT NULL,
    section_no integer NOT NULL,
    instructor_id integer NOT NULL,
    start timestamp with time zone NOT NULL,
    _end timestamp with time zone NOT NULL,
    _date date DEFAULT CURRENT_DATE NOT NULL,
    notifucation_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    total_marks double precision NOT NULL,
    CONSTRAINT request_event_check CHECK ((_end > start)),
    CONSTRAINT request_event_start_check CHECK ((start >= CURRENT_TIMESTAMP)),
    CONSTRAINT request_event_total_marks_check CHECK ((total_marks > (0)::double precision))
);


ALTER TABLE public.request_event OWNER TO postgres;

--
-- Name: request_event_req_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.request_event_req_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.request_event_req_id_seq OWNER TO postgres;

--
-- Name: request_event_req_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.request_event_req_id_seq OWNED BY public.request_event.req_id;


--
-- Name: request_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.request_type (
    type_id integer NOT NULL,
    type_name character varying(64) NOT NULL
);


ALTER TABLE public.request_type OWNER TO postgres;

--
-- Name: request_type_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.request_type_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.request_type_type_id_seq OWNER TO postgres;

--
-- Name: request_type_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.request_type_type_id_seq OWNED BY public.request_type.type_id;


--
-- Name: resource_res_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.resource_res_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resource_res_id_seq OWNER TO postgres;

--
-- Name: resource_res_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.resource_res_id_seq OWNED BY public.resource.res_id;


--
-- Name: section_section_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.section_section_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.section_section_no_seq OWNER TO postgres;

--
-- Name: section_section_no_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.section_section_no_seq OWNED BY public.section.section_no;


--
-- Name: student_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_file (
)
INHERITS (public.private_file);


ALTER TABLE public.student_file OWNER TO postgres;

--
-- Name: student_resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_resource (
)
INHERITS (public.resource);


ALTER TABLE public.student_resource OWNER TO postgres;

--
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_student_id_seq OWNER TO postgres;

--
-- Name: student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_student_id_seq OWNED BY public.student.student_id;


--
-- Name: submission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.submission (
    sub_id integer NOT NULL,
    event_id integer NOT NULL,
    enrol_id integer NOT NULL,
    link character varying(1024) DEFAULT NULL::character varying,
    sub_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.submission OWNER TO postgres;

--
-- Name: submission_sub_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.submission_sub_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.submission_sub_id_seq OWNER TO postgres;

--
-- Name: submission_sub_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.submission_sub_id_seq OWNED BY public.submission.sub_id;


--
-- Name: teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher (
    teacher_id integer NOT NULL,
    teacher_name character varying(255) NOT NULL,
    user_no integer NOT NULL,
    dept_code integer NOT NULL,
    notification_last_seen timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.teacher OWNER TO postgres;

--
-- Name: teacher_file; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_file (
)
INHERITS (public.private_file);


ALTER TABLE public.teacher_file OWNER TO postgres;

--
-- Name: teacher_routine; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_routine (
    teacher_class_id integer NOT NULL,
    instructor_id integer NOT NULL,
    class_id integer NOT NULL
);


ALTER TABLE public.teacher_routine OWNER TO postgres;

--
-- Name: teacher_routine_teacher_class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_routine_teacher_class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teacher_routine_teacher_class_id_seq OWNER TO postgres;

--
-- Name: teacher_routine_teacher_class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_routine_teacher_class_id_seq OWNED BY public.teacher_routine.teacher_class_id;


--
-- Name: teacher_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.teacher_teacher_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teacher_teacher_id_seq OWNER TO postgres;

--
-- Name: teacher_teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.teacher_teacher_id_seq OWNED BY public.teacher.teacher_id;


--
-- Name: topic; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.topic (
    topic_num integer NOT NULL,
    topic_name character varying(255) NOT NULL,
    instructor_id integer NOT NULL,
    finished boolean DEFAULT false NOT NULL,
    description character varying(2048),
    started timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.topic OWNER TO postgres;

--
-- Name: topic_topic_num_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.topic_topic_num_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.topic_topic_num_seq OWNER TO postgres;

--
-- Name: topic_topic_num_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.topic_topic_num_seq OWNED BY public.topic.topic_num;


--
-- Name: visibility; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visibility (
    type_id integer NOT NULL,
    type_name character varying(64) NOT NULL
);


ALTER TABLE public.visibility OWNER TO postgres;

--
-- Name: visibility_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visibility_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.visibility_type_id_seq OWNER TO postgres;

--
-- Name: visibility_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visibility_type_id_seq OWNED BY public.visibility.type_id;


--
-- Name: admins admin_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN admin_id SET DEFAULT nextval('public.admins_admin_id_seq'::regclass);


--
-- Name: canceled_class canceled_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canceled_class ALTER COLUMN canceled_class_id SET DEFAULT nextval('public.canceled_class_canceled_class_id_seq'::regclass);


--
-- Name: course course_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course ALTER COLUMN course_id SET DEFAULT nextval('public.course_course_id_seq'::regclass);


--
-- Name: course_post post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post ALTER COLUMN post_id SET DEFAULT nextval('public.course_post_post_id_seq'::regclass);


--
-- Name: course_post_file file_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post_file ALTER COLUMN file_id SET DEFAULT nextval('public.course_post_file_file_id_seq'::regclass);


--
-- Name: course_routine class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_routine ALTER COLUMN class_id SET DEFAULT nextval('public.course_routine_class_id_seq'::regclass);


--
-- Name: enrolment enrol_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrolment ALTER COLUMN enrol_id SET DEFAULT nextval('public.enrolment_enrol_id_seq'::regclass);


--
-- Name: evaluation evaluation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation ALTER COLUMN evaluation_id SET DEFAULT nextval('public.evaluation_evaluation_id_seq'::regclass);


--
-- Name: evaluation_type type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_type ALTER COLUMN type_id SET DEFAULT nextval('public.evaluation_type_type_id_seq'::regclass);


--
-- Name: extra_class extra_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class ALTER COLUMN extra_class_id SET DEFAULT nextval('public.extra_class_extra_class_id_seq'::regclass);


--
-- Name: extra_class_teacher assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class_teacher ALTER COLUMN assignment_id SET DEFAULT nextval('public.extra_class_teacher_assignment_id_seq'::regclass);


--
-- Name: extra_evaluation_instructor assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_evaluation_instructor ALTER COLUMN assignment_id SET DEFAULT nextval('public.extra_evaluation_instructor_assignment_id_seq'::regclass);


--
-- Name: forum_post post_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post ALTER COLUMN post_id SET DEFAULT nextval('public.forum_post_post_id_seq'::regclass);


--
-- Name: forum_post_files file_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post_files ALTER COLUMN file_id SET DEFAULT nextval('public.forum_post_files_file_id_seq'::regclass);


--
-- Name: grading grading_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading ALTER COLUMN grading_id SET DEFAULT nextval('public.grading_grading_id_seq'::regclass);


--
-- Name: instructor instructor_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN instructor_id SET DEFAULT nextval('public.instructor_instructor_id_seq'::regclass);


--
-- Name: instructor_resource res_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_resource ALTER COLUMN res_id SET DEFAULT nextval('public.resource_res_id_seq'::regclass);


--
-- Name: notification_event not_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_event ALTER COLUMN not_id SET DEFAULT nextval('public.notification_event_not_id_seq'::regclass);


--
-- Name: notification_type type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type ALTER COLUMN type_id SET DEFAULT nextval('public.notification_type_type_id_seq'::regclass);


--
-- Name: official_users user_no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.official_users ALTER COLUMN user_no SET DEFAULT nextval('public.official_users_user_no_seq'::regclass);


--
-- Name: private_file file_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.private_file ALTER COLUMN file_id SET DEFAULT nextval('public.private_file_file_id_seq'::regclass);


--
-- Name: request_event req_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_event ALTER COLUMN req_id SET DEFAULT nextval('public.request_event_req_id_seq'::regclass);


--
-- Name: request_type type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_type ALTER COLUMN type_id SET DEFAULT nextval('public.request_type_type_id_seq'::regclass);


--
-- Name: resource res_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resource ALTER COLUMN res_id SET DEFAULT nextval('public.resource_res_id_seq'::regclass);


--
-- Name: section section_no; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section ALTER COLUMN section_no SET DEFAULT nextval('public.section_section_no_seq'::regclass);


--
-- Name: student student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN student_id SET DEFAULT nextval('public.student_student_id_seq'::regclass);


--
-- Name: student_file file_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_file ALTER COLUMN file_id SET DEFAULT nextval('public.private_file_file_id_seq'::regclass);


--
-- Name: student_resource res_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_resource ALTER COLUMN res_id SET DEFAULT nextval('public.resource_res_id_seq'::regclass);


--
-- Name: submission sub_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission ALTER COLUMN sub_id SET DEFAULT nextval('public.submission_sub_id_seq'::regclass);


--
-- Name: teacher teacher_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher ALTER COLUMN teacher_id SET DEFAULT nextval('public.teacher_teacher_id_seq'::regclass);


--
-- Name: teacher_file file_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_file ALTER COLUMN file_id SET DEFAULT nextval('public.private_file_file_id_seq'::regclass);


--
-- Name: teacher_routine teacher_class_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_routine ALTER COLUMN teacher_class_id SET DEFAULT nextval('public.teacher_routine_teacher_class_id_seq'::regclass);


--
-- Name: topic topic_num; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topic ALTER COLUMN topic_num SET DEFAULT nextval('public.topic_topic_num_seq'::regclass);


--
-- Name: visibility type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visibility ALTER COLUMN type_id SET DEFAULT nextval('public.visibility_type_id_seq'::regclass);


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.admins (admin_id, name, user_no) VALUES (1, 'Nazmul Haque', 1);


--
-- Data for Name: canceled_class; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (1, 'Fault Tolerant Systems', 23, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (2, 'High Performance Database System', 53, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (3, 'Engineering Economics', 75, 7, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (4, 'Computer Security', 5, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (5, 'Computer Graphics', 9, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (6, 'Computer Graphics Sessional', 10, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (7, 'Computer Security Sessional', 6, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (8, 'Basic Graph Theory', 21, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (9, 'Introduction to Bioinformatics', 63, 5, 5, 2017, 2022, 4, 1);
INSERT INTO public.course (course_id, course_name, course_num, dept_code, offered_dept_code, batch, _year, level, term) VALUES (10, 'Software Development Sessional', 8, 5, 5, 2017, 2022, 4, 1);


--
-- Data for Name: course_post; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course_post (post_id, parent_post, poster_id, student_post, post_name, post_content, post_time) VALUES (2, NULL, 1, false, 'Class Test Marks', 'Here is class test marks', '2022-08-26 11:33:47.547081+06');
INSERT INTO public.course_post (post_id, parent_post, poster_id, student_post, post_name, post_content, post_time) VALUES (3, 2, 1, true, 'Marks Not Found', 'Sir, I attended the test but the document shows me absent', '2022-08-26 11:38:59.623663+06');
INSERT INTO public.course_post (post_id, parent_post, poster_id, student_post, post_name, post_content, post_time) VALUES (4, 3, 1, false, 'Correction', 'Your marks has been added', '2022-08-26 11:40:25.914105+06');


--
-- Data for Name: course_post_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: course_routine; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (1, 1, 7, '08:00:00', '10:00:00', 0);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (2, 1, 7, '10:00:00', '11:00:00', 6);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (3, 2, 7, '09:00:00', '10:00:00', 5);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (4, 2, 7, '11:00:00', '12:00:00', 6);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (5, 2, 7, '11:00:00', '12:00:00', 0);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (6, 9, 7, '12:00:00', '13:00:00', 5);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (7, 9, 7, '12:00:00', '13:00:00', 6);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (8, 9, 7, '12:00:00', '13:00:00', 0);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (9, 3, 7, '10:00:00', '11:00:00', 5);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (10, 3, 7, '08:00:00', '09:00:00', 6);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (11, 3, 7, '09:00:00', '10:00:00', 2);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (12, 4, 7, '09:00:00', '10:00:00', 6);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (13, 4, 7, '09:00:00', '10:00:00', 1);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (14, 4, 7, '08:00:00', '09:00:00', 2);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (15, 5, 7, '11:00:00', '12:00:00', 5);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (16, 5, 7, '08:00:00', '09:00:00', 1);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (17, 5, 7, '10:00:00', '11:00:00', 2);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (18, 8, 7, '10:00:00', '11:00:00', 0);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (19, 8, 7, '10:00:00', '11:00:00', 1);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (20, 8, 7, '11:00:00', '12:00:00', 2);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (21, 6, 14, '14:00:00', '17:00:00', 5);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (22, 7, 14, '14:00:00', '17:00:00', 6);
INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (23, 10, 7, '14:00:00', '17:00:00', 0);


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (1, 'Architecture', 'Arch');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (2, 'Chemical Engineering', 'ChE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (4, 'Civil Engineering', 'CE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (5, 'Computer Science and Engineering', 'CSE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (6, 'Electrical and Electronic Engineering', 'EEE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (7, 'Humanities', 'HUM');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (8, 'Industrial and Production Engineering', 'IPE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (10, 'Mechanical Engineering', 'ME');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (11, 'Materials and Metallurgical Engineering', 'MME');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (15, 'Urban and Regional Planning', 'URP');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (18, 'Biomedical Engineering', 'BME');


--
-- Data for Name: enrolment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (1, 1, 1, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (2, 1, 2, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (3, 1, 3, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (4, 1, 4, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (5, 1, 5, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (6, 1, 6, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (7, 1, 7, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (8, 5, 1, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (9, 5, 2, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (10, 5, 3, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (11, 5, 4, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (12, 5, 5, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (13, 5, 6, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (14, 5, 7, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (15, 2, 2, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (16, 2, 9, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (17, 2, 3, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (18, 2, 4, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (19, 2, 5, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (20, 2, 6, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (21, 2, 7, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (22, 6, 1, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (23, 6, 2, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (24, 6, 3, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (25, 6, 4, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (26, 6, 5, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (27, 6, 6, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (28, 6, 7, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (29, 3, 1, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (30, 3, 8, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (31, 3, 3, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (32, 3, 4, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (33, 3, 5, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (34, 3, 6, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (35, 3, 7, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (36, 4, 1, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (37, 4, 9, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (38, 4, 3, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (39, 4, 4, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (40, 4, 5, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (41, 4, 6, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (42, 4, 7, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (43, 1, 10, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (44, 2, 10, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (45, 3, 10, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (46, 4, 10, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (47, 5, 10, '2022-08-25');
INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (48, 6, 10, '2022-08-25');


--
-- Data for Name: evaluation; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (1, 1, 4, 9, NULL, '2022-08-20 14:00:00+06', '2022-08-20 14:40:00+06', '2022-08-25', 20, NULL, NULL);
INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (3, 5, 6, 8, NULL, '2022-08-25 16:42:31.213611+06', '2022-08-27 20:20:00+06', '2022-08-25', 100, NULL, NULL);
INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (4, 1, 2, 2, NULL, '2022-08-22 17:00:00+06', '2022-08-22 17:40:00+06', '2022-08-25', 20, NULL, NULL);
INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (5, 2, 6, 8, NULL, '2022-08-27 21:00:00+06', '2022-08-27 22:00:00+06', '2022-08-25', 50, NULL, NULL);
INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (6, 4, 7, 12, NULL, '2022-08-28 20:40:00+06', '2022-08-28 21:40:00+06', '2022-08-25', 20, NULL, NULL);
INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (8, 5, 1, 1, NULL, '2022-08-25 16:42:50.59004+06', '2022-08-27 17:30:00+06', '2022-08-25', 20, 'This is a bonus assignment', NULL);
INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (9, 5, 5, 6, NULL, '2022-08-27 19:00:18.176651+06', '2022-08-29 11:30:00+06', '2022-08-27', 20, NULL, NULL);
INSERT INTO public.evaluation (evaluation_id, type_id, section_no, instructor_id, caption_extension, start, _end, _date, total_marks, description, link) VALUES (10, 5, 2, 2, NULL, '2022-08-30 14:00:00+06', '2022-08-30 15:00:00+06', '2022-08-27', 50, NULL, NULL);


--
-- Data for Name: evaluation_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.evaluation_type (type_id, type_name, notification_time_type) VALUES (1, 'Class Test', false);
INSERT INTO public.evaluation_type (type_id, type_name, notification_time_type) VALUES (2, 'Lab Quiz', false);
INSERT INTO public.evaluation_type (type_id, type_name, notification_time_type) VALUES (3, 'Lab Test', false);
INSERT INTO public.evaluation_type (type_id, type_name, notification_time_type) VALUES (4, 'Online Evaluation', false);
INSERT INTO public.evaluation_type (type_id, type_name, notification_time_type) VALUES (5, 'Assignment', true);


--
-- Data for Name: extra_class; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: extra_class_teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: extra_evaluation_instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: forum_post; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.forum_post (post_id, parent_post, poster, post_name, post_content, post_time) VALUES (1, NULL, 2, 'Seminar on 5G Networks', 'Details is given here', '2022-08-26 11:52:23.045686+06');


--
-- Data for Name: forum_post_files; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: grading; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: ins_id; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ins_id (instructor_id) VALUES (12);


--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (1, 1, 1, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (2, 2, 2, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (3, 10, 3, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (4, 11, 3, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (5, 6, 5, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (6, 7, 5, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (7, 6, 6, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (8, 7, 6, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (9, 8, 4, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (10, 9, 4, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (11, 8, 7, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (12, 9, 7, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (13, 4, 9, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (14, 5, 9, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (15, 3, 8, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (16, 12, 10, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (17, 13, 10, '2022-08-25');
INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (18, 14, 10, '2022-08-25');


--
-- Data for Name: instructor_resource; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: notification_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (1, 1, 1, 9, '2022-08-25', '2022-08-25 16:41:43.379564+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (2, 1, 1, 2, '2022-08-20', '2022-08-25 16:41:43.399829+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (3, 1, 3, 2, '2022-08-25', '2022-08-25 16:42:31.213611+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (4, 1, 4, 2, '2022-08-22', '2022-08-25 16:42:31.224824+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (5, 1, 5, 2, '2022-08-27', '2022-08-25 16:42:31.247752+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (6, 1, 6, 2, '2022-08-28', '2022-08-25 16:42:37.375425+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (7, 1, 8, 2, '2022-08-25', '2022-08-25 16:42:50.59004+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (9, 1, 2, 4, '2022-08-26', '2022-08-26 11:33:47.547081+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (10, 1, 3, 4, '2022-08-26', '2022-08-26 11:38:59.623663+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (11, 1, 4, 4, '2022-08-26', '2022-08-26 11:40:25.914105+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (12, 1, 1, 8, '2022-08-26', '2022-08-26 11:52:23.045686+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (13, 1, 9, 2, '2022-08-27', '2022-08-27 19:00:18.176651+06');
INSERT INTO public.notification_event (not_id, type_id, event_no, event_type, _date, notifucation_time) VALUES (14, 1, 10, 2, '2022-08-30', '2022-08-27 22:40:33.499206+06');


--
-- Data for Name: notification_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.notification_type (type_id, type_name, visibility) VALUES (1, 'New Declaration', 2);
INSERT INTO public.notification_type (type_id, type_name, visibility) VALUES (2, 'Updated Declaration', 2);
INSERT INTO public.notification_type (type_id, type_name, visibility) VALUES (3, 'New Schedule Request', 4);
INSERT INTO public.notification_type (type_id, type_name, visibility) VALUES (4, 'Updated Schedule Request', 4);
INSERT INTO public.notification_type (type_id, type_name, visibility) VALUES (5, 'New Reschedule Request', 3);
INSERT INTO public.notification_type (type_id, type_name, visibility) VALUES (6, 'Updated Reschedule Request', 3);


--
-- Data for Name: official_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (1, 'nazmuladmin', '$2a$12$a3sA/qgphlpSnjZl2EkaW.EvlHrTbsrX8ZjD1iqJzqZgYLdkPXmAy', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (2, 'alimrazi', '$2a$12$vJa9O6JwQkfILdYj5bSsCuVbeSC863/MIe7x1UZM0qU7iPcwfewB2', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (3, 'aadnan', '$2y$10$L6jbTLAvrMo385LUib9Kuuq/1WICpx8DeedZxIksHLpgFofFghvN6', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (4, 'saidur', '$2y$10$ZkKqecSnPUJgjSUXXcOSx..O6qtR0pLz0oCg/meyB4p095aZIW046', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (5, 'saifur', '$2y$10$sq9aDXP6AjBqLScZXDNLLeXlBO/ZFwdACr/dKkkNr8nkaQt7WersW', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (6, 'bayzid', '$2y$10$rjCuLnyfxwa.G0T25nYAEOaT9PtycCHCQkbHfyB2.CKYT.weLhOKi', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (7, 'nitripto', '$2y$10$dF1UOgEjzsJp5OrEOA2iX.HYfNkymt6u4iRrGB3djf3UCB86Yokzm', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (8, 'ssaquib', '$2y$10$ad4lVnOcqGx8KErwAC8rAOmEp1k1lscWbN8GK2EJyrJ3/wRFYjye.', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (9, 'shohrab', '$2y$10$SVVpQ96Dt5INs5hYsKGV9.eubbFqVcZfYacJUkKfYOmZHhjo.K/D6', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (10, 'mukit', '$2y$10$gOihrq.ujsthj3e/F2zYHeLOvWQ9ttsGXPF7y6cWKeDcV.YZqEcn2', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (11, 'munshi', '$2y$10$xDzSGa1czBolnsKuxRR03uh351f3IXVwiolW6MFWHLcIb3Mc.bxT2', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (12, 'rony', '$2y$10$mmpvLgBk3iH/sVzzraCFSud8K13vxxhcKTs6bbUlryqUFsIyoTK5O', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (13, 'rayhan', '$2y$10$/lW3WMDdlJjlaE/0OKDQuO/2pVDuyPzbokm661Jnt/1n6gmLdw1dm', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (14, 'htahmid', '$2y$10$tkSap6H/ofZrQotGQXNJ9uFvLjms/UoYgTEyIvDkhERxUudQieY/u', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (15, 'thbhuiyan', '$2y$10$8SPbFCvBQC9j8gsuQ.GKxOGfyNW/.Pchhs87L6k8PUu9oS0NZa/Li', NULL);


--
-- Data for Name: private_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: request_event; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: request_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.request_type (type_id, type_name) VALUES (1, 'Extra Class');
INSERT INTO public.request_type (type_id, type_name) VALUES (2, 'Class Test');


--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: section; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (1, 'CSE-2017-B2-CSE423-2022', 1, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (2, 'CSE-2017-B2-CSE453-2022', 2, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (3, 'CSE-2017-B2-HUM475-2022', 3, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (4, 'CSE-2017-B2-CSE405-2022', 4, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (5, 'CSE-2017-B2-CSE409-2022', 5, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (6, 'CSE-2017-B2-CSE410-2022', 6, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (7, 'CSE-2017-B2-CSE406-2022', 7, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (8, 'CSE-2017-B2-CSE421-2022', 8, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (9, 'CSE-2017-B2-CSE463-2022', 9, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (10, 'CSE-2017-B2-CSE408-2022', 10, NULL);
INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (11, 'CSE-2017-A2-CSE405-2022', 4, NULL);


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student (student_id, student_name, password, _year, roll_num, dept_code, notification_last_seen, email_address) VALUES (1, 'Md. Shariful', '$2a$12$BjvAnEmgjQsjLxPmFsD8Peh7H0DV49ZiXZisriA/IZ92ySlPJc1p.', 2017, 119, 5, '2022-08-25 16:41:37.939952+06', NULL);
INSERT INTO public.student (student_id, student_name, password, _year, roll_num, dept_code, notification_last_seen, email_address) VALUES (2, 'Fatima Nawmi', '$2y$10$/q5rPYxPDEDi14Hp33AgfOjhuF8mglmjqBnyN58zN17L4hJ4Oclpu', 2017, 93, 5, '2022-08-25 16:41:37.958299+06', NULL);
INSERT INTO public.student (student_id, student_name, password, _year, roll_num, dept_code, notification_last_seen, email_address) VALUES (3, 'Asif Ajrof', '$2y$10$pYUj/gnwUYpkBdWQiXi3buA8rVAE3EFSJbd2FSQuWkAEAF3SZqGPW', 2017, 92, 5, '2022-08-25 16:41:37.973085+06', NULL);
INSERT INTO public.student (student_id, student_name, password, _year, roll_num, dept_code, notification_last_seen, email_address) VALUES (4, 'Saif Ahmed Khan', '$2y$10$nCoBIjkAYSLLwLW8tDe4Ku3Ud.TkJvViq62cGQ.dkfmpl3XqavsvW', 2017, 110, 5, '2022-08-25 16:41:37.990361+06', NULL);
INSERT INTO public.student (student_id, student_name, password, _year, roll_num, dept_code, notification_last_seen, email_address) VALUES (5, 'Nazmul Takbir', '$2y$10$iVzkVjUWBYUKA2rcPz83BubHExrrr0guL5nEZHrK4GdZj8PzRZQd.', 2017, 103, 5, '2022-08-25 16:41:38.004547+06', NULL);
INSERT INTO public.student (student_id, student_name, password, _year, roll_num, dept_code, notification_last_seen, email_address) VALUES (6, 'Sihat Afnan', '$2y$10$WoVLtw9ux4j13piNbC3df.UKBJwO7wFVmLzfbqzZeNBc8NE3ierLO', 2017, 98, 5, '2022-08-25 16:41:38.020103+06', NULL);


--
-- Data for Name: student_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: student_resource; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: submission; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.submission (sub_id, event_id, enrol_id, link, sub_time) VALUES (4, 1, 4, '\file.txt', '2022-08-25 20:52:59.548799+06');


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (1, 'A.B.M. Alim Al Islam', 2, 5, '2022-08-25 16:41:38.73824+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (2, 'Abdullah Adnan', 3, 5, '2022-08-25 16:41:38.768371+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (3, 'Saidur Rahman', 4, 5, '2022-08-25 16:41:38.789843+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (4, 'Saifur Rahman', 5, 5, '2022-08-25 16:41:38.801741+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (5, 'Shasuzzoha Bayzid', 6, 5, '2022-08-25 16:41:38.814311+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (6, 'Nafiz Irtiza Tripto', 7, 5, '2022-08-25 16:41:38.830629+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (7, 'Shadman Saquib Eusuf', 8, 5, '2022-08-25 16:41:38.852895+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (8, 'Shohrab Hossain', 9, 5, '2022-08-25 16:41:38.863845+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (9, 'Syed Md. Mukit Rashid', 10, 5, '2022-08-25 16:41:38.874889+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (10, 'Munshi Abdur Rauf', 11, 7, '2022-08-25 16:41:38.887702+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (11, 'Rony Hossain', 12, 7, '2022-08-25 16:41:38.910689+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (12, 'Rayhan Rashed', 13, 5, '2022-08-25 16:41:38.956605+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (13, 'Tahmid Hasan', 14, 5, '2022-08-25 16:41:38.988217+06');
INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (14, 'Mohammad Tawhidul Hasan Bhuiyan', 15, 5, '2022-08-25 16:41:39.017097+06');


--
-- Data for Name: teacher_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: teacher_routine; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (1, 1, 1);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (2, 1, 2);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (3, 2, 3);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (4, 2, 4);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (5, 2, 5);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (6, 3, 9);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (7, 4, 10);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (8, 3, 11);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (9, 9, 12);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (10, 9, 13);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (11, 9, 14);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (12, 6, 15);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (13, 6, 16);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (14, 6, 17);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (15, 8, 21);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (16, 7, 21);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (17, 11, 22);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (18, 12, 22);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (19, 15, 18);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (20, 15, 19);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (21, 15, 20);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (22, 14, 6);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (23, 14, 7);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (24, 14, 8);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (25, 16, 23);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (26, 17, 23);
INSERT INTO public.teacher_routine (teacher_class_id, instructor_id, class_id) VALUES (27, 18, 23);


--
-- Data for Name: topic; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.topic (topic_num, topic_name, instructor_id, finished, description, started) VALUES (1, 'State-Space Modeling', 1, false, 'We learn making markov model here', '2022-08-25 16:41:43.379564+06');


--
-- Data for Name: visibility; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.visibility (type_id, type_name) VALUES (1, 'All');
INSERT INTO public.visibility (type_id, type_name) VALUES (2, 'Only Student');
INSERT INTO public.visibility (type_id, type_name) VALUES (3, 'Only Teacher');
INSERT INTO public.visibility (type_id, type_name) VALUES (4, 'Only CR');


--
-- Name: admins_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_admin_id_seq', 1, true);


--
-- Name: canceled_class_canceled_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.canceled_class_canceled_class_id_seq', 1, false);


--
-- Name: course_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_course_id_seq', 10, true);


--
-- Name: course_post_file_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_post_file_file_id_seq', 1, false);


--
-- Name: course_post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_post_post_id_seq', 4, true);


--
-- Name: course_routine_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_routine_class_id_seq', 23, true);


--
-- Name: enrolment_enrol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enrolment_enrol_id_seq', 48, true);


--
-- Name: evaluation_evaluation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluation_evaluation_id_seq', 10, true);


--
-- Name: evaluation_type_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluation_type_type_id_seq', 1, false);


--
-- Name: extra_class_extra_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.extra_class_extra_class_id_seq', 1, false);


--
-- Name: extra_class_teacher_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.extra_class_teacher_assignment_id_seq', 1, false);


--
-- Name: extra_evaluation_instructor_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.extra_evaluation_instructor_assignment_id_seq', 1, false);


--
-- Name: forum_post_files_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.forum_post_files_file_id_seq', 1, false);


--
-- Name: forum_post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.forum_post_post_id_seq', 1, true);


--
-- Name: grading_grading_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grading_grading_id_seq', 1, false);


--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_instructor_id_seq', 18, true);


--
-- Name: notification_event_not_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_event_not_id_seq', 14, true);


--
-- Name: notification_type_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_type_type_id_seq', 1, false);


--
-- Name: official_users_user_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.official_users_user_no_seq', 15, true);


--
-- Name: private_file_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.private_file_file_id_seq', 1, false);


--
-- Name: request_event_req_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.request_event_req_id_seq', 1, false);


--
-- Name: request_type_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.request_type_type_id_seq', 1, false);


--
-- Name: resource_res_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.resource_res_id_seq', 1, false);


--
-- Name: section_section_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.section_section_no_seq', 11, true);


--
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_student_id_seq', 6, true);


--
-- Name: submission_sub_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.submission_sub_id_seq', 4, true);


--
-- Name: teacher_routine_teacher_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_routine_teacher_class_id_seq', 27, true);


--
-- Name: teacher_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_teacher_id_seq', 14, true);


--
-- Name: topic_topic_num_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.topic_topic_num_seq', 1, true);


--
-- Name: visibility_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visibility_type_id_seq', 1, false);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (admin_id);


--
-- Name: admins admins_user_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_user_no_key UNIQUE (user_no);


--
-- Name: canceled_class canceled_class_class_id__date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canceled_class
    ADD CONSTRAINT canceled_class_class_id__date_key UNIQUE (class_id, _date);


--
-- Name: canceled_class canceled_class_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canceled_class
    ADD CONSTRAINT canceled_class_pkey PRIMARY KEY (canceled_class_id);


--
-- Name: course course_course_num_dept_code__year_level_offered_dept_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_course_num_dept_code__year_level_offered_dept_code_key UNIQUE (course_num, dept_code, _year, level, offered_dept_code);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (course_id);


--
-- Name: course_post_file course_post_file_file_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post_file
    ADD CONSTRAINT course_post_file_file_link_key UNIQUE (file_link);


--
-- Name: course_post_file course_post_file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post_file
    ADD CONSTRAINT course_post_file_pkey PRIMARY KEY (file_id);


--
-- Name: course_post course_post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post
    ADD CONSTRAINT course_post_pkey PRIMARY KEY (post_id);


--
-- Name: course_post course_post_poster_id_post_time_student_post_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post
    ADD CONSTRAINT course_post_poster_id_post_time_student_post_key UNIQUE (poster_id, post_time, student_post);


--
-- Name: course_routine course_routine_day_section_no_start__end_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_routine
    ADD CONSTRAINT course_routine_day_section_no_start__end_key UNIQUE (day, section_no, start, _end);


--
-- Name: course_routine course_routine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_routine
    ADD CONSTRAINT course_routine_pkey PRIMARY KEY (class_id);


--
-- Name: department department_dept_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_dept_name_key UNIQUE (dept_name);


--
-- Name: department department_dept_shortname_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_dept_shortname_key UNIQUE (dept_shortname);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (dept_code);


--
-- Name: enrolment enrolment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrolment
    ADD CONSTRAINT enrolment_pkey PRIMARY KEY (enrol_id);


--
-- Name: enrolment enrolment_section_id_student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrolment
    ADD CONSTRAINT enrolment_section_id_student_id_key UNIQUE (section_id, student_id);


--
-- Name: evaluation evaluation__date_type_id_section_no_start__end_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation__date_type_id_section_no_start__end_key UNIQUE (_date, type_id, section_no, start, _end);


--
-- Name: evaluation evaluation_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_link_key UNIQUE (link);


--
-- Name: evaluation evaluation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_pkey PRIMARY KEY (evaluation_id);


--
-- Name: evaluation_type evaluation_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_type
    ADD CONSTRAINT evaluation_type_pkey PRIMARY KEY (type_id);


--
-- Name: evaluation_type evaluation_type_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_type
    ADD CONSTRAINT evaluation_type_type_name_key UNIQUE (type_name);


--
-- Name: extra_class extra_class_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class
    ADD CONSTRAINT extra_class_pkey PRIMARY KEY (extra_class_id);


--
-- Name: extra_class extra_class_section_no_instructor_id_start__end__date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class
    ADD CONSTRAINT extra_class_section_no_instructor_id_start__end__date_key UNIQUE (section_no, instructor_id, start, _end, _date);


--
-- Name: extra_class_teacher extra_class_teacher_extra_class_id_instructor_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class_teacher
    ADD CONSTRAINT extra_class_teacher_extra_class_id_instructor_id_key UNIQUE (extra_class_id, instructor_id);


--
-- Name: extra_class_teacher extra_class_teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class_teacher
    ADD CONSTRAINT extra_class_teacher_pkey PRIMARY KEY (assignment_id);


--
-- Name: extra_evaluation_instructor extra_evaluation_instructor_evaluation_id_instructor_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_evaluation_instructor
    ADD CONSTRAINT extra_evaluation_instructor_evaluation_id_instructor_id_key UNIQUE (evaluation_id, instructor_id);


--
-- Name: extra_evaluation_instructor extra_evaluation_instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_evaluation_instructor
    ADD CONSTRAINT extra_evaluation_instructor_pkey PRIMARY KEY (assignment_id);


--
-- Name: forum_post_files forum_post_files_file_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post_files
    ADD CONSTRAINT forum_post_files_file_link_key UNIQUE (file_link);


--
-- Name: forum_post_files forum_post_files_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post_files
    ADD CONSTRAINT forum_post_files_pkey PRIMARY KEY (file_id);


--
-- Name: forum_post forum_post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post
    ADD CONSTRAINT forum_post_pkey PRIMARY KEY (post_id);


--
-- Name: forum_post forum_post_poster_post_time_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post
    ADD CONSTRAINT forum_post_poster_post_time_key UNIQUE (poster, post_time);


--
-- Name: grading grading_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading
    ADD CONSTRAINT grading_pkey PRIMARY KEY (grading_id);


--
-- Name: grading grading_sub_id_instructor_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading
    ADD CONSTRAINT grading_sub_id_instructor_id_key UNIQUE (sub_id, instructor_id);


--
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (instructor_id);


--
-- Name: instructor_resource instructor_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_resource
    ADD CONSTRAINT instructor_resource_pkey PRIMARY KEY (res_id);


--
-- Name: instructor_resource instructor_resource_res_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_resource
    ADD CONSTRAINT instructor_resource_res_link_key UNIQUE (res_link);


--
-- Name: instructor instructor_teacher_id_course_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_teacher_id_course_id_key UNIQUE (teacher_id, course_id);


--
-- Name: notification_event notification_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_event
    ADD CONSTRAINT notification_event_pkey PRIMARY KEY (not_id);


--
-- Name: notification_event notification_event_type_id_event_no_event_type__date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_event
    ADD CONSTRAINT notification_event_type_id_event_no_event_type__date_key UNIQUE (type_id, event_no, event_type, _date);


--
-- Name: notification_type notification_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_pkey PRIMARY KEY (type_id);


--
-- Name: notification_type notification_type_visibility_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_visibility_type_name_key UNIQUE (visibility, type_name);


--
-- Name: official_users official_users_email_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.official_users
    ADD CONSTRAINT official_users_email_address_key UNIQUE (email_address);


--
-- Name: official_users official_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.official_users
    ADD CONSTRAINT official_users_pkey PRIMARY KEY (user_no);


--
-- Name: official_users official_users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.official_users
    ADD CONSTRAINT official_users_username_key UNIQUE (username);


--
-- Name: request_event request_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_event
    ADD CONSTRAINT request_event_pkey PRIMARY KEY (req_id);


--
-- Name: request_event request_event_type_id_section_no_instructor_id_start__end___key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_event
    ADD CONSTRAINT request_event_type_id_section_no_instructor_id_start__end___key UNIQUE (type_id, section_no, instructor_id, start, _end, _date);


--
-- Name: request_type request_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_type
    ADD CONSTRAINT request_type_pkey PRIMARY KEY (type_id);


--
-- Name: request_type request_type_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_type
    ADD CONSTRAINT request_type_type_name_key UNIQUE (type_name);


--
-- Name: section section_course_id_cr_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_course_id_cr_id_key UNIQUE (course_id, cr_id);


--
-- Name: section section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_pkey PRIMARY KEY (section_no);


--
-- Name: student student_email_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_email_address_key UNIQUE (email_address);


--
-- Name: student_file student_file_file_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_file
    ADD CONSTRAINT student_file_file_link_key UNIQUE (file_link);


--
-- Name: student_file student_file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_file
    ADD CONSTRAINT student_file_pkey PRIMARY KEY (file_id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- Name: student_resource student_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_resource
    ADD CONSTRAINT student_resource_pkey PRIMARY KEY (res_id);


--
-- Name: student_resource student_resource_res_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_resource
    ADD CONSTRAINT student_resource_res_link_key UNIQUE (res_link);


--
-- Name: student student_roll_num__year_dept_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_roll_num__year_dept_code_key UNIQUE (roll_num, _year, dept_code);


--
-- Name: submission submission_event_id_enrol_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_event_id_enrol_id_key UNIQUE (event_id, enrol_id);


--
-- Name: submission submission_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_link_key UNIQUE (link);


--
-- Name: submission submission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_pkey PRIMARY KEY (sub_id);


--
-- Name: teacher_file teacher_file_file_link_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_file
    ADD CONSTRAINT teacher_file_file_link_key UNIQUE (file_link);


--
-- Name: teacher_file teacher_file_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_file
    ADD CONSTRAINT teacher_file_pkey PRIMARY KEY (file_id);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (teacher_id);


--
-- Name: teacher_routine teacher_routine_instructor_id_class_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_routine
    ADD CONSTRAINT teacher_routine_instructor_id_class_id_key UNIQUE (instructor_id, class_id);


--
-- Name: teacher_routine teacher_routine_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_routine
    ADD CONSTRAINT teacher_routine_pkey PRIMARY KEY (teacher_class_id);


--
-- Name: teacher teacher_user_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_user_no_key UNIQUE (user_no);


--
-- Name: topic topic_instructor_id_topic_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topic
    ADD CONSTRAINT topic_instructor_id_topic_name_key UNIQUE (instructor_id, topic_name);


--
-- Name: topic topic_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (topic_num);


--
-- Name: visibility visibility_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visibility
    ADD CONSTRAINT visibility_pkey PRIMARY KEY (type_id);


--
-- Name: visibility visibility_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visibility
    ADD CONSTRAINT visibility_type_name_key UNIQUE (type_name);


--
-- Name: canceled_class cancel_class_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cancel_class_notification AFTER INSERT ON public.canceled_class FOR EACH ROW EXECUTE FUNCTION public.notify_cancel_class();


--
-- Name: canceled_class cancel_class_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cancel_class_notification_update AFTER UPDATE ON public.canceled_class FOR EACH ROW EXECUTE FUNCTION public.notify_cancel_class_update();


--
-- Name: canceled_class cancel_class_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cancel_class_validation BEFORE INSERT OR UPDATE ON public.canceled_class FOR EACH ROW EXECUTE FUNCTION public.cancel_class_day_check();


--
-- Name: course_post course_post_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER course_post_notification AFTER INSERT ON public.course_post FOR EACH ROW EXECUTE FUNCTION public.notify_course_post_added();


--
-- Name: course_post course_post_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER course_post_notification_update AFTER UPDATE ON public.course_post FOR EACH ROW EXECUTE FUNCTION public.notify_course_post_updated();


--
-- Name: course_routine course_routine_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER course_routine_validation BEFORE INSERT OR UPDATE ON public.course_routine FOR EACH ROW EXECUTE FUNCTION public.course_routine_check();


--
-- Name: section cr_assignment; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cr_assignment BEFORE INSERT OR UPDATE ON public.section FOR EACH ROW EXECUTE FUNCTION public.cr_assignment_check();


--
-- Name: course curr_course_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER curr_course_validation AFTER INSERT OR DELETE OR UPDATE ON public.course FOR EACH STATEMENT EXECUTE FUNCTION public.curr_course_update();


--
-- Name: evaluation evaluation_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER evaluation_notification AFTER INSERT ON public.evaluation FOR EACH ROW EXECUTE FUNCTION public.notify_evaluation();


--
-- Name: evaluation evaluation_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER evaluation_notification_update AFTER UPDATE ON public.evaluation FOR EACH ROW EXECUTE FUNCTION public.notify_evaluation_update();


--
-- Name: evaluation evaluation_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER evaluation_validation BEFORE INSERT OR UPDATE ON public.evaluation FOR EACH ROW EXECUTE FUNCTION public.evaluation_check();


--
-- Name: extra_class extra_class_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER extra_class_notification AFTER INSERT ON public.extra_class FOR EACH ROW EXECUTE FUNCTION public.notify_extra_class();


--
-- Name: extra_class extra_class_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER extra_class_notification_update AFTER UPDATE ON public.extra_class FOR EACH ROW EXECUTE FUNCTION public.notify_extra_class_update();


--
-- Name: extra_class extra_class_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER extra_class_validation BEFORE INSERT OR UPDATE ON public.extra_class FOR EACH ROW EXECUTE FUNCTION public.extra_class_check();


--
-- Name: extra_evaluation_instructor extra_evaluation_instructor_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER extra_evaluation_instructor_validation BEFORE INSERT OR UPDATE ON public.extra_evaluation_instructor FOR EACH ROW EXECUTE FUNCTION public.extra_evaluation_instructor_check();


--
-- Name: extra_class_teacher extra_teacher_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER extra_teacher_validation BEFORE INSERT OR UPDATE ON public.extra_class_teacher FOR EACH ROW EXECUTE FUNCTION public.extra_teacher_check();


--
-- Name: forum_post forum_post_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER forum_post_notification AFTER INSERT ON public.forum_post FOR EACH ROW EXECUTE FUNCTION public.notify_forum_post_added();


--
-- Name: forum_post forum_post_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER forum_post_notification_update AFTER UPDATE ON public.forum_post FOR EACH ROW EXECUTE FUNCTION public.notify_forum_post_updated();


--
-- Name: grading grading_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER grading_notification AFTER INSERT ON public.grading FOR EACH ROW EXECUTE FUNCTION public.notify_grading();


--
-- Name: grading grading_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER grading_notification_update AFTER UPDATE ON public.grading FOR EACH ROW EXECUTE FUNCTION public.notify_grading_update();


--
-- Name: grading grading_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER grading_validation BEFORE INSERT OR UPDATE ON public.grading FOR EACH ROW EXECUTE FUNCTION public.grading_check();


--
-- Name: instructor instructor_assignment; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER instructor_assignment BEFORE INSERT OR UPDATE ON public.instructor FOR EACH ROW EXECUTE FUNCTION public.instructor_check();


--
-- Name: instructor_resource instructor_resource_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER instructor_resource_notification AFTER INSERT ON public.instructor_resource FOR EACH ROW EXECUTE FUNCTION public.notify_instructor_resource_added();


--
-- Name: instructor_resource instructor_resource_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER instructor_resource_notification_update AFTER UPDATE ON public.instructor_resource FOR EACH ROW EXECUTE FUNCTION public.notify_instructor_resource_updated();


--
-- Name: enrolment intersected_section_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER intersected_section_validation AFTER INSERT OR DELETE OR UPDATE ON public.enrolment FOR EACH STATEMENT EXECUTE FUNCTION public.intersected_section_update();


--
-- Name: notification_event notification_event_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER notification_event_validation BEFORE INSERT OR UPDATE ON public.notification_event FOR EACH ROW EXECUTE FUNCTION public.notification_event_check();


--
-- Name: course_post post_check; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER post_check BEFORE INSERT OR UPDATE ON public.course_post FOR EACH ROW EXECUTE FUNCTION public.poster_check();


--
-- Name: request_event request_event_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER request_event_notification AFTER INSERT ON public.request_event FOR EACH ROW EXECUTE FUNCTION public.notify_request_event();


--
-- Name: request_event request_event_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER request_event_notification_update AFTER UPDATE ON public.request_event FOR EACH ROW EXECUTE FUNCTION public.notify_request_event_update();


--
-- Name: request_event request_event_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER request_event_validation BEFORE INSERT OR UPDATE ON public.request_event FOR EACH ROW EXECUTE FUNCTION public.request_event_check();


--
-- Name: student_resource student_resource_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER student_resource_notification AFTER INSERT ON public.student_resource FOR EACH ROW EXECUTE FUNCTION public.notify_student_resource_added();


--
-- Name: student_resource student_resource_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER student_resource_notification_update AFTER UPDATE ON public.student_resource FOR EACH ROW EXECUTE FUNCTION public.notify_student_resource_updated();


--
-- Name: submission submission_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER submission_validation BEFORE INSERT OR UPDATE ON public.submission FOR EACH ROW EXECUTE FUNCTION public.submission_check();


--
-- Name: teacher_routine teacher_routine_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER teacher_routine_validation BEFORE INSERT OR UPDATE ON public.teacher_routine FOR EACH ROW EXECUTE FUNCTION public.teacher_routine_check();


--
-- Name: topic topic_notification; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER topic_notification AFTER INSERT ON public.topic FOR EACH ROW EXECUTE FUNCTION public.notify_topic_added();


--
-- Name: topic topic_update_notification_update; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER topic_update_notification_update AFTER UPDATE ON public.topic FOR EACH ROW EXECUTE FUNCTION public.notify_topic_updated();


--
-- Name: admins admins_user_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_user_no_fkey FOREIGN KEY (user_no) REFERENCES public.official_users(user_no);


--
-- Name: canceled_class canceled_class_class_id_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canceled_class
    ADD CONSTRAINT canceled_class_class_id_instructor_id_fkey FOREIGN KEY (class_id, instructor_id) REFERENCES public.teacher_routine(class_id, instructor_id);


--
-- Name: course course_dept_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_dept_code_fkey FOREIGN KEY (dept_code) REFERENCES public.department(dept_code);


--
-- Name: course course_offered_dept_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_offered_dept_code_fkey FOREIGN KEY (offered_dept_code) REFERENCES public.department(dept_code);


--
-- Name: course_post_file course_post_file_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post_file
    ADD CONSTRAINT course_post_file_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.course_post(post_id);


--
-- Name: course_post course_post_parent_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_post
    ADD CONSTRAINT course_post_parent_post_fkey FOREIGN KEY (parent_post) REFERENCES public.course_post(post_id);


--
-- Name: course_routine course_routine_section_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_routine
    ADD CONSTRAINT course_routine_section_no_fkey FOREIGN KEY (section_no) REFERENCES public.section(section_no);


--
-- Name: enrolment enrolment_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrolment
    ADD CONSTRAINT enrolment_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.section(section_no);


--
-- Name: enrolment enrolment_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrolment
    ADD CONSTRAINT enrolment_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(student_id);


--
-- Name: evaluation evaluation_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: evaluation evaluation_section_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_section_no_fkey FOREIGN KEY (section_no) REFERENCES public.section(section_no);


--
-- Name: evaluation evaluation_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.evaluation_type(type_id);


--
-- Name: extra_class extra_class_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class
    ADD CONSTRAINT extra_class_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: extra_class extra_class_section_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class
    ADD CONSTRAINT extra_class_section_no_fkey FOREIGN KEY (section_no) REFERENCES public.section(section_no);


--
-- Name: extra_class_teacher extra_class_teacher_extra_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class_teacher
    ADD CONSTRAINT extra_class_teacher_extra_class_id_fkey FOREIGN KEY (extra_class_id) REFERENCES public.extra_class(extra_class_id);


--
-- Name: extra_class_teacher extra_class_teacher_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_class_teacher
    ADD CONSTRAINT extra_class_teacher_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: extra_evaluation_instructor extra_evaluation_instructor_evaluation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_evaluation_instructor
    ADD CONSTRAINT extra_evaluation_instructor_evaluation_id_fkey FOREIGN KEY (evaluation_id) REFERENCES public.evaluation(evaluation_id);


--
-- Name: extra_evaluation_instructor extra_evaluation_instructor_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_evaluation_instructor
    ADD CONSTRAINT extra_evaluation_instructor_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: forum_post_files forum_post_files_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post_files
    ADD CONSTRAINT forum_post_files_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.forum_post(post_id);


--
-- Name: forum_post forum_post_parent_post_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post
    ADD CONSTRAINT forum_post_parent_post_fkey FOREIGN KEY (parent_post) REFERENCES public.forum_post(post_id);


--
-- Name: forum_post forum_post_poster_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forum_post
    ADD CONSTRAINT forum_post_poster_fkey FOREIGN KEY (poster) REFERENCES public.official_users(user_no);


--
-- Name: grading grading_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading
    ADD CONSTRAINT grading_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: grading grading_sub_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grading
    ADD CONSTRAINT grading_sub_id_fkey FOREIGN KEY (sub_id) REFERENCES public.submission(sub_id);


--
-- Name: instructor instructor_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.course(course_id);


--
-- Name: instructor_resource instructor_resource_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_resource
    ADD CONSTRAINT instructor_resource_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.instructor(instructor_id);


--
-- Name: instructor instructor_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(teacher_id);


--
-- Name: notification_event notification_event_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_event
    ADD CONSTRAINT notification_event_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.notification_type(type_id);


--
-- Name: notification_type notification_type_visibility_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_visibility_fkey FOREIGN KEY (visibility) REFERENCES public.visibility(type_id);


--
-- Name: request_event request_event_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_event
    ADD CONSTRAINT request_event_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: request_event request_event_section_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_event
    ADD CONSTRAINT request_event_section_no_fkey FOREIGN KEY (section_no) REFERENCES public.section(section_no);


--
-- Name: request_event request_event_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.request_event
    ADD CONSTRAINT request_event_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.request_type(type_id);


--
-- Name: section section_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.course(course_id);


--
-- Name: section section_cr_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_cr_id_fkey FOREIGN KEY (cr_id) REFERENCES public.student(student_id);


--
-- Name: student student_dept_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_dept_code_fkey FOREIGN KEY (dept_code) REFERENCES public.department(dept_code);


--
-- Name: student_file student_file_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_file
    ADD CONSTRAINT student_file_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.student(student_id);


--
-- Name: student_resource student_resource_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_resource
    ADD CONSTRAINT student_resource_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.enrolment(enrol_id);


--
-- Name: submission submission_enrol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_enrol_id_fkey FOREIGN KEY (enrol_id) REFERENCES public.enrolment(enrol_id);


--
-- Name: submission submission_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.submission
    ADD CONSTRAINT submission_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.evaluation(evaluation_id);


--
-- Name: teacher teacher_dept_code_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_dept_code_fkey FOREIGN KEY (dept_code) REFERENCES public.department(dept_code);


--
-- Name: teacher_file teacher_file_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_file
    ADD CONSTRAINT teacher_file_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.teacher(teacher_id);


--
-- Name: teacher_routine teacher_routine_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_routine
    ADD CONSTRAINT teacher_routine_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.course_routine(class_id);


--
-- Name: teacher_routine teacher_routine_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_routine
    ADD CONSTRAINT teacher_routine_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: teacher teacher_user_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_user_no_fkey FOREIGN KEY (user_no) REFERENCES public.official_users(user_no);


--
-- Name: topic topic_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.topic
    ADD CONSTRAINT topic_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: all_courses; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.all_courses;


--
-- Name: current_courses; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.current_courses;


--
-- Name: intersected_sections; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.intersected_sections;


--
-- PostgreSQL database dump complete
--

