--����� �� ����� ������� �� ���� ������� ����� �� �� ���������� ���������
--���� ���� ������
select * from archive_tbl
--germ_id                                 germ_name            medicine_name        test_date               reaction_type
--------------------------------------- -------------------- -------------------- ----------------------- -------------
--1                                       PASTI                ACAMOL               2020-01-04 00:00:00.000 alive
--1                                       PASTI                ASPARIN              2021-01-01 00:00:00.000 alive
--1                                       PASTI                UNTI                 2016-05-12 00:00:00.000 dead
--2                                       KA                   ASPARIN              2020-01-01 00:00:00.000 dying
--2                                       KA                   UNTI                 2021-01-06 00:00:00.000 dead
--3                                       YOCUS                ACAMOL               2021-01-08 00:00:00.000 alive
--3                                       YOCUS                ASPARIN              2021-01-01 00:00:00.000 dying
--3                                       YOCUS                PENITZILIN           2020-10-06 00:00:00.000 alive
--5                                       BAKTUS               ACAMOL               2020-01-01 00:00:00.000 alive
--5                                       BAKTUS               ASPARIN              2020-01-01 00:00:00.000 dying
--5                                       BAKTUS               PENITZILIN           2021-01-06 00:00:00.000 dead

--���� ���� �������
select * from germs_tbl
--germ_id                                 nameG                short_desc           dateG      medicine_id                             medicine_date
--------------------------------------- -------------------- -------------------- ---------- --------------------------------------- -------------
--1                                       PASTI                NULL                 1997-01-01 1                                       2016-05-12
--2                                       KA                   very slim            1997-05-22 1                                       2021-01-06
--3                                       YOCUS                very old             1998-07-30 1                                       2020-05-03
--4                                       KARUS                NULL                 1999-02-05 NULL                                    NULL
--5                                       BAKTUS               NULL                 1999-05-18 3                                       2021-01-06
--���� ���� ������
select * from medicine_tbl
--medicine_id                             nameM
--------------------------------------- --------------------
--2                                       ACAMOL
--4                                       ASPARIN
--3                                       PENITZILIN
--1                                       UNTI
--���� ���� �������
select * from test_tbl
---germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--2                                       4                                       2021-01-01 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 alive
--4                                       4                                       2020-08-01 00:00:00.000 alive

--���� ����
select * from g_shuts_vw
--medicine_name        germ_name            date_finding_medicine
-------------------- -------------------- ---------------------
--UNTI                 PASTI                2016-05-12
--UNTI                 KA                   2021-01-06
--UNTI                 YOCUS                2020-05-03
--PENITZILIN           BAKTUS               2021-01-06

--���� ��� ������ �� �������� �������
alter view g_shuts_vw
as
select m.nameM as medicine_name,g.nameG as germ_name,g.medicine_date as date_finding_medicine 
from germs_tbl g join medicine_tbl m on g.medicine_id=m.medicine_id
/*�����*/
--1********************************************************************************************************
alter proc add_test_sql (@germ_name varchar(20),@medicine_name varchar(20),@test_date datetime,@reaction_type varchar(10)) as
begin
begin try
begin tran 
--����� ��� ������
declare @check_nameG int
select @check_nameG=germ_id from germs_tbl where nameG=@germ_name
if @check_nameG is null
 raiserror(50001,17,1)
 --����� ��� ������
declare @check_medicine int
select @check_medicine=medicine_id from medicine_tbl where nameM=@medicine_name
if @check_medicine is null
raiserror(50002,17,1)
--����� ��� ������ ��� ����� �� ����� ��
declare @is_exists int
select @is_exists=1 from test_tbl where germ_id=@check_nameG and medicine_id=@check_medicine
if @is_exists is not null
raiserror(50003,17,1)
--����� ������ ������
if @test_date>GETDATE()
raiserror(50005,17,1)
--����� ������ ������
if @reaction_type not in ('dead','dying','alive')
raiserror(50004,17,1)
--�� ��� �� �� ������� ����� �� ����� ����� �������
insert into test_tbl
values (@check_nameG,@check_medicine,@test_date,@reaction_type)
print '���� �� ���� ������'
--�� ����� ������ �� �� ������ �� �� ������ ������ ����� ������
if @reaction_type='dead'
begin
exec move_to_archive @check_nameG
end
commit tran
end try
begin catch
rollback tran
-- �� ��� �������� �� ���� ��������� ���� ���-�� ������� ����� ����� ������ ��� ������ �� ���� ������ ����� ��� �� ����� ������
declare @err varchar(200)
set @err=ERROR_PROCEDURE()+' - '+ERROR_MESSAGE()
print @err
insert into exception_tbl 
values (@err,GETDATE())
end catch
end

