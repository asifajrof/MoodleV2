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
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$$;


ALTER FUNCTION public.evaluation_check() OWNER TO postgres;

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
    return new;
end;
$$;


ALTER FUNCTION public.extra_class_check() OWNER TO postgres;

--
-- Name: extra_teacher_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.extra_teacher_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
left outer join evaluation ev on (ev.section_no=e.section_id and ev._end<current_timestamp)) left outer join submission s2 on (s2.enrol_id=e.enrol_id)
group by _id,_term,__year,_dept_shortname,_course_code,_course_name;
end
$$;


ALTER FUNCTION public.get_current_course(std_id integer) OWNER TO postgres;

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
$$;


ALTER FUNCTION public.get_upcoming_events(std_id integer) OWNER TO postgres;

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
-- Name: notification_event_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notification_event_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$$;


ALTER FUNCTION public.notification_event_check() OWNER TO postgres;

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
-- Name: overlapped_timestamp(timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.overlapped_timestamp(first_begin timestamp without time zone, first_end timestamp without time zone, second_begin timestamp without time zone, second_end timestamp without time zone) RETURNS boolean
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


ALTER FUNCTION public.overlapped_timestamp(first_begin timestamp without time zone, first_end timestamp without time zone, second_begin timestamp without time zone, second_end timestamp without time zone) OWNER TO postgres;

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
-- Name: canceled_class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.canceled_class (
    canceled_class_id integer NOT NULL,
    class_id integer NOT NULL,
    _date date NOT NULL
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
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    dept_code integer NOT NULL,
    dept_name character varying(64) NOT NULL,
    dept_shortname character varying(8) NOT NULL
);


ALTER TABLE public.department OWNER TO postgres;

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
    _date date NOT NULL,
    total_marks double precision NOT NULL,
    description character varying(2048),
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
    typt_id integer NOT NULL,
    type_name character varying(64) NOT NULL,
    notification_time_type boolean DEFAULT true NOT NULL
);


ALTER TABLE public.evaluation_type OWNER TO postgres;

--
-- Name: evaluation_type_typt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.evaluation_type_typt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.evaluation_type_typt_id_seq OWNER TO postgres;

--
-- Name: evaluation_type_typt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.evaluation_type_typt_id_seq OWNED BY public.evaluation_type.typt_id;


