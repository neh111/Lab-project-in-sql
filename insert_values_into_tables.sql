--���� �������:
insert into germs_tbl(nameG,dateG)
values('PASTI','01-JAN-97')

insert into germs_tbl(nameG,short_desc,dateG)
values('KA','very slim','22-MAY-97')

insert into germs_tbl(nameG,short_desc,dateG)
values('YOCUS','very old','30-JUL-98')

insert into germs_tbl(nameG,dateG)
values('KARUS','05-FEB-99')

insert into germs_tbl(nameG,dateG)
values('BAKTUS','18-MAY-99')

--���� ������:
insert into medicine_tbl
values('UNTI')

insert into medicine_tbl
values('ACAMOL')

insert into medicine_tbl
values('PENITZILIN')

insert into medicine_tbl
values('ASPARIN')

--����� ������ ����� ������
exec sp_addmessage 50001,17,'��� ����� ���� ���� ����� ������� �� ���� �� ��� ����� ����� ����� �������'

exec sp_addmessage 50002,17,'��� ����� ���� ���� ����� ������ �� ���� �� ��� ����� ������ ����� ������'

exec sp_addmessage 50003,17,'����� �� ����� ��� �� ����� ��'

exec sp_addmessage 50004,17,'dead,dying,alive:����� ����� ����, ���� ������ ��� ��������� �����'

exec sp_addmessage 50005,17,'����� ����,���� ������ �� ����� ����'

exec sp_addmessage 50006,17,'��� ���� �� ���� ���� ����� �������'

/*���� ������ ��� ��� �� ������ ��� �������*/