--����� �������� ���� ����� ����
exec add_test_sql 'baktus','asparin','01/01/20','dying'
--���� �� ���� ������

--����� ���� ���� �������
select * from test_tbl

--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--5                                       4                                       2020-01-01 00:00:00.000 dying
 
 --���� ���� ����� ����� ����
exec add_test_sql 'tersd','acamol','01/01/20','dying'

--add_test_sql - ��� ����� ���� ���� ����� ������� �� ���� �� ��� ����� ����� ����� �������

--����� ���� ���� �������
select * from test_tbl


--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--5                                       4                                       2020-01-01 00:00:00.000 dying

--���� ���� ����� ��� �����
exec add_test_sql 'ka','fengel','01/01/20','dying'

--add_test_sql - ��� ����� ���� ���� ����� ������ �� ���� �� ��� ����� ������ ����� ������

--����� ���� ���� �������
select * from test_tbl

--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--5                                       4                                       2020-01-01 00:00:00.000 dying


--���� �� ����� ����
exec add_test_sql 'yocus','asparin','01/01/20','met'

--add_test_sql - dead,dying,alive:����� ����� ����, ���� ������ ��� ��������� �����

--����� ���� ���� �������
select * from test_tbl

--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--5                                       4                                       2020-01-01 00:00:00.000 dying


--����� ������� ������


exec add_test_sql 'baktus','acamol','01/01/20','alive'
--���� �� ���� ������

--����� ���� ���� �������
select * from test_tbl

--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--5                                       2                                       2020-01-01 00:00:00.000 alive
--5                                       4                                       2020-01-01 00:00:00.000 dying

exec add_test_sql 'karus','penitzilin','10/18/2020','dying'
--���� �� ���� ������
exec add_test_sql 'ka','unti','01/06/2021','alive'
--���� �� ���� ������

--����� ���� ���� �������
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--2                                       1                                       2021-01-06 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 dying
--5                                       2                                       2020-01-01 00:00:00.000 alive
--5                                       4                                       2020-01-01 00:00:00.000 dying


--���� ���� ������� ���� ����� ��������� ���� ����� ��
--germ_id                                 nameG                short_desc           dateG      medicine_id                             medicine_date
--------------------------------------- -------------------- -------------------- ---------- --------------------------------------- -------------
--1                                       PASTI                NULL                 1997-01-01 NULL                                    NULL
--2                                       KA                   very slim            1997-05-22 NULL                                    NULL
--3                                       YOCUS                very old             1998-07-30 NULL                                    NULL
--4                                       KARUS                NULL                 1999-02-05 NULL                                    NULL
--5                                       BAKTUS               NULL                 1999-05-18 NULL                                    NULL

--���� ���� ������� ���� ����� ��������� �� ������ ��
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--2                                       1                                       2021-01-06 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 dying
--5                                       2                                       2020-01-01 00:00:00.000 alive
--5                                       4                                       2020-01-01 00:00:00.000 dying

--���� ���� ������ ���� ����� ��������� �� ����� ��
select * from archive_tbl
--germ_id                                 germ_name            medicine_name        test_date               reaction_type
--------------------------------------- -------------------- -------------------- ----------------------- -------------
--���� �� �������� �� ����� ����� ��
exec add_test_sql 'baktus','penitzilin','01/06/2021','dead'
--���� �� ���� ������
--���� ���� ������� ���� ����� ��������� �� ������ ��
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--2                                       1                                       2021-01-06 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 dying

