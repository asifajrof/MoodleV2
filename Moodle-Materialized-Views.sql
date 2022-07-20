create materialized view current_courses as
select c.course_id as _id,term_name(term) as _term,_year as __year,dept_shortname as _dept_shortname,(level*100+course_num) as _course_code, course_name as _course_name from course c join department d on c.dept_code = d.dept_code
where not exists(
    select course_id from course cc
    where cc._year>c._year or (cc._year=c._year and cc.term>c.term)
) with data;

-- drop materialized view current_courses;