--
-- Name: extra_class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_class (
    extra_class_id integer NOT NULL,
    section_no integer NOT NULL,
    instructor_id integer NOT NULL,
    start timestamp with time zone NOT NULL,
    _end timestamp with time zone NOT NULL,
    _date date NOT NULL,
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
  GROUP BY e.section_id, f.section_id
  WITH NO DATA;


ALTER TABLE public.intersected_sections OWNER TO postgres;

--
-- Name: notification_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_event (
    not_id integer NOT NULL,
    type_id integer NOT NULL,
    section_no integer NOT NULL,
    instructor_id integer NOT NULL,
    start timestamp with time zone NOT NULL,
    _end timestamp with time zone NOT NULL,
    _date date NOT NULL,
    notifucation_time timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT notification_event_check CHECK ((_end > start)),
    CONSTRAINT notification_event_start_check CHECK ((start >= CURRENT_TIMESTAMP))
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
    _date date NOT NULL,
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
-- Name: evaluation_type typt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_type ALTER COLUMN typt_id SET DEFAULT nextval('public.evaluation_type_typt_id_seq'::regclass);


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


--
-- Data for Name: course_post; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: course_post_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: course_routine; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course_routine (class_id, section_no, alternation, start, _end, day) VALUES (1, 1, 7, '08:00:00', '10:00:00', 0);


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (1, 'Architecture', 'Arch');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (2, 'Chemical Engineering', 'ChE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (4, 'Civil Engineering', 'CE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (5, 'Computer Science and Engineering', 'CSE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (6, 'Electrical and Electronic Engineering', 'EEE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (8, 'Industrial and Production Engineering', 'IPE');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (10, 'Mechanical Engineering', 'ME');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (11, 'Materials and Metallurgical Engineering', 'MME');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (15, 'Urban and Regional Planning', 'URP');
INSERT INTO public.department (dept_code, dept_name, dept_shortname) VALUES (18, 'Biomedical Engineering', 'BME');


--
-- Data for Name: enrolment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.enrolment (enrol_id, student_id, section_id, _date) VALUES (1, 1, 1, '2022-08-12');


--
-- Data for Name: evaluation; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: evaluation_type; Type: TABLE DATA; Schema: public; Owner: postgres
--



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



--
-- Data for Name: forum_post_files; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: grading; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor (instructor_id, teacher_id, course_id, _date) VALUES (1, 1, 1, '2022-08-12');


--
-- Data for Name: instructor_resource; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: notification_event; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: notification_type; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: official_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (1, 'nazmuladmin', '$2a$12$a3sA/qgphlpSnjZl2EkaW.EvlHrTbsrX8ZjD1iqJzqZgYLdkPXmAy', NULL);
INSERT INTO public.official_users (user_no, username, password, email_address) VALUES (2, 'alimrazi', '$2a$12$vJa9O6JwQkfILdYj5bSsCuVbeSC863/MIe7x1UZM0qU7iPcwfewB2', NULL);


--
-- Data for Name: private_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: request_event; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: request_type; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: resource; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: section; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.section (section_no, section_name, course_id, cr_id) VALUES (1, 'CSE-2017-B2-CSE423-2022', 1, NULL);


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student (student_id, student_name, password, _year, roll_num, dept_code, notification_last_seen, email_address) VALUES (1, 'Md. Shariful', '$2a$12$BjvAnEmgjQsjLxPmFsD8Peh7H0DV49ZiXZisriA/IZ92ySlPJc1p.', 2017, 119, 5, '2022-08-12 16:29:53.587539+06', NULL);


--
-- Data for Name: student_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: student_resource; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: submission; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teacher (teacher_id, teacher_name, user_no, dept_code, notification_last_seen) VALUES (1, 'A.B.M. Alim Al Islam', 2, 5, '2022-08-12 16:29:53.74521+06');


--
-- Data for Name: teacher_file; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: teacher_routine; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: topic; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.topic (topic_num, topic_name, instructor_id, finished, description, started) VALUES (1, 'State Space Modeling', 1, true, 'Here we will learn how to make a model to use in Markov chain', '2022-08-12 16:53:35.099193+06');


--
-- Data for Name: visibility; Type: TABLE DATA; Schema: public; Owner: postgres
--



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

SELECT pg_catalog.setval('public.course_course_id_seq', 2, true);


--
-- Name: course_post_file_file_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_post_file_file_id_seq', 1, false);


--
-- Name: course_post_post_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_post_post_id_seq', 1, false);


--
-- Name: course_routine_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_routine_class_id_seq', 1, true);


--
-- Name: enrolment_enrol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enrolment_enrol_id_seq', 1, true);


--
-- Name: evaluation_evaluation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluation_evaluation_id_seq', 1, false);


--
-- Name: evaluation_type_typt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.evaluation_type_typt_id_seq', 1, false);


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

SELECT pg_catalog.setval('public.forum_post_post_id_seq', 1, false);


--
-- Name: grading_grading_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grading_grading_id_seq', 1, false);


--
-- Name: instructor_instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_instructor_id_seq', 1, true);


--
-- Name: notification_event_not_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_event_not_id_seq', 1, false);


--
-- Name: notification_type_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_type_type_id_seq', 1, false);


--
-- Name: official_users_user_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.official_users_user_no_seq', 2, true);


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

SELECT pg_catalog.setval('public.section_section_no_seq', 1, true);


--
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_student_id_seq', 1, true);


--
-- Name: submission_sub_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.submission_sub_id_seq', 1, false);


--
-- Name: teacher_routine_teacher_class_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_routine_teacher_class_id_seq', 1, false);


--
-- Name: teacher_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_teacher_id_seq', 1, true);


--
-- Name: topic_topic_num_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.topic_topic_num_seq', 2, true);


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
-- Name: evaluation evaluation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation
    ADD CONSTRAINT evaluation_pkey PRIMARY KEY (evaluation_id);


--
-- Name: evaluation_type evaluation_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.evaluation_type
    ADD CONSTRAINT evaluation_type_pkey PRIMARY KEY (typt_id);


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
-- Name: notification_event notification_event_type_id_section_no_instructor_id_start___key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_event
    ADD CONSTRAINT notification_event_type_id_section_no_instructor_id_start___key UNIQUE (type_id, section_no, instructor_id, start, _end, _date);


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
-- Name: canceled_class cancel_class_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cancel_class_validation BEFORE INSERT OR UPDATE ON public.canceled_class FOR EACH ROW EXECUTE FUNCTION public.cancel_class_day_check();


--
-- Name: section cr_assignment; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER cr_assignment BEFORE INSERT OR UPDATE ON public.section FOR EACH ROW EXECUTE FUNCTION public.cr_assignment_check();


--
-- Name: course curr_course_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER curr_course_validation AFTER INSERT OR DELETE OR UPDATE ON public.course FOR EACH STATEMENT EXECUTE FUNCTION public.curr_course_update();


--
-- Name: evaluation evaluation_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER evaluation_validation BEFORE INSERT OR UPDATE ON public.evaluation FOR EACH ROW EXECUTE FUNCTION public.evaluation_check();


--
-- Name: extra_class extra_class_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER extra_class_validation BEFORE INSERT OR UPDATE ON public.extra_class FOR EACH ROW EXECUTE FUNCTION public.extra_class_check();


--
-- Name: extra_class_teacher extra_teacher_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER extra_teacher_validation BEFORE INSERT OR UPDATE ON public.extra_class_teacher FOR EACH ROW EXECUTE FUNCTION public.extra_teacher_check();


--
-- Name: grading grading_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER grading_validation BEFORE INSERT OR UPDATE ON public.grading FOR EACH ROW EXECUTE FUNCTION public.grading_check();


--
-- Name: instructor instructor_assignment; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER instructor_assignment BEFORE INSERT OR UPDATE ON public.instructor FOR EACH ROW EXECUTE FUNCTION public.instructor_check();


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
-- Name: request_event request_event_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER request_event_validation BEFORE INSERT OR UPDATE ON public.request_event FOR EACH ROW EXECUTE FUNCTION public.request_event_check();


--
-- Name: submission submission_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER submission_validation BEFORE INSERT OR UPDATE ON public.submission FOR EACH ROW EXECUTE FUNCTION public.submission_check();


--
-- Name: teacher_routine teacher_routine_validation; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER teacher_routine_validation BEFORE INSERT OR UPDATE ON public.teacher_routine FOR EACH ROW EXECUTE FUNCTION public.teacher_routine_check();


--
-- Name: admins admins_user_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_user_no_fkey FOREIGN KEY (user_no) REFERENCES public.official_users(user_no);


--
-- Name: canceled_class canceled_class_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.canceled_class
    ADD CONSTRAINT canceled_class_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.course_routine(class_id);


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
    ADD CONSTRAINT evaluation_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.evaluation_type(typt_id);


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
-- Name: notification_event notification_event_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_event
    ADD CONSTRAINT notification_event_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(instructor_id);


--
-- Name: notification_event notification_event_section_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_event
    ADD CONSTRAINT notification_event_section_no_fkey FOREIGN KEY (section_no) REFERENCES public.section(section_no);


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