--���� ���� ������ ���� ���� ��������� ���� ����� ����� ��
select * from archive_tbl
--germ_id                                 germ_name            medicine_name        test_date               reaction_type
--------------------------------------- -------------------- -------------------- ----------------------- -------------
--5                                       BAKTUS               ACAMOL               2020-01-01 00:00:00.000 alive
--5                                       BAKTUS               ASPARIN              2020-01-01 00:00:00.000 dying
--5                                       BAKTUS               PENITZILIN           2021-01-06 00:00:00.000 dead
--���� ���� ������� ���� ���� ��������� ���� ����� ��
select * from germs_tbl
--germ_id                                 nameG                short_desc           dateG      medicine_id                             medicine_date
--------------------------------------- -------------------- -------------------- ---------- --------------------------------------- -------------
--1                                       PASTI                NULL                 1997-01-01 NULL                                    NULL
--2                                       KA                   very slim            1997-05-22 NULL                                    NULL
--3                                       YOCUS                very old             1998-07-30 NULL                                    NULL
--4                                       KARUS                NULL                 1999-02-05 NULL                                    NULL
--5                                       BAKTUS               NULL                 1999-05-18 3                                       2021-01-06

--���� �� ����� ���� ����� �� �������
exec add_test_sql 'pasti','acamol','01/04/2020','dying'
--���� �� ���� ������

--���� �� ����� ���� ��� ���� �� �������
exec add_test_sql 'yocus','asparin','01/01/2021','dying'
--���� �� ���� ������

exec add_test_sql 'ka','asparin','01/01/2021','alive'
--���� �� ���� ������

--���� ���� ������� ���� ����� �������� ��"�
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       2                                       2020-01-04 00:00:00.000 dying
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       4                                       2021-01-01 00:00:00.000 alive
--3                                       1                                       2020-05-03 00:00:00.000 alive
--3                                       4                                       2021-01-01 00:00:00.000 dying
--4                                       3                                       2020-10-18 00:00:00.000 alive

--2**********************************************************************************************************
alter proc update_status (@germ_id numeric,@medicine_id numeric,@new_status varchar(10)) as
begin
begin try
begin tran
--����� ��� ��� ����� ���� ����� ��������
declare @is_exists int
select @is_exists=1 from test_tbl where germ_id=@germ_id and medicine_id=@medicine_id
if @is_exists is null
raiserror(50006,17,1)
--����� ��� ����� ������ ����
if @new_status not in ('dead','dying','alive')
raiserror(50004,17,1)
--����� ����� ������
update test_tbl set reaction_type=@new_status 
where germ_id=@germ_id and medicine_id=@medicine_id
--����� ������� ��
if @new_status='dead'
begin
--����� ������ ������� ����� �������� ������� ������ ������ ���� ������� ����� ����� ���
--exec move_to_archive @germ_id
print '����� ����� ������ ��,��� ����� ������� ����� ����� �������'
end
commit tran
end try
begin catch
rollback tran
--�� ��� �������� ���� ��������� ���� ���-��,����� ����� ����� ������ ����� ����� ����
declare @num_err int =@@ERROR,@err varchar(200)=error_message()
print @err
if @num_err>50000
insert into exception_tbl 
values (@err,GETDATE())
end catch
end
/*�����*/
-----------------------------------------------------------------------------------------------------------
--���� ���� ������� ���� ���� ��������� ������ ����� ����� ���
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       1                                       2021-01-06 00:00:00.000 alive
--2                                       4                                       2020-01-01 00:00:00.000 dying
--3                                       1                                       2020-05-03 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 dying

--���� ��������� ������ ����� ����� ���
exec update_status '4','3','alive'
--���� ���� ������� ���� ���� ��������� ������ ����� ����� ���
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       1                                       2021-01-06 00:00:00.000 alive
--2                                       4                                       2020-01-01 00:00:00.000 dying
--3                                       1                                       2020-05-03 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 alive
--

