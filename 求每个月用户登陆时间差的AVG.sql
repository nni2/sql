create table users (
id int,
month int,
ds date
);

insert into users values (1,1,'2018-01-02');
insert into users values (1,1,'2018-01-08');
insert into users values (1,3,'2018-03-04');
insert into users values (2,2,'2018-02-02');
insert into users values (2,2,'2018-02-20');
insert into users values (3,1,'2018-01-02');
insert into users values (3,1,'2018-01-09');
insert into users values (3,1,'2018-01-10');

--求每个月用户第一次和第二次登陆的时间差的平均值
with temp as (
select *,
       row_number() over(partition by month,id order by ds) as rnk
	  from users
)
select  f.month,
        avg(s.ds - f.ds) as time_diff
    from temp f
	join temp s
	on f.rnk = s.rnk - 1
    and f.rnk = 1
	and f.id = s.id
	and f.month = s.month
    group by 1;