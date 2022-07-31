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
    select _id,_term,__year,_dept_shortname,_course_code,_course_name,count(s2.sub_id)::integer
from (
    select student_id from student
    where (mod(student._year,100)*100000+dept_code*1000+roll_num)=std_id
     ) s join (
         select enrol_id,student_id,section_id from enrolment
    ) e on s.student_id=e.student_id join section sec on e.section_id=sec.section_no join current_courses cc on sec.course_id=cc._id
    left outer join evaluation ev on ev.section_no=sec.section_no left outer join submission s2 on (ev.evaluation_id = s2.event_id and s2.enrol_id = e.enrol_id)
where ev._end<current_timestamp
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
                                                                  on (et.typt_id = e.type_id and mod(et.notification_time_type, 2) = 0)
                                                                      and start::date = current_date and start::time>current_time)
                                                   union
                                                   (select section_no, _end::time as _lookup_time, et.type_name as _event_type
                                                    from evaluation e
                                                             join evaluation_type et
                                                                  on (et.typt_id = e.type_id and mod(et.notification_time_type, 2) = 1)
                                                                      and _end::date = current_date and _end::time>current_time))) ut join
    (
        select section_id from enrolment join student on (enrolment.student_id = student.student_id) where mod(_year,100)*100000+dept_code*1000+roll_num=std_id
    ) ss on (ut.section_no=ss.section_id) join section s on (ss.section_id=s.section_no) join current_courses cc on (s.course_id=cc._id);
end
$$ language plpgsql;

-- drop function get_upcoming_events(std_id integer);
-- drop function get_current_course(std_id integer);
-- drop function section_to_course(sec_no integer);
-- drop function overlapped_time(first_begin time,first_end time,second_begin time,second_end time);
-- drop function overlapped_timestamp(first_begin timestamp,first_end timestamp,second_begin timestamp,second_end timestamp);
-- drop function add_course(cname varchar, cnum integer, dept integer, offered_dept integer, offered_batch integer, offered_year integer, offered_level integer, offered_term integer);
-- drop function add_teacher(name varchar, uname varchar, hashed_password varchar, dept integer, email varchar);
-- drop function add_student(name varchar,hashed_password varchar,roll integer,dept integer,batch integer, email varchar);