--���� ���� ������� ���� ���� ��������� ������ ����� ����� �����
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       1                                       2021-01-06 00:00:00.000 alive
--2                                       4                                       2020-01-01 00:00:00.000 dying
--3                                       1                                       2020-05-03 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 alive
--���� ��������� ������ ����� ����� �����
exec update_status '2','1','dying'
--���� ���� ������� ���� ���� ��������� ������ ����� ����� �����
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       1                                       2021-01-06 00:00:00.000 dying
--2                                       4                                       2020-01-01 00:00:00.000 dying
--3                                       1                                       2020-05-03 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 alive
--���� ���� ������� ���� ���� ��������� ������ ����� ����� ���
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       1                                       2021-01-06 00:00:00.000 dying
--2                                       4                                       2020-01-01 00:00:00.000 dying
--3                                       1                                       2020-05-03 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 alive
--���� ���� ������� ���� ���� ��������� ������ ����� ����� ���
select * from germs_tbl
--germ_id                                 nameG                short_desc           dateG      medicine_id                             medicine_date
--------------------------------------- -------------------- -------------------- ---------- --------------------------------------- -------------
--1                                       PASTI                NULL                 1997-01-01 NULL                                    NULL
--2                                       KA                   very slim            1997-05-22 NULL                                    NULL
--3                                       YOCUS                very old             1998-07-30 NULL                                    NULL
--4                                       KARUS                NULL                 1999-02-05 NULL                                    NULL
--5                                       BAKTUS               NULL                 1999-05-18 3                                       2021-01-06
--���� ���� ������ ���� ���� ��������� ������ ����� ����� ���
select * from archive_tbl
--germ_id                                 germ_name            medicine_name        test_date               reaction_type
--------------------------------------- -------------------- -------------------- ----------------------- -------------
--5                                       BAKTUS               ACAMOL               2020-01-01 00:00:00.000 alive
--5                                       BAKTUS               ASPARIN              2020-01-01 00:00:00.000 dying
--5                                       BAKTUS               PENITZILIN           2021-01-06 00:00:00.000 dead
--���� ��������� ������ ����� ����� ���
exec update_status '2','1','dead'
--���� ���� ������� ���� ���� ��������� ������ ����� ����� ���
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       4                                       2021-01-01 00:00:00.000 alive
--3                                       1                                       2020-05-03 00:00:00.000 alive
--4                                       3                                       2020-10-18 00:00:00.000 alive
--���� ���� ������� ���� ���� ��������� ������ ����� ����� ���
select * from germs_tbl
--germ_id                                 nameG                short_desc           dateG      medicine_id                             medicine_date
--------------------------------------- -------------------- -------------------- ---------- --------------------------------------- -------------
--1                                       PASTI                NULL                 1997-01-01 NULL                                    NULL
--2                                       KA                   very slim            1997-05-22 1                                       2021-01-06
--3                                       YOCUS                very old             1998-07-30 NULL                                    NULL
--4                                       KARUS                NULL                 1999-02-05 NULL                                    NULL
--5                                       BAKTUS               NULL                 1999-05-18 3                                       2021-01-06
--���� ���� ������ ���� ���� ��������� ������ ����� ����� ���
select * from archive_tbl
--germ_id                                 germ_name            medicine_name        test_date               reaction_type
--------------------------------------- -------------------- -------------------- ----------------------- -------------
--2                                       KA                   ASPARIN              2020-01-01 00:00:00.000 dying
--2                                       KA                   UNTI                 2021-01-06 00:00:00.000 dead
--5                                       BAKTUS               ACAMOL               2020-01-01 00:00:00.000 alive
--5                                       BAKTUS               ASPARIN              2020-01-01 00:00:00.000 dying
--5                                       BAKTUS               PENITZILIN           2021-01-06 00:00:00.000 dead





--exc 3*******************************************************************************************************
alter proc move_to_archive (@germ_id numeric) as
begin
--����� �������� �� �� ������ ������ ������ ������
declare @medicine_id numeric,@test_date datetime
select @medicine_id=t.medicine_id,@test_date=t.test_date  from test_tbl t  where t.germ_id=@germ_id and t.reaction_type='dead'
update germs_tbl set medicine_id=@medicine_id,medicine_date=@test_date where germ_id=@germ_id 
--����� �������
insert into archive_tbl select t.germ_id,g.nameG,m.nameM,t.test_date,t.reaction_type
from Test_tbl t join Medicine_tbl m on t.medicine_id=m.medicine_id join Germs_tbl g on t.germ_id=g.germ_id where t.germ_id=@germ_id
--����� ��������
delete from Test_tbl where germ_id=@germ_id
end
-------------------------------------------------------------------------------------------------------------

