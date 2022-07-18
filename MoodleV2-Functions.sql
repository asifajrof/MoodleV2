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

--drop function get_current_course(std_id integer);
-- drop function section_to_course(sec_no integer);
--drop function term_name(term_num integer);
