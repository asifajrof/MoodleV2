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