--4A****************************************************************************************************
alter proc staying_alive (@germ_id numeric,@medicine_id numeric) as
begin
--����� ����� �����
declare @test_date datetime
select @test_date=test_date from test_tbl where germ_id=@germ_id and medicine_id=@medicine_id
--�� ��� ���� �������� ����� ������ ���
if DATEDIFF(mm,@test_date,GETDATE())>2
exec update_status @germ_id,@medicine_id,'alive'
end


--���� ���� ������� ���� ���� ��������� ������ ����� ����� ����� ��� ���� ����� ����� ���� ����� �� �������
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       2                                       2020-01-04 00:00:00.000 dying
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       4                                       2021-01-01 00:00:00.000 alive
--3                                       1                                       2020-05-03 00:00:00.000 alive
--3                                       2                                       2021-01-08 00:00:00.000 alive
--3                                       4                                       2021-01-01 00:00:00.000 dying
--4                                       3                                       2020-10-18 00:00:00.000 alive
--���� ��������� ������ ����� ����� ����� ��� ���� ����� ����� ����
exec staying_alive 1,2
--���� ���� ������� ���� ���� ��������� ������ ����� ����� ����� ��� ���� ����� ����� ���� ����� �� �������
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       2                                       2020-01-04 00:00:00.000 alive
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       4                                       2021-01-01 00:00:00.000 alive
--3                                       1                                       2020-05-03 00:00:00.000 alive
--3                                       2                                       2021-01-08 00:00:00.000 alive
--3                                       4                                       2021-01-01 00:00:00.000 dying
--4                                       3                                       2020-10-18 00:00:00.000 alive


 --4B**********************************************************************************************************
 /*�� ���� �� ���� �������!*/
 alter proc staying_alive_by_cursor as
 begin
declare @germ_id numeric,@medicine_id numeric,@reaction_type varchar(10)
declare src cursor
--���� �� ������ ����� �"� ���
for select germ_id,medicine_id,reaction_type from test_tbl t
open src
fetch next from src into @germ_id,@medicine_id,@reaction_type
while @@FETCH_STATUS=0
begin
--���� ������ ����
if @reaction_type='dying'
exec staying_alive @germ_id,@medicine_id
fetch next from src into @germ_id,@medicine_id,@reaction_type
end
close src
deallocate src
end
--���� ���� ������� ���� ���� ���������
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       2                                       2020-01-04 00:00:00.000 alive
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       4                                       2021-01-01 00:00:00.000 alive
--3                                       1                                       2020-05-03 00:00:00.000 alive
--3                                       2                                       2021-01-08 00:00:00.000 alive
--3                                       3                                       2020-10-06 00:00:00.000 dying
--3                                       4                                       2021-01-01 00:00:00.000 dying
--4                                       3                                       2020-10-18 00:00:00.000 alive
--4                                       4                                       2020-08-01 00:00:00.000 dying
--���� ���������
exec staying_alive_by_cursor
--���� ���� ������� ���� ���� ���������
select * from test_tbl
--germ_id                                 medicine_id                             test_date               reaction_type
--------------------------------------- --------------------------------------- ----------------------- -------------
--1                                       2                                       2020-01-04 00:00:00.000 alive
--1                                       4                                       2021-01-01 00:00:00.000 alive
--2                                       4                                       2021-01-01 00:00:00.000 alive
--3                                       1                                       2020-05-03 00:00:00.000 alive
--3                                       2                                       2021-01-08 00:00:00.000 alive
--3                                       3                                       2020-10-06 00:00:00.000 alive
--3                                       4                                       2021-01-01 00:00:00.000 dying
--4                                       3                                       2020-10-18 00:00:00.000 alive
--4                                       4                                       2020-08-01 00:00:00.000 alive

