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
values (1,'Extra Class');
insert into request_type(type_id, type_name)
values (2,'Class Test');

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

insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE423-2022',1);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE453-2022',2);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-HUM475-2022',3);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE405-2022',4);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE409-2022',5);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE410-2022',6);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE406-2022',7);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE421-2022',8);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE463-2022',9);
insert into section(section_no, section_name, course_id) values(default,'CSE-2017-B2-CSE408-2022',10);

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

insert into topic(topic_num, topic_name, instructor_id, finished, description)
values (default,'State-Space Modeling',1,false,'We learn making markov model here');

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (1,4,9,'20-08-2022 08:00:00','20-08-2022 08:40:00',20);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (5,6,8,current_timestamp,'20-08-2022 14:20:00',100);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (1,2,2,'22-08-2022 11:00:00','22-08-2022 11:40:00',20);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (2,6,8,'27-08-2022 15:00:00','27-08-2022 16:00:00',50);

insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks)
values (4,7,12,'28-08-2022 14:40:00','28-08-2022 15:40:00',20);


insert into evaluation(type_id, section_no, instructor_id, start, _end, total_marks, description)
values(5,1,1,current_timestamp,'2022-08-20 17:30:00 +06:00',20,'This is a bonus assignment')