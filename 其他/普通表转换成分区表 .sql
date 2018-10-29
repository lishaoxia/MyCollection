--0.原始表 
select * from partitest;

--1.创建分区表

create table PARTITEST_PART
(
    RECID            RAW(16)                      NOT NULL,
    RECVER           NUMBER(19)                   DEFAULT 0,
    UNITID           RAW(16)                      NOT NULL,
    DATATIME         NVARCHAR2(10)                NOT NULL,
    FLOATORDER       NUMBER(23,5)                 NOT NULL,
    PARTITEST_CODE1  NVARCHAR2(50),
    PARTITEST_ZB1    NUMBER(10),
    PARTITEST_ZB2    NUMBER(10)
)
partition by list(PARTITEST_CODE1)(
    partition P01 values ('01') tablespace SNP,
    partition P02 values ('02') tablespace SNP,
    partition P03 values ('03') tablespace SNP

  );
);

--2.重命名原表T为T_OLD
rename partitest to partitest_old;

--*3.直接路径插入(空表可以跳过此步)
	
insert into PARTITEST_PART p select /*+ parallel(n,10) */ * from partitest_old n;

--*4.为分区表建立索引(可以跳过此步，重启系统dna会自动建索引)

--*4.1 重命名历史表的索引名
	
alter index PK_PARTITEST rename to PK_PARTITEST_bak;
alter table partitest_old rename constraint PK_PARTITEST to PK_PARTITEST_bak;
alter index LK_PARTITEST rename to LK_PARTITEST_bak;

--*4.2 给新分区表T_PART创建主键及索引
create unique index PK_PARTITEST on PARTITEST_PART(RECID,PARTITEST_CODE1) local;

alter table PARTITEST_PART add constraint PK_PARTITEST primary key (RECID,PARTITEST_CODE1);

	
create index LK_PARTITEST on PARTITEST_PART (UNITID, DATATIME, FLOATORDER);

--5.rename表，恢复T表的相关应用
	
rename PARTITEST_PART to PARTITEST;

--根据实际情况决定是否彻底drop掉T_OLD，释放空间。
	
drop table PARTITEST_OLD;

--查看分区
SELECT partitioned FROM user_tables WHERE table_name = 'PARTITEST';

SELECT partition_name FROM user_tab_partitions WHERE table_name = 'PARTITEST';

select * from SNP_R604  PARTITION (SNPFQ11)
