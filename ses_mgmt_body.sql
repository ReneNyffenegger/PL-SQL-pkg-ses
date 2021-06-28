create or replace package body ses_mgmt as
 --
 -- Version 0.1
 --

    g_id  integer;

    function id return integer is
       pragma autonomous_transaction;

       ret integer;
    begin
        if g_id is not null then
           return g_id;
        end if;

        insert into ses (
            sid,
            serial#,
            usr,
            usr_proxy,
            usr_os,
            ts_earliest_known,
            ts_latest_known
        )
        values (
            dbms_debug_jdwp.current_session_id     , -- sys_context('userenv', 'sid') ||
            dbms_debug_jdwp.current_session_serial ,
            user                                   , -- sys_context('userenv', 'session_user') ,
            sys_context('userenv', 'proxy_user'  ) ,
            sys_context('userenv', 'os_user'     ) ,
            sysdate,
            sysdate
        ) returning id into ret;

        commit;

        return ret;
    exception when dup_val_on_index then
        if regexp_like(sqlerrm, 'ORA-00001: unique constraint \(([^.]+).SES_UQ\) violated') then
        --
        -- Necessary if package is 'recompiled' ...
        --
           select id into g_id from ses where sid = dbms_debug_jdwp.current_session_id and serial# = dbms_debug_jdwp.current_session_serial;
           return g_id;
        end if;

        raise;

    --  log_mgmt.exc;
    end id;

    procedure ping is
       pragma autonomous_transaction;
    begin
       update ses set ts_latest_known = sysdate where id = g_id;
       commit;
    end ping;

begin

    g_id := id;

end ses_mgmt;
/
