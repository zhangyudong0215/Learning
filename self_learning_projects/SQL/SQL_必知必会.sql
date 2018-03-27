# 注释1
select * 
from dp_relation.ec_raw_data
limit 100; # 注释2
/* 注释3
   注释4 */

select * 
from mytable
limit 100
;

select * 
from mytable
where location = '湖北'
limit 100
;

delete from mytable
where location = '湖北'
limit 100
;

select *
from mytable
order by length(content) desc, id asc
limit 100
;

select count(id)
from ec_raw_data
;

select *
from mytable
where id between 10 and 100
;

select count(id)
from mytable
where id not in 
(select id
from dp_relation.ec_raw_data)
;

select *
from mytable
where location like '湖%'
;

select rate*content_id as temp
from mytable
limit 100
;

select 
concat(trim(content_id), '(', trim(content), ')')
as
id_content
from mytable
limit 100
;

select id, content_id, length(content)
from mytable
limit 100
;

select created_at
from mytable
limit 100
;

select created_at, 
day(created_at), 
hour(created_at), 
minute(created_at)
from mytable
limit 100
;

select *
from mytable
limit 100
;

select avg(distinct length(content)) as avg_len_content
from mytable
;

select max(length(content))
from mytable
;

select project_id, count(*) as num
from mytable
group by project_id
;

select project_id, count(*) as num
from mytable
where project_id > 30
group by project_id
having count(*) >= 10000
order by num desc
;

select *
from mytable
where id in (
    select id
    from ec_raw_data
)
limit 100
;

select count(*)
from mytable
where project_id = (
                     select project_id
                     from mytable
                     where id = 1
                     )
;

select count(*)
from mytable as t1, mytable as t2
where t1.project_id = t2.project_id and t1.id = 1
;



