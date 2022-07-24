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
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar) as $$
begin
    return query
    select _id,_term,__year,_dept_shortname,_course_code,_course_name
from (
    select student_id from student
    where (mod(student._year,100)*100000+dept_code*1000+roll_num)=std_id
     ) s join (
         select student_id,section_to_course(section_id) as course_id from enrolment
    ) e on s.student_id=e.student_id join current_courses cc on e.course_id=cc._id;
end
$$ language plpgsql;
create or replace function get_upcoming_events (std_id integer)
    returns table (id integer,dept_shortname varchar,course_code integer, lookup_time time,event_type varchar) as $$
begin
    return query
    select cc._id,cc._dept_shortname,cc._course_code, _lookup_time,_event_type from (
                                                  ((select section_no, start as _lookup_time, 'Class' as _event_type
                                                    from course_routine cr
                                                    where day = extract(isodow from current_date) - 1
                                                      and not exists(
                                                            select class_id
                                                            from canceled_class cc
                                                            where cc.class_id = cr.class_id and _date = current_date
                                                        ))
                                                   union
                                                   (select section_no, start::time as _lookup_time, 'Extra Class' as _event_type
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
    ) ss on (ut.section_no=ss.section_id) join section s on (ss.section_id=s.section_no) join current_courses cc on (s.course_id=cc._course_code);
end
$$ language plpgsql;

-- drop function get_upcoming_events(std_id integer);
--drop function get_current_course(std_id integer);
-- drop function section_to_course(sec_no integer);
--drop function term_name(term_num integer);
