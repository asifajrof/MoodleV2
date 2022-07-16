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
        where instructor_id=old_ins_id;
        select course_id into section_course from section
        where section_no=old_sec_no;
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

create trigger evaluation_validation before insert or update on evaluation
     for each row execute function extra_class_check();

--drop trigger evaluation_validation on evaluation;
-- drop trigger extra_class_validation on extra_class;
-- drop function extra_class_check();
-- drop trigger teacher_routine_validation on teacher_routine;
-- drop function teacher_routine_check();
-- drop trigger cr_assignment on section;
-- drop function cr_assignment_check();
--drop function instructor_section_compare(new_ins_id integer, new_sec_no integer, old_ins_id integer, old_sec_no integer);
-- drop trigger instructor_assignment on instructor;
-- drop function instructor_check();