--6*************************************************************************************************************
--����� ������ �������� �� �� ������ ����� �� ������� ���� ������ ����� ������ ����� ���� ��
alter trigger treat_for_dead_germ on test_tbl
for update,insert
as
begin
if(update(reaction_type))
begin
if(select reaction_type from inserted)='dead'
begin
declare @germ_id numeric 
select @germ_id=germ_id from inserted
exec move_to_archive @germ_id
end
end
end
go

--����� ����� ������ ����� ������� ��
insert into test_tbl
values(1,1,'05/12/2016','dead')

--����� ����� ����� ���
update test_tbl 
set reaction_type='dead'
where germ_id='3' and medicine_id='1'

--7************************************************************************************************************
alter function test_to_germ (@germ_id numeric) 
returns int
as
begin
 declare @count int=0
 --������ �� ���� ������ ������� ����
 select @count+=1 from test_tbl where germ_id=@germ_id
 if @count=0
 --�� �� ���� �������� ������ �������
 select @count+=1 from archive_tbl where germ_id=@germ_id
 return @count
end

--���� ��������
declare @num_experiments numeric=dbo.Test_to_germ(5)
print @num_experiments
--3


--8************************************************************************************************************
alter function germ_for_shut (@medicine_name varchar(20))
returns table as
return (select germ_id,germ_name from archive_tbl where medicine_name=@medicine_name and reaction_type='dead')
----����� ������
select * from dbo.germ_for_shut('UNTI')
--germ_id                                 germ_name
--------------------------------------- --------------------
--2                                       KA


--9**********************************************************************************************************
alter function germ_most_prensistent ()
returns @t table (germ_name varchar(20),count_apears int) as
begin
declare @max_test int,@max_archive int
--���� �� ���� �������� ����� ����� ����� �������
select top 1 @max_test=count(*) from test_tbl t group by t.germ_id order by count(*) desc
--���� �� ���� �������� ����� ����� ����� ������
select top 1 @max_archive=count(*) from archive_tbl a group by a.germ_id order by count(*) desc
--���� �� �� ������ ����� �����
if @max_test=@max_archive
begin
insert into @t
select g.nameG,count(*) from test_tbl t join germs_tbl g on t.germ_id=g.germ_id group by g.nameG having count(*)=@max_test
union 
select germ_name,count(*) from archive_tbl group by germ_name having count(*)=@max_archive
end
else
begin
if @max_test>@max_archive
begin
insert into @t
select g.nameG,count(*) from test_tbl t join germs_tbl g on t.germ_id=g.germ_id group by g.nameG having count(*)=@max_test
end
else
begin
insert into @t
select germ_name,count(*) from archive_tbl group by germ_name having count(*)=@max_archive
end
end
return 
end
--����� ��������
select * from dbo.germ_most_prensistent()
--germ_name            count_apears
-------------------- ------------
--BAKTUS               3
--YOCUS                3

--***************************************������ �������********************************************
--�� ����� ���� ������ �� ����� ����� ����� ������ ������� �� �������� ����� �� ����
--Invalid column name 'germid'
--�� ����� germid �� ����

--There is already an object named 'archive_tbl' in the database.
--�� ��� ������ ��� archive_tbl ���� ������

--Could not create constraint or index
--�� ���� ����� ����� �� ������

--Incorrect syntax near the keyword 'select'
--����� ���� ��� ��� ����� select

--The INSERT statement conflicted with the FOREIGN KEY constraint "FK__test_tbl__medici__40F9A68C". The conflict occurred in database "Lab_db", table "dbo.medicine_tbl", column 'medicine_id'
--����� �-insert ������ �� ����� ���� ��� ������ ����� ���� ������� lab_db ����� medicine_tbl ������ medicine_id

--Violation of PRIMARY KEY constraint 'PK_archive_tbl'. Cannot insert duplicate key in object 'dbo.archive_tbl'. The duplicate key value is (2, ASPARIN).
--���� �� ����� ���� PRIMARY 'PK_archive_tbl'. �� ���� ������ ���� ���� �������� 'dbo.archive_tbl'. ��� ����� ����� ��� (2, ASPARIN).
/*

���� ���� 
������ �����
���� �� ���� ������ �� �����
��� �� ��� ����� ���� ������ ������ �����
������ �������
������ ������  ��� 
*/