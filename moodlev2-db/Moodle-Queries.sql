insert into evaluation_type(type_id, type_name, notification_time_type)
values (1,'Class Test',false);

insert into evaluation_type(type_id, type_name, notification_time_type)
values (2,'Lab Quiz',false);

insert into evaluation_type(type_id, type_name, notification_time_type)
values (3,'Lab Test',false);

insert into evaluation_type(type_id, type_name, notification_time_type)
values (4,'Online Evaluation',false);

insert into evaluation_type(type_id, type_name, notification_time_type)
values (5,'Assignment',true);

insert into request_type(type_id, type_name)
values (1,'Schedule');
insert into request_type(type_id, type_name)
values (2,'Reschedule');
insert into request_type(type_id, type_name)
values (3,'Confirm');

insert into visibility(type_id, type_name) values(1,'All');
insert into visibility(type_id, type_name) values(2,'Only Student');
insert into visibility(type_id, type_name) values(3,'Only Teacher');
insert into visibility(type_id, type_name) values(4,'Only CR');
insert into notification_type(type_id, type_name, visibility) values(1,'New Declaration',2);
insert into notification_type(type_id, type_name, visibility) values(2,'Updated Declaration',2);
insert into notification_type(type_id, type_name, visibility) values(3,'New Schedule Request',4);
insert into notification_type(type_id, type_name, visibility) values(4,'Updated Schedule Request',4);
insert into notification_type(type_id, type_name, visibility) values(5,'New Reschedule Request',3);
insert into notification_type(type_id, type_name, visibility) values(6,'Updated Reschedule Request',3);


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
values (7,'HUM','Humanities');

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
    execute add_student('Fatima Nawmi','$2y$10$/q5rPYxPDEDi14Hp33AgfOjhuF8mglmjqBnyN58zN17L4hJ4Oclpu',93,5,2017,null);
end;
$$;

do
$$
begin
    execute add_student('Asif Ajrof','$2y$10$pYUj/gnwUYpkBdWQiXi3buA8rVAE3EFSJbd2FSQuWkAEAF3SZqGPW',92,5,2017,null);
end;
$$;


do
$$
begin
    execute add_student('Saif Ahmed Khan','$2y$10$nCoBIjkAYSLLwLW8tDe4Ku3Ud.TkJvViq62cGQ.dkfmpl3XqavsvW',110,5,2017,null);
end;
$$;

do
$$
begin
    execute add_student('Nazmul Takbir','$2y$10$iVzkVjUWBYUKA2rcPz83BubHExrrr0guL5nEZHrK4GdZj8PzRZQd.',103,5,2017,null);
end;
$$;

