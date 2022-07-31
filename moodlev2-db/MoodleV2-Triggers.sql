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

create or replace function evaluation_check() returns trigger as $evaluation_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
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
$extra_teacher_validation$ language plpgsql;

create trigger extra_teacher_validation before insert or update on extra_class_teacher
     for each row execute function extra_teacher_check();

create or replace function request_event_check() returns trigger as $request_event_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
        raise exception 'Invalid data insertion or update';
    end if;
    return new;
end;
$request_event_validation$ language plpgsql;

create trigger request_event_validation before insert or update on request_event
     for each row execute function request_event_check();

create or replace function notification_event_check() returns trigger as $notification_event_validation$
declare
begin
    if (instructor_section_compare(new.instructor_id,new.section_no,old.instructor_id,old.section_no)) then
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
-- drop trigger teacher_routine_validation on teacher_routine;
-- drop function teacher_routine_check();
-- drop trigger cr_assignment on section;
-- drop function cr_assignment_check();
-- drop function instructor_section_compare(new_ins_id integer, new_sec_no integer, old_ins_id integer, old_sec_no integer);
-- drop trigger instructor_assignment on instructor;
-- drop function instructor_check();

