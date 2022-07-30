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

-- drop materialized view intersected_sections;
-- drop materialized view current_courses;
-- drop function term_name(term_num integer);