do
$$
begin
    execute add_student('Sihat Afnan','$2y$10$WoVLtw9ux4j13piNbC3df.UKBJwO7wFVmLzfbqzZeNBc8NE3ierLO',98,5,2017,null);
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
    execute add_course('Engineering Economics',75,7,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('Computer Security',5,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('Computer Graphics',9,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('Computer Graphics Sessional',10,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('Computer Security Sessional',6,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('Basic Graph Theory',21,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('Introduction to Bioinformatics',63,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_course('Software Development Sessional',8,5,5,2017,2022,4,1);
end;
$$;

do
$$
begin
    execute add_teacher('A.B.M. Alim Al Islam','alimrazi','$2a$12$vJa9O6JwQkfILdYj5bSsCuVbeSC863/MIe7x1UZM0qU7iPcwfewB2',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Abdullah Adnan','aadnan','$2y$10$L6jbTLAvrMo385LUib9Kuuq/1WICpx8DeedZxIksHLpgFofFghvN6',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Saidur Rahman','saidur','$2y$10$ZkKqecSnPUJgjSUXXcOSx..O6qtR0pLz0oCg/meyB4p095aZIW046',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Saifur Rahman','saifur','$2y$10$sq9aDXP6AjBqLScZXDNLLeXlBO/ZFwdACr/dKkkNr8nkaQt7WersW',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Shasuzzoha Bayzid','bayzid','$2y$10$rjCuLnyfxwa.G0T25nYAEOaT9PtycCHCQkbHfyB2.CKYT.weLhOKi',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Nafiz Irtiza Tripto','nitripto','$2y$10$dF1UOgEjzsJp5OrEOA2iX.HYfNkymt6u4iRrGB3djf3UCB86Yokzm',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Shadman Saquib Eusuf','ssaquib','$2y$10$ad4lVnOcqGx8KErwAC8rAOmEp1k1lscWbN8GK2EJyrJ3/wRFYjye.',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Shohrab Hossain','shohrab','$2y$10$SVVpQ96Dt5INs5hYsKGV9.eubbFqVcZfYacJUkKfYOmZHhjo.K/D6',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Syed Md. Mukit Rashid','mukit','$2y$10$gOihrq.ujsthj3e/F2zYHeLOvWQ9ttsGXPF7y6cWKeDcV.YZqEcn2',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Munshi Abdur Rauf','munshi','$2y$10$xDzSGa1czBolnsKuxRR03uh351f3IXVwiolW6MFWHLcIb3Mc.bxT2',7,null);
end
$$;

do
$$
begin
    execute add_teacher('Rony Hossain','rony','$2y$10$mmpvLgBk3iH/sVzzraCFSud8K13vxxhcKTs6bbUlryqUFsIyoTK5O',7,null);
end
$$;

do
$$
begin
    execute add_teacher('Rayhan Rashed','rayhan','$2y$10$/lW3WMDdlJjlaE/0OKDQuO/2pVDuyPzbokm661Jnt/1n6gmLdw1dm',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Tahmid Hasan','htahmid','$2y$10$tkSap6H/ofZrQotGQXNJ9uFvLjms/UoYgTEyIvDkhERxUudQieY/u',5,null);
end
$$;

do
$$
begin
    execute add_teacher('Mohammad Tawhidul Hasan Bhuiyan','thbhuiyan','$2y$10$8SPbFCvBQC9j8gsuQ.GKxOGfyNW/.Pchhs87L6k8PUu9oS0NZa/Li',5,null);
end
$$;

select add_student('Asif Ahmed Utsa','$2a$10$lBeXHGXhEDafsT.gqowElOiLVQIAA5YTiGO2PTY4VpqlJpGe96yzy',84,5,2017,null);
select add_student('Apurba Saha','$2a$10$lBeXHGXhEDafsT.gqowElOiLVQIAA5YTiGO2PTY4VpqlJpGe96yzy',56,5,2017,null);
select add_student('Rasman Mubtasim Swargo','$2a$10$lBeXHGXhEDafsT.gqowElOiLVQIAA5YTiGO2PTY4VpqlJpGe96yzy',51,5,2017,null);
select add_student('Md. Sabbir Rahman','$2a$10$lBeXHGXhEDafsT.gqowElOiLVQIAA5YTiGO2PTY4VpqlJpGe96yzy',76,5,2017,null);
select add_student('Tanzim Hossain Romel','$2a$10$lBeXHGXhEDafsT.gqowElOiLVQIAA5YTiGO2PTY4VpqlJpGe96yzy',69,5,2017,null);
select add_student('Sheikh Azizul Hakim','$2a$10$lBeXHGXhEDafsT.gqowElOiLVQIAA5YTiGO2PTY4VpqlJpGe96yzy',2,5,2017,null);
select add_student('Mahdi Hasnat Siyam','$2a$10$lBeXHGXhEDafsT.gqowElOiLVQIAA5YTiGO2PTY4VpqlJpGe96yzy',3,5,2017,null);

insert into section(section_no, section_name, course_id) values(default,'CSE-2017-CSE423-2022',1);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-CSE453-2022',2);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B-HUM475-2022',3);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B-CSE405-2022',4);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B-CSE409-2022',5);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE410-2022',6);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE406-2022',7);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B-CSE421-2022',8);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B-CSE463-2022',9);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE408-2022',10);
insert into section (section_no, section_name, course_id, cr_id) values (default,'CSE-2017-A-CSE405-2022',4,null);
insert into section (section_no, section_name, course_id, cr_id) values (default,'CSE-2017-A-CSE409-2022',5,null);
insert into section (section_no, section_name, course_id, cr_id) values (default,'CSE-2017-A-HUM475-2022',3,null);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-A1-CSE-406',7);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-A2-CSE-406',7);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-B1-CSE-406',7);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-A1-CSE-408',10);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-A2-CSE-408',10);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-B1-CSE-408',10);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-A1-CSE-410',6);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-A2-CSE-410',6);
insert into section(section_no, section_name, course_id) values (default,'CSE-2017-B1-CSE-410',6);

insert into enrolment(student_id, section_id) values (1,1);
insert into enrolment(student_id, section_id) values (1,2);
insert into enrolment(student_id, section_id) values (1,3);
insert into enrolment(student_id, section_id) values (1,4);
insert into enrolment(student_id, section_id) values (1,5);
insert into enrolment(student_id, section_id) values (1,6);
insert into enrolment(student_id, section_id) values (1,7);

insert into enrolment(student_id, section_id) values (5,1);
insert into enrolment(student_id, section_id) values (5,2);
insert into enrolment(student_id, section_id) values (5,3);
insert into enrolment(student_id, section_id) values (5,4);
insert into enrolment(student_id, section_id) values (5,5);
insert into enrolment(student_id, section_id) values (5,6);
insert into enrolment(student_id, section_id) values (5,7);

insert into enrolment(student_id, section_id) values (2,2);
insert into enrolment(student_id, section_id) values (2,9);
insert into enrolment(student_id, section_id) values (2,3);
insert into enrolment(student_id, section_id) values (2,4);
insert into enrolment(student_id, section_id) values (2,5);
insert into enrolment(student_id, section_id) values (2,6);
insert into enrolment(student_id, section_id) values (2,7);

insert into enrolment(student_id, section_id) values (6,1);
insert into enrolment(student_id, section_id) values (6,2);
insert into enrolment(student_id, section_id) values (6,3);
insert into enrolment(student_id, section_id) values (6,4);
insert into enrolment(student_id, section_id) values (6,5);
insert into enrolment(student_id, section_id) values (6,6);
insert into enrolment(student_id, section_id) values (6,7);

insert into enrolment(student_id, section_id) values (3,1);
insert into enrolment(student_id, section_id) values (3,8);
insert into enrolment(student_id, section_id) values (3,3);
insert into enrolment(student_id, section_id) values (3,4);
insert into enrolment(student_id, section_id) values (3,5);
insert into enrolment(student_id, section_id) values (3,6);
insert into enrolment(student_id, section_id) values (3,7);

insert into enrolment(student_id, section_id) values (4,1);
insert into enrolment(student_id, section_id) values (4,9);
insert into enrolment(student_id, section_id) values (4,3);
insert into enrolment(student_id, section_id) values (4,4);
insert into enrolment(student_id, section_id) values (4,5);
insert into enrolment(student_id, section_id) values (4,6);
insert into enrolment(student_id, section_id) values (4,7);

insert into enrolment(student_id, section_id) values (1,10);
insert into enrolment(student_id, section_id) values (2,10);
insert into enrolment(student_id, section_id) values (3,10);
insert into enrolment(student_id, section_id) values (4,10);
insert into enrolment(student_id, section_id) values (5,10);
insert into enrolment(student_id, section_id) values (6,10);

insert into enrolment(student_id, section_id) values (7,2);
insert into enrolment(student_id, section_id) values (7,3);
insert into enrolment(student_id, section_id) values (7,4);
insert into enrolment(student_id, section_id) values (7,5);
insert into enrolment(student_id, section_id) values (7,9);
insert into enrolment(student_id, section_id) values (7,18);
insert into enrolment(student_id, section_id) values (7,21);
insert into enrolment(student_id, section_id) values (7,24);

insert into enrolment(student_id, section_id) values (10,2);
insert into enrolment(student_id, section_id) values (10,3);
insert into enrolment(student_id, section_id) values (10,4);
insert into enrolment(student_id, section_id) values (10,5);
insert into enrolment(student_id, section_id) values (10,9);
insert into enrolment(student_id, section_id) values (10,18);
insert into enrolment(student_id, section_id) values (10,21);
insert into enrolment(student_id, section_id) values (10,24);

insert into enrolment(student_id, section_id) values (11,2);
insert into enrolment(student_id, section_id) values (11,3);
insert into enrolment(student_id, section_id) values (11,4);
insert into enrolment(student_id, section_id) values (11,5);
insert into enrolment(student_id, section_id) values (11,1);
insert into enrolment(student_id, section_id) values (11,18);
insert into enrolment(student_id, section_id) values (11,21);
insert into enrolment(student_id, section_id) values (11,24);

insert into enrolment(student_id, section_id) values (8,2);
insert into enrolment(student_id, section_id) values (8,9);
insert into enrolment(student_id, section_id) values (8,11);
insert into enrolment(student_id, section_id) values (8,13);
insert into enrolment(student_id, section_id) values (8,14);
insert into enrolment(student_id, section_id) values (8,17);
insert into enrolment(student_id, section_id) values (8,20);
insert into enrolment(student_id, section_id) values (8,23);

insert into enrolment(student_id, section_id) values (9,2);
insert into enrolment(student_id, section_id) values (9,1);
insert into enrolment(student_id, section_id) values (9,11);
insert into enrolment(student_id, section_id) values (9,13);
insert into enrolment(student_id, section_id) values (9,14);
insert into enrolment(student_id, section_id) values (9,17);
insert into enrolment(student_id, section_id) values (9,20);
insert into enrolment(student_id, section_id) values (9,23);

insert into enrolment(student_id, section_id) values (13,2);
insert into enrolment(student_id, section_id) values (13,9);
insert into enrolment(student_id, section_id) values (13,11);
insert into enrolment(student_id, section_id) values (13,13);
insert into enrolment(student_id, section_id) values (13,14);
insert into enrolment(student_id, section_id) values (13,16);
insert into enrolment(student_id, section_id) values (13,19);
insert into enrolment(student_id, section_id) values (13,22);

insert into enrolment(student_id, section_id) values (12,8);
insert into enrolment(student_id, section_id) values (12,9);
insert into enrolment(student_id, section_id) values (12,11);
insert into enrolment(student_id, section_id) values (12,13);
insert into enrolment(student_id, section_id) values (12,14);
insert into enrolment(student_id, section_id) values (12,16);
insert into enrolment(student_id, section_id) values (12,19);
insert into enrolment(student_id, section_id) values (12,22);

insert into instructor(instructor_id, teacher_id, course_id) values (default,1,1);
insert into instructor(instructor_id, teacher_id, course_id) values (default,2,2);
insert into instructor(instructor_id, teacher_id, course_id) values (default,10,3);
insert into instructor(instructor_id, teacher_id, course_id) values (default,11,3);
insert into instructor(instructor_id, teacher_id, course_id) values (default,6,5);
insert into instructor(instructor_id, teacher_id, course_id) values (default,7,5);
insert into instructor(instructor_id, teacher_id, course_id) values (default,6,6);
insert into instructor(instructor_id, teacher_id, course_id) values (default,7,6);
insert into instructor(instructor_id, teacher_id, course_id) values (default,8,4);
insert into instructor(instructor_id, teacher_id, course_id) values (default,9,4);
insert into instructor(instructor_id, teacher_id, course_id) values (default,8,7);
insert into instructor(instructor_id, teacher_id, course_id) values (default,9,7);
insert into instructor(instructor_id, teacher_id, course_id) values (default,4,9);
insert into instructor(instructor_id, teacher_id, course_id) values (default,5,9);
insert into instructor(instructor_id, teacher_id, course_id) values (default,3,8);
insert into instructor(teacher_id, course_id) values (12,10);
insert into instructor(teacher_id, course_id) values (13,10);
insert into instructor(teacher_id, course_id) values (14,10);

insert into course_routine(section_no, alternation, start, _end, day) values (1,7,'8:00','10:00',0);
insert into course_routine(section_no, alternation, start, _end, day) values (1,7,'10:00','11:00',6);

insert into course_routine(section_no, alternation, start, _end, day) values (2,7,'09:00','10:00',5);
insert into course_routine(section_no, alternation, start, _end, day) values (2,7,'11:00','12:00',6);
insert into course_routine(section_no, alternation, start, _end, day) values (2,7,'11:00','12:00',0);

insert into course_routine(section_no, alternation, start, _end, day) values (9,7,'12:00','13:00',5);
insert into course_routine(section_no, alternation, start, _end, day) values (9,7,'12:00','13:00',6);
insert into course_routine(section_no, alternation, start, _end, day) values (9,7,'12:00','13:00',0);

insert into course_routine(section_no, alternation, start, _end, day) values(3,7,'10:00:00','11:00:00',5);
insert into course_routine(section_no, alternation, start, _end, day) values(3,7,'08:00:00','09:00:00',6);
insert into course_routine(section_no, alternation, start, _end, day) values(3,7,'09:00:00','10:00:00',2);

insert into course_routine(section_no, alternation, start, _end, day) values(4,7,'09:00:00','10:00:00',6);
insert into course_routine(section_no, alternation, start, _end, day) values(4,7,'09:00:00','10:00:00',1);
insert into course_routine(section_no, alternation, start, _end, day) values(4,7,'08:00:00','09:00:00',2);

insert into course_routine(section_no, alternation, start, _end, day) values(5,7,'11:00:00','12:00:00',5);
insert into course_routine(section_no, alternation, start, _end, day) values(5,7,'08:00:00','09:00:00',1);
insert into course_routine(section_no, alternation, start, _end, day) values(5,7,'10:00:00','11:00:00',2);

insert into course_routine(section_no, alternation, start, _end, day) values(8,7,'10:00:00','11:00:00',0);
insert into course_routine(section_no, alternation, start, _end, day) values(8,7,'10:00:00','11:00:00',1);
insert into course_routine(section_no, alternation, start, _end, day) values(8,7,'11:00:00','12:00:00',2);

insert into course_routine(section_no, alternation, start, _end, day) values(6,14,'14:00:00','17:00:00',5);
insert into course_routine(section_no, alternation, start, _end, day) values(7,14,'14:00:00','17:00:00',6);
insert into course_routine(section_no, alternation, start, _end, day) values(10,7,'14:00:00','17:00:00',0);

insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,11,7,'08:00:00','09:00:00',6);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,11,7,'08:00:00','09:00:00',1);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,11,7,'09:00:00','10:00:00',2);

insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,13,7,'10:00:00','11:00:00',5);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,13,7,'09:00:00','10:00:00',1);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,13,7,'08:00:00','09:00:00',2);

insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,14,7,'11:00:00','12:00:00',5);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,14,7,'09:00:00','10:00:00',6);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,14,7,'10:00:00','11:00:00',2);

insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,16,7,'14:00:00','17:00:00',0);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,17,7,'14:00:00','17:00:00',0);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,18,7,'14:00:00','17:00:00',6);

insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,19,7,'14:00:00','17:00:00',6);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,20,7,'14:00:00','17:00:00',6);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,21,7,'14:00:00','17:00:00',0);

insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,22,7,'14:00:00','17:00:00',2);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,23,7,'14:00:00','17:00:00',2);
insert into course_routine(class_id, section_no, alternation, start, _end, day)
values (default,24,7,'14:00:00','17:00:00',5);

insert into teacher_routine(teacher_class_id, instructor_id, class_id) values(default,1,1);
insert into teacher_routine(instructor_id, class_id) values(1,2);

insert into teacher_routine(instructor_id, class_id) values (2,3);
insert into teacher_routine(instructor_id, class_id) values (2,4);
insert into teacher_routine(instructor_id, class_id) values (2,5);

insert into teacher_routine(instructor_id, class_id) values (3,9);
insert into teacher_routine(instructor_id, class_id) values (4,10);
insert into teacher_routine(instructor_id, class_id) values (3,11);

