UPDATE META_DW_BLOCK T SET T.MDB_ISCREATETAB = 1 WHERE T.MDB_ISCREATETAB = 0 AND T.MDB_GUID = 'hh'

select * from  v$session where terminal='unknown' and  osuser = 'lianghaojun' and username != 'BI_METADS'

select * from v$session where saddr = '1BAFC404' and terminal='unknown'

select a.sid ||' is blocking '||b.sid from v$lock a,v$Lock b where a.id1=b.id1 and a.id2=b.id2 and a.block=1 and b.request>0;

select * from  v$lock

select /*+ NO_MERGE(a) NO_MERGE(b) NO_MERGE(c) */ a.username, a.machine, a.sid, a.serial#, a.last_call_et "Seconds", b.id1, c.sql_text "SQL"
from v$session a, v$lock b, v$sqltext c
where a.username is not null and a.lockwait = b.kaddr and c.hash_value =a.sql_hash_value

select /*+ NO_MERGE(a) NO_MERGE(b) NO_MERGE(c) */ a.username, a.machine, a.sid, a.serial#, a.last_call_et "Seconds", b.id1, c.sql_text "SQL"
from v$session a, v$lock b, v$sqltext c
where c.sql_text like '%META_DW_BLOCK%'

select * from  v$session where terminal='unknown' and  osuser = 'lianghaojun' and username != 'BI_METADS';

select * from  v$sqltext a 
where a.ADDRESS in (select sql_address from  v$session where terminal='unknown' and  osuser = 'lianghaojun' and username != 'BI_METADS');

select * from  v$lock

select * from  v$sqltext a 
where a.ADDRESS in (select sql_address from  v$session where terminal='unknown' and  osuser = 'zhanghui' and username = 'BI_METADS');

/*表分析*/
analyze table MD_ORG compute statistics;


/*查看被锁的表*/
select object_name as 对象名称,s.sid,s.serial#,p.spid as 系统进程号,l.oracle_username,l.os_user_name,l.PROCESS
from v$locked_object l , dba_objects o , v$session s , v$process p
where l.object_id=o.object_id and l.session_id=s.sid and s.paddr=p.addr;

--alter system kill session 'sid,serial#' immediate; 
alter system kill session '1542,7' immediate; 

select * from v$session order by username, osuser



--查询Oracle正在执行的sql语句及执行该语句的用户
SELECT b.sid oracleID,
       b.username 登录Oracle用户名,
       b.serial#,
       spid 操作系统ID,
       paddr,
       sql_text 正在执行的SQL,
       b.machine 计算机名
FROM v$process a, v$session b, v$sqlarea c
WHERE a.addr = b.paddr
   AND b.sql_hash_value = c.hash_value
and b.username = 'SNPFQ'

--查看正在执行sql的发起者的发放程序
SELECT OSUSER 电脑登录身份,
       PROGRAM 发起请求的程序,
       USERNAME 登录系统的用户名,
       SCHEMANAME,
       B.Cpu_Time 花费cpu的时间,
       STATUS,
       B.SQL_TEXT 执行的sql
FROM V$SESSION A
LEFT JOIN V$SQL B ON A.SQL_ADDRESS = B.ADDRESS
                   AND A.SQL_HASH_VALUE = B.HASH_VALUE
ORDER BY b.cpu_time DESC
--查出oracle当前的被锁对象
SELECT l.session_id sid,
       s.serial#,
       l.locked_mode 锁模式,
       l.oracle_username 登录用户,
       l.os_user_name 登录机器用户名,
       s.machine 机器名,
       s.terminal 终端用户名,
       o.object_name 被锁对象名,
       s.logon_time 登录数据库时间
FROM v$locked_object l, all_objects o, v$session s
WHERE l.object_id = o.object_id
   AND l.session_id = s.sid
ORDER BY sid, s.serial#;

--查询oracle当前未提交的事务
select a.sid,a.blocking_session,a.last_call_et,a.event,
object_name,
dbms_rowid.rowid_create(1,data_object_id,rfile#,ROW_WAIT_BLOCK#,ROW_WAIT_ROW#) "rowid" ,
c.sql_text,c.sql_fulltext
from v$session a,v$sqlarea c ,dba_objects,v$datafile
where a.blocking_session is not null
and a.sql_hash_value = c.hash_value 
and ROW_WAIT_OBJ#=object_id and file#=ROW_WAIT_FILE#;

--kill掉当前的锁对象可以为
alter system kill session 'sid， s.serial#';

--查询oracle当前未关闭的游标
select v.*, s.SQL_TEXT  from v$open_cursor v 
inner join v$sql s on v.SQL_ID = s.SQL_ID and v.USER_NAME = s.PARSING_SCHEMA_NAME
where v.USER_NAME = 'SNPFQ' and v.CURSOR_TYPE = 'OPEN';


--查询是否有死锁 
select * from v$locked_object; 
