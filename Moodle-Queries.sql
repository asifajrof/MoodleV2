insert into department
values (5,'Computer Science and Engineering','CSE');

insert into student
values (1,'Md. Shariful Islam','4149064daa97438c2dac602c7540e4eba55a353dd0611b3eac610bb66ad34e3b',2017,119,5);

insert into course
values(1,'Introduction to Computer Programming',1,5,2018,1,1);

insert into course
values(2,'Data Structures and Algorithms',3,5,2018,2,1);

insert into section(section_name, course_id)
values('CSE-2017-B2-CSE101-2018',1);

insert into enrolment(student_id, section_id)
values (1,1);

select id,term,_year,dept_shortname,course_code,course_name
from (
    select student_id from student
    where (mod(_year,100)*100000+dept_code*1000+roll_num)=1705119
     ) s join (
         select student_id,section_to_course(section_id) as course_id from enrolment
    ) e on s.student_id=e.student_id join current_courses cc on e.course_id=cc.id;
    
create or replace function get_current_course (std_id integer)
    returns table (id integer,term varchar,_year integer,dept_shortname varchar,course_code integer,course_name varchar) as $$
begin
    return query
    select id,term,_year,dept_shortname,course_code,course_name
from (
    select student_id from student
    where (mod(student._year,100)*100000+dept_code*1000+roll_num)=std_id
     ) s join (
         select student_id,section_to_course(section_id) as course_id from enrolment
    ) e on s.student_id=e.student_id join current_courses cc on e.course_id=cc.id;
end
$$ language plpgsql;