insert into teacher_routine(instructor_id, class_id) values (9,12);
insert into teacher_routine(instructor_id, class_id) values (9,13);
insert into teacher_routine(instructor_id, class_id) values (9,14);

insert into teacher_routine(instructor_id, class_id) values (6,15);
insert into teacher_routine(instructor_id, class_id) values (6,16);
insert into teacher_routine(instructor_id, class_id) values (6,17);

insert into teacher_routine(instructor_id, class_id) values (8,21);
insert into teacher_routine(instructor_id, class_id) values (7,21);

insert into teacher_routine(instructor_id, class_id) values (11,22);
insert into teacher_routine(instructor_id, class_id) values (12,22);

insert into teacher_routine(instructor_id, class_id) values (15,18);
insert into teacher_routine(instructor_id, class_id) values (15,19);
insert into teacher_routine(instructor_id, class_id) values (15,20);

insert into teacher_routine(instructor_id, class_id) values (14,6);
insert into teacher_routine(instructor_id, class_id) values (14,7);
insert into teacher_routine(instructor_id, class_id) values (14,8);

insert into teacher_routine(instructor_id, class_id) values (16,23);
insert into teacher_routine(instructor_id, class_id) values (17,23);
insert into teacher_routine(instructor_id, class_id) values (18,23);

