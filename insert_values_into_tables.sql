--טבלת חיידקים:
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

--טבלת תרופות:
insert into medicine_tbl
values('UNTI')

insert into medicine_tbl
values('ACAMOL')

insert into medicine_tbl
values('PENITZILIN')

insert into medicine_tbl
values('ASPARIN')

--הוספת שגיאות לטבלת שגיאות
exec sp_addmessage 50001,17,'קוד חיידק אינו נמצא בטבלת חיידקים נא הכנס רק קוד חיידק שנמצא בטבלת חיידקים'

exec sp_addmessage 50002,17,'קוד תרופה אינו נמצא בטבלת תרופות נא הכנס רק קוד תרופה שנמצאת בטבלת תרופות'

exec sp_addmessage 50003,17,'תרופה זו נוסתה כבר על חיידק זה'

exec sp_addmessage 50004,17,'dead,dying,alive:סטטוס הנסוי שגוי, ניתן להכניס אחד מהסטטוסים הבאים'

exec sp_addmessage 50005,17,'תאריך שגוי,עליך להכניס רק תאריך שחלף'

exec sp_addmessage 50006,17,'קוד נסוי זה אינו קיים בטבלת ניסויים'

/*אפשר להכניס בבת אחת עם פסיקים בין הסוגרים*/