create or replace view ses_v as
select
   sid,
   serial#,
   usr,
   usr_proxy,
   usr_os,
   ts_earliest_known,
   ts_latest_known,
   id,
   case when id = ses_mgmt.id then 'y' else 'n' end cur_ses
from
   ses;