insert into teacher_routine(instructor_id, class_id) values (3,30);
insert into teacher_routine(instructor_id, class_id) values (4,31);
insert into teacher_routine(instructor_id, class_id) values (3,32);

insert into teacher_routine(instructor_id, class_id) values (6,27);
insert into teacher_routine(instructor_id, class_id) values (6,28);
insert into teacher_routine(instructor_id, class_id) values (6,29);

insert into teacher_routine(instructor_id, class_id) values (9,24);
insert into teacher_routine(instructor_id, class_id) values (9,25);
insert into teacher_routine(instructor_id, class_id) values (9,26);

insert into topic(topic_num, topic_name, instructor_id, finished, description)
values (default,'State-Space Modeling',1,false,'We learn making markov model here');

select add_course_topic('Introduction',4,'shohrab','This is an introductory chapter',true);
select add_course_topic('Computer Forensics',4,'shohrab','We will know about different methods about detecting crimes',true);
select add_course_topic('Web Security',4,'mukit','Security issues while browsing web',false);
select add_course_topic('View Projection',5,'nitripto',null,true);
select add_course_topic('Rasterizaton',5,'ssaquib',null,false);
select add_course_topic('Query Processing',2,'aadnan',null,true);
select add_course_topic('Query Optimization',2,'aadnan',null,false);
select add_course_topic('Economic Parameters',3,'rony',null,true);
select add_course_topic('Microeconimy Features',3,'munshi',null,false);
select add_course_topic('Bipartite Graphs',8,'saidur',null,true);
select add_course_topic('K-connectivity',8,'saidur',null,false);
select add_course_topic('Genome Sequencing',9,'saifur',null,true);
select add_course_topic('Phylogenetic Tree',9,'bayzid',null,false);
select add_course_topic('Cryptography',7,'mukit',null,true);
select add_course_topic('Buffer Overflow',7,'shohrab',null,true);


insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (1,4,9,'30-08-2022 08:00:00','30-08-2022 08:40:00',20);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (5,6,8,current_timestamp,'27-08-2022 14:20:00',100);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (1,2,2,'22-08-2022 11:00:00','22-08-2022 11:40:00',20);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (2,6,8,'27-08-2022 15:00:00','27-08-2022 16:00:00',50);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (4,7,12,'28-08-2022 14:40:00','28-08-2022 15:40:00',20);


insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks, description)
values(5,1,1,current_timestamp,'2022-08-27 17:30:00 +06:00',20,'This is a bonus assignment')

select add_course_post(1,'alimrazi',false,'Class Test Marks','Here is class test marks',null);
select add_course_post(1,'1705119',true,'Marks Not Found','Sir, I attended the test but the document shows me absent',2);
select add_course_post(1,'alimrazi',false,'Correction','Your marks has been added',3);
