insert into department(dept_code, dept_shortname, dept_name)
values (1,'Arch','Architecture');

insert into department(dept_code, dept_shortname, dept_name)
values (2,'ChE','Chemical Engineering');

insert into department(dept_code, dept_shortname, dept_name)
values (4,'CE','Civil Engineering');

insert into department(dept_code, dept_shortname, dept_name)
values (5,'CSE','Computer Science and Engineering');

insert into department(dept_code, dept_shortname, dept_name)
values (6,'EEE','Electrical and Electronic Engineering');

insert into department(dept_code, dept_shortname, dept_name)
values (8,'IPE','Industrial and Production Engineering');

insert into department(dept_code, dept_shortname, dept_name)
values (10,'ME','Mechanical Engineering');

insert into department(dept_code, dept_shortname, dept_name)
values (11,'MME','Materials and Metallurgical Engineering');

insert into department(dept_code, dept_shortname, dept_name)
values (15,'URP','Urban and Regional Planning');

insert into department(dept_code, dept_shortname, dept_name)
values (18,'BME','Biomedical Engineering');

do
$$
begin
    execute add_admin('Nazmul Haque','nazmuladmin','$2a$12$a3sA/qgphlpSnjZl2EkaW.EvlHrTbsrX8ZjD1iqJzqZgYLdkPXmAy',null);
end;
$$;


do
$$
begin
    execute add_student('Md. Shariful','$2a$12$BjvAnEmgjQsjLxPmFsD8Peh7H0DV49ZiXZisriA/IZ92ySlPJc1p.',119,5,2017,null);
end;
$$;

do
$$
begin
    execute add_course('Fault Tolerant Systems',23,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('High Performance Database System',53,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_teacher('A.B.M. Alim Al Islam','alimrazi','$2a$12$vJa9O6JwQkfILdYj5bSsCuVbeSC863/MIe7x1UZM0qU7iPcwfewB2',5,null);
end
$$;

insert into section(section_no, section_name, course_id)
values(default,'CSE-2017-B2-CSE423-2022',1);

insert into enrolment(student_id, section_id)
values (1,1);

insert into course_routine(section_no, alternation, start, _end, day) values (1,7,'8:00','10:00',0);
