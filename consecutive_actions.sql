with recursive src as (
  SELECT user_id, filing_id, extract(year from filing_date) yr 
  FROM filed_taxes
  WHERE lower(product) like 'turbotax%'
)
,iter as (
  select s1.user_id, yr, cast(null as numeric) as prev_yr, 1 as depth
  from src s1
  where not exists (select 1 from src s2 where s1.user_id = s2.user_id and s2.yr = s1.yr - 1)
  UNION ALL
  select s.user_id, s.yr, i.yr prev_yr, i.depth + 1 depth
  from src s
  inner join iter i on s.user_id = i.user_id and i.yr + 1 = s.yr
)
select * from iter
order by 1, 2;
