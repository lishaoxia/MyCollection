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

/*�����*/
analyze table MD_ORG compute statistics;


/*�鿴�����ı�*/
select object_name as ��������,s.sid,s.serial#,p.spid as ϵͳ���̺�,l.oracle_username,l.os_user_name,l.PROCESS
from v$locked_object l , dba_objects o , v$session s , v$process p
where l.object_id=o.object_id and l.session_id=s.sid and s.paddr=p.addr;

--alter system kill session 'sid,serial#' immediate; 
alter system kill session '1542,7' immediate; 

select * from v$session order by username, osuser



--��ѯOracle����ִ�е�sql��估ִ�и������û�
SELECT b.sid oracleID,
       b.username ��¼Oracle�û���,
       b.serial#,
       spid ����ϵͳID,
       paddr,
       sql_text ����ִ�е�SQL,
       b.machine �������
FROM v$process a, v$session b, v$sqlarea c
WHERE a.addr = b.paddr
   AND b.sql_hash_value = c.hash_value
and b.username = 'SNPFQ'

--�鿴����ִ��sql�ķ����ߵķ��ų���
SELECT OSUSER ���Ե�¼���,
       PROGRAM ��������ĳ���,
       USERNAME ��¼ϵͳ���û���,
       SCHEMANAME,
       B.Cpu_Time ����cpu��ʱ��,
       STATUS,
       B.SQL_TEXT ִ�е�sql
FROM V$SESSION A
LEFT JOIN V$SQL B ON A.SQL_ADDRESS = B.ADDRESS
                   AND A.SQL_HASH_VALUE = B.HASH_VALUE
ORDER BY b.cpu_time DESC
--���oracle��ǰ�ı�������
SELECT l.session_id sid,
       s.serial#,
       l.locked_mode ��ģʽ,
       l.oracle_username ��¼�û�,
       l.os_user_name ��¼�����û���,
       s.machine ������,
       s.terminal �ն��û���,
       o.object_name ����������,
       s.logon_time ��¼���ݿ�ʱ��
FROM v$locked_object l, all_objects o, v$session s
WHERE l.object_id = o.object_id
   AND l.session_id = s.sid
ORDER BY sid, s.serial#;

--��ѯoracle��ǰδ�ύ������
select a.sid,a.blocking_session,a.last_call_et,a.event,
object_name,
dbms_rowid.rowid_create(1,data_object_id,rfile#,ROW_WAIT_BLOCK#,ROW_WAIT_ROW#) "rowid" ,
c.sql_text,c.sql_fulltext
from v$session a,v$sqlarea c ,dba_objects,v$datafile
where a.blocking_session is not null
and a.sql_hash_value = c.hash_value 
and ROW_WAIT_OBJ#=object_id and file#=ROW_WAIT_FILE#;

--kill����ǰ�����������Ϊ
alter system kill session 'sid�� s.serial#';

--��ѯoracle��ǰδ�رյ��α�
select v.*, s.SQL_TEXT  from v$open_cursor v 
inner join v$sql s on v.SQL_ID = s.SQL_ID and v.USER_NAME = s.PARSING_SCHEMA_NAME
where v.USER_NAME = 'SNPFQ' and v.CURSOR_TYPE = 'OPEN';


--��ѯ�Ƿ������� 
select * from v$locked_object; 
