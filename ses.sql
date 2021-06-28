create table ses (
   sid                integer         not null,
   serial#            integer         not null,
   usr                varchar2(128)   not null,  -- session user / user @ log$gjJ
   usr_proxy          varchar2(128)       null,
   usr_os             varchar2(128)   not null,
   ts_earliest_known  date            not null,
   ts_latest_known    date            not null,
   id                 integer         generated always as identity,
   --
   constraint ses_pk primary key (id),
   constraint ses_uq unique(sid, serial#)
);
