SELECT * FROM studscoreinfo;
SELECT * FROM studinfo;
SELECT * FROM courseinfo;
SELECT * FROM classinfo;

#清空数据
#DELETE FROM studinfo;
#DELETE FROM studscoreinfo;
#DELETE FROM classinfo;
#DELETE FROM courseinfo;
#删除表
DROP TABLE chinesestudinfo;

Drop Table studinfo
CREATE TABLE StudInfo(
	StudNo VARCHAR(15) PRIMARY KEY COMMENT '学号',
	StudName VARCHAR(20) NOT NULL COMMENT '姓名',
	StudGender CHAR(2) NOT NULL COMMENT '性别' DEFAULT '男'
		CHECK (StudGender IN ('男','女')) DEFAULT '男',
	StudBirthday DATE NULL COMMENT '生日',
	ClassID VARCHAR(10) NOT NULL COMMENT '班级编号',
		CONSTRAINT FOREIGN KEY(ClassID)
		REFERENCES ClassInfo(ClassID)
);
ENGINE=INNODB DEFAULT CHARSET=utf8;

drop table classinfo
CREATE TABLE ClassInfo(
	ClassID VARCHAR(10) PRIMARY KEY COMMENT '班级编号',
	ClassName VARCHAR(50) NOT NULL COMMENT '班级名称',
	ClassDesc VARCHAR(100) NULL COMMENT '班级描述'

);
ENGINE=INNODB DEFAULT CHARSET=utf8;

CREATE TABLE CourseInfo(
	CourseID VARCHAR(15) PRIMARY KEY COMMENT '课程编号',
	CourseName VARCHAR(50) NOT NULL COMMENT '课程名称',
	CourseType VARCHAR(10) NOT NULL COMMENT '课程类别',
	CourseCredit DECIMAL(3,1) NOT NULL COMMENT '课程学分',
	CourseDesc VARCHAR(100) NULL COMMENT '课程评价'
	);
ENGINE=INNODB DEFAULT CHARSET=utf8;

DROP TABLE STUDSCOREINFO
CREATE TABLE StudScoreInfo(
	StudNo VARCHAR(15) COMMENT '学号',
	CourseID VARCHAR(15)  COMMENT '课程编号',
	StudScore DECIMAL(4,1) NOT NULL CHECK (StudScore>=0 and StudScore<=100) COMMENT '学生成绩',
		#CHECK (StudScore IN(StudScore>=0 and StudScore<=100)),
		PRIMARY KEY (STUDNO,COURSEID)
		#CONSTRAINT PRIMARY KEY(StudNo,CourseID)
	);
ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO studinfo VALUES('20191152001','黄华','男','2000-01-01','20191152');
INSERT INTO studinfo VALUES('20191152002','朱江','男','1999-08-19','20191152');
INSERT INTO studinfo VALUES('20191152003','李四','女','2000-02-20','20191152');
INSERT INTO studinfo VALUES('20191152004','刘强','男','2000-03-04','20191152');
INSERT INTO studinfo VALUES('20191152005','张三','女','2000-04-07','20191152');

INSERT INTO classinfo VALUES('20191152','computer2019','very good');
INSERT INTO classinfo VALUES('20201152','computer2020','that’s right');

INSERT INTO studscoreinfo VALUES('20191152001','A000004','75.0');
INSERT INTO studscoreinfo VALUES('20191152001','A010001','66.0');
INSERT INTO studscoreinfo VALUES('20191152001','A010012','71.0');
INSERT INTO studscoreinfo VALUES('20191152002','A000001','80.0');
INSERT INTO studscoreinfo VALUES('20191152002','A000004','85.0');

UPDATE studscoreinfo 
SET StudScore='82'
WHERE StudNo='20191152001' AND CourseID='A010001';

UPDATE studinfo 
SET StudName='刘刚',StudGender='女',ClassID='20201152'
WHERE StudNo='20191152004';

DELETE FROM studinfo 
WHERE StudNo='20191152005';

SELECT * 
FROM studinfo 
WHERE StudNo='20191152003';

###############################################

SELECT *
FROM studinfo LIMIT 0,10;


SELECT *
FROM studscoreinfo
ORDER BY StudScore DESC 
LIMIT 0,100;

#查询重名方法1：
SELECT * ,
	COUNT(*) StudName
FROM studinfo
GROUP BY StudName;
#查询重名方法2：
SELECT DISTINCT *
FROM studinfo
GROUP BY StudName;

CREATE TABLE chinesestudinfo
AS
SELECT StudName AS 姓名,
			 StudNo AS 学号,
			 StudGender AS 性别,
			 ClassID AS 班级编号
FROM studinfo;

SELECT *
FROM studscoreinfo
WHERE StudNo='20191152001';

SELECT *
FROM studscoreinfo
WHERE studno='20191152001' AND studscore>80;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE
BETWEEN 80 AND 90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE>=80 AND STUDSCORE<=90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE
NOT BETWEEN 80 AND 90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE<80 OR STUDSCORE>90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE
BETWEEN 60 AND 70
OR STUDSCORE
BETWEEN 80 AND 90;

SELECT *
FROM STUDSCOREINFO
WHERE STUDSCORE>=80 AND STUDSCORE<=90
OR STUDSCORE>=60 AND STUDSCORE<=70;

SELECT *
FROM COURSEINFO
WHERE COURSENAME
LIKE '计算机%';

SELECT *
FROM studinfo
WHERE StudName
LIKE '%丽%';

SELECT *
FROM studinfo
WHERE StudName
LIKE '__丽';

#不及格人数
SELECT StudNo,
			 COUNT(*) countscore
FROM studscoreinfo
WHERE StudScore<60
GROUP BY StudNo
HAVING COUNT(*)>20;

#计算平均分
SELECT  StudNo, 
			  AVG(StudScore) AS 平均分
FROM studscoreinfo
GROUP BY StudNo;

#总分加课程门数
SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
		   COUNT(*) count
FROM studscoreinfo
GROUP BY StudNo;

#多表查询
SELECT studinfo.StudNo,
			 StudName,
			 StudScore,
			 ClassID
FROM studinfo,
		 studscoreinfo;

SELECT studinfo.StudNo,
			 studinfo.StudName,
			 classinfo.ClassID,
			 classinfo.ClassName,
			 courseinfo.CourseID,
			 courseinfo.CourseName,
			 studscoreinfo.StudScore
FROM studinfo,
		 studscoreinfo,
		 classinfo,
		 courseinfo;
		 
SELECT studinfo.StudNo,
			 studinfo.StudName,
			 studinfo.StudGender,
			 studscoreinfo.StudScore
FROM studinfo,
		 studscoreinfo
WHERE studinfo.StudGender='女';

#单条筛选
SELECT StudNo,
		   SUM(StudScore),
			 AVG(StudScore),
			 COUNT(*) CourseID
FROM studscoreinfo
WHERE StudNo = '20180712001';

SELECT studinfo.*,
			 studscoreinfo.*,
			 AVG(studscoreinfo.StudScore) 平均分,
		   COUNT(*) 课程门数
FROM studscoreinfo,
		 studinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo,studinfo.StudName
HAVING 课程门数>10 AND AVG(studscoreinfo.StudScore)>=75 AND AVG(studscoreinfo.StudScore)<=80
#IN子句查询
SELECT *
FROM studinfo
WHERE StudNo IN(SELECT StudNo
						 FROM studscoreinfo
						 GROUP BY StudNo
			       HAVING COUNT(*)>10 AND AVG(StudScore)>=75 AND AVG(StudScore)<=80);

#选择平均分最高的前10人：
SELECT studinfo.*,
			 AVG(studscoreinfo.StudScore) 平均分,
			 COUNT(*) 课程门数,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分
FROM classinfo,
		 studinfo,
		 studscoreinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
AND studinfo.ClassID=classinfo.ClassID
GROUP BY studinfo.StudNo
ORDER BY 平均分 DESC
LIMIT 0,10;

SELECT studinfo.StudNo 学号,
			 studinfo.StudName 姓名,
			 AVG(studscoreinfo.StudScore) 平均分,
			 COUNT(*) 课程门数,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分
FROM studinfo,
		 studscoreinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo
ORDER BY 平均分 DESC;

SELECT studscoreinfo.StudNo,
			 courseinfo.CourseName 课程名称, 
			 AVG(studscoreinfo.StudScore) 平均分,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分,
			 COUNT(*) 所修人数
FROM courseinfo,
		 studscoreinfo
WHERE courseinfo.CourseID=studscoreinfo.CourseID
GROUP BY studscoreinfo.CourseID
ORDER BY 平均分 DESC;

CREATE TABLE StudCourseScoreInfo
AS
SELECT studscoreinfo.StudNo,
			 courseinfo.CourseName 课程名称, 
			 AVG(studscoreinfo.StudScore) 平均分,
			 MAX(studscoreinfo.StudScore) 最高分,
			 MIN(studscoreinfo.StudScore) 最低分,
			 COUNT(*) 所修人数
FROM courseinfo,
		 studscoreinfo
WHERE courseinfo.CourseID=studscoreinfo.CourseID
GROUP BY studscoreinfo.CourseID
ORDER BY 平均分 DESC;

SELECT *
FROM studinfo 
WHERE StudNo IN(SELECT StudNo
						 FROM studinfo
						 GROUP BY StudName
						 HAVING COUNT(*)>1);
					
#####################################
SELECT *
FROM studscoreinfo
WHERE StudScore BETWEEN 80 AND 90
UNION ALL
SELECT *
FROM studscoreinfo
WHERE StudScore BETWEEN 60 AND 70;

SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo
GROUP BY StudNo;

SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo
GROUP BY StudNo
HAVING AVG(StudScore) BETWEEN 60 AND 70;

SELECT studinfo.StudNo,
			 studinfo.StudName,
  		 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo,
		 studinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo
HAVING AVG(StudScore) BETWEEN 90 AND 100
OR AVG(StudScore) BETWEEN 60 AND 70;

#关联表查询
SELECT studinfo.*,
  		 AVG(StudScore)
FROM studscoreinfo,
		 studinfo
WHERE studinfo.StudNo=studscoreinfo.StudNo
GROUP BY studscoreinfo.StudNo
HAVING AVG(StudScore)>=80 AND StudGender='女';
#IN子句查询
SELECT *
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore)>=80)
HAVING StudGender='女';

#统计个分数段的人数
SELECT '优秀' 等级, COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 90 AND 100)
UNION
SELECT '良好',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 80 AND 90)
UNION
SELECT '一般',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 70 AND 80)
UNION
SELECT '及格',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore) BETWEEN 60 AND 70)
UNION
SELECT '不及格',COUNT(*) 人数
FROM studinfo
WHERE StudNo IN(
			SELECT StudNo
			FROM studscoreinfo
			GROUP BY StudNo
			HAVING AVG(StudScore)<60);

SELECT STUDNO,STUDNAME,STUDGENDER,CLASSINFO.ClassName
FROM studinfo,Classinfo
WHERE STUDINFO.ClassID=CLASSINFO.ClassID
AND StudNo IN(
			SELECT studno
			FROM studscoreinfo
			WHERE studscore<60
			GROUP BY studno
			HAVING count(*)>10
			);

/*课程类别为 A、B、C、D11、D12 为基础课和专业课，即统称为学位课，请统计
“计科 2019”班的各学生学位课的平均分、总分、所修课程的数目、最高分、最低分*/
SELECT StudNo,
			 AVG(StudScore),
			 SUM(StudScore),
			 COUNT(*),
			 MAX(StudScore),
			 MIN(StudScore)
FROM studscoreinfo
WHERE courseid IN (
			SELECT courseid
			FROM courseinfo
			WHERE coursetype='A' OR coursetype='B'OR coursetype='C'OR coursetype='D11'OR coursetype='C12')
GROUP BY studno
HAVING studno IN (
			SELECT studno
			FROM studinfo,classinfo
			WHERE studinfo.ClassID=classinfo.ClassID AND classname='计科2019');


SELECT studscoreinfo.courseid,coursename,AVG(studscore),COUNT(*) 参考人数
FROM studscoreinfo,courseinfo
WHERE studscoreinfo.CourseID=courseinfo.CourseID
GROUP BY courseid
HAVING AVG(studscore)>80 AND COUNT(*)>30;

#统计课程成绩在 80 分以上的各学生平均分的 SQL 语句
SELECT studscoreinfo.studno,studinfo.StudName,courseid AS 80分以上课程,AVG(studscore) 80分以上课程学生平均分
FROM studscoreinfo,studinfo
WHERE studscoreinfo.StudNo=studinfo.StudNo
AND courseid IN (
			SELECT studscoreinfo.courseid
			FROM studscoreinfo,courseinfo
			WHERE studscoreinfo.CourseID=courseinfo.CourseID
			GROUP BY courseid
			HAVING AVG(studscore)>80)
GROUP BY studscoreinfo.studNo;

##################################
SELECT s.studno,
		   studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo AS s INNER JOIN studscoreinfo si 
ON s.studno=si.studno;
#左连接
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s LEFT JOIN studscoreinfo si 
ON s.studno=si.studno;
#右连接
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s RIGHT JOIN studscoreinfo si 
ON s.studno=si.studno;
#全连接
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s LEFT JOIN studscoreinfo si 
ON s.studno=si.studno;
UNION 
SELECT s.studno,
			 studname,
			 studgender,
			 si.courseid,
			 studscore
FROM studinfo s RIGHT JOIN studscoreinfo si 
ON s.studno=si.studno;


SELECT c.courseid,
			 c.coursename,
			 sum(studscore),
			 round(avg(studscore),2),
			 max(studscore),
			 min(studscore),
			 count(*)
FROM courseinfo c INNER JOIN studscoreinfo si 
ON c.courseid=si.courseid
GROUP BY courseid;


SHOW CREATE VIEW V_GetCourseScore
AS
SELECT c.courseid,
			 c.coursename,
			 sum(studscore),
			 round(avg(studscore),2),
			 max(studscore),
			 min(studscore),
			 count(*) 
FROM courseinfo c INNER JOIN studscoreinfo si 
ON c.courseid=si.courseid
GROUP BY courseid;
SELECT *
FROM v_getcoursescore
WHERE coursescore>=30 AND coursescore<=50;
#DESC V_GETCOURSESCORE


CREATE VIEW V_GetAllStudInfo
AS
SELECT s.studno,
			 studname,
			 s.studgender,
			 s.classid,
			 c.classname,
			 ci.coursename,
			 ci.courseid,
			 si.studscore
FROM studinfo s INNER JOIN studscoreinfo si 
ON s.studno=si.studno
INNER JOIN classinfo c 
ON s.classid=c.classid 
INNER JOIN courseinfo ci
ON ci.courseid=si.courseid 
GROUP BY studno,
				 courseid,
				 classid;

SELECT *
FROM v_getallstudinfo


SELECT s.studno,
			 studname,
			 studgender,
			 sum(si.studscore),
			 max(si.studscore),
			 min(si.studscore),
			 avg(si.studscore),
			 count(*)
FROM studinfo s INNER JOIN studscoreinfo si 
ON s.studno=si.studno 
GROUP BY studno;


CREATE VIEW V_StudAvgScore
AS
SELECT s.studno,
			 studname,
			 avg(studscore),
			 sum(studscore),
			 max(studscore),
			 min(studscore),
			 count(*)
FROM studinfo s INNER JOIN studscoreinfo si 
ON s.studno=si.studno 
GROUP BY studno;


SELECT s.studno,
			 s.studname,
			 s.`avg(studscore)`,
			 count(*),
			 a.classname
FROM v_studavgscore s INNER JOIN v_getallstudinfo a
ON s.studno=a.studno
WHERE (s.`avg(studscore)` BETWEEN 60 AND 70) OR (s.`avg(studscore)` BETWEEN 80 AND 85)
GROUP BY s.studno;


SELECT s.studno,
			 s.studname,
			 avg(studscore),
       a.studgender,
			 si.studbirthday,
       a.classname
FROM v_studavgscore s  INNER JOIN v_getallstudinfo a
ON s.studno=a.studno
INNER JOIN studinfo si ON si.studno=s.studno
WHERE S.`avg(studscore)` > 80
GROUP BY S.studno

#############################################
CREATE PROCEDURE proc_IF()
BEGIN
	Declare I int;
	Set I=5;
	If I>5 then
		set I=I*2;
	else
		set I=I mod 2;
	END if;
	select I;
end;
call proc_if;


create procedure proc_while()
BEGIN
		Declare I int;
		declare Result Int;
		Set I=3;
		Set Result=10;
		While I<Result do
				Set I=I+Result mod 3;
				Set Result=Result-I mod 4;
		End while;
		Set I=I+Result;
		select I;
end;
call proc_while;


create procedure proc_while2()
BEGIN
	  Declare I int;
    Declare Result Int;
		Set I=0;
		Set Result=2;
		While i<3 do
				Set Result=Result+Power(i,i);
				set i=i+1;
		end while;
		select Result;
end;
call proc_while2;

create procedure proc_while3()
BEGIN
		Declare I int;
		Declare Result Int;
		Set I=3;
		Set Result=2;
		While i>0 do
				Set Result=Result+Power(2,i)-1;
				set i=i-1;
		end while;
		select Result;
end;
call proc_while3;

create procedure proc_case()
BEGIN
		Declare I int;
		declare Result int;
		declare MyStr varchar(10);
		set I=LOCATE('BC','ABCCBBCDA',3);
		Set Result=I mod 4;
		Case Result
				When 1 then set MyStr= Substring('ABCD',2,Result);
				When 2 then set MyStr= Substring('ABCD',Result,2);
				When 3 then set MyStr= Substring('ABCD',Result-1,2);
				else
						set mystr= 'No';
		End case;
		select Result ;
		select MyStr;
end;
call proc_case;

#7.2
DELIMITER&&
DROP PROCEDURE IF EXISTS PROC_PRINTF;
CREATE PROCEDURE proc_printf()
BEGIN
		DECLARE I INT DEFAULT 65;
		DECLARE R VARCHAR(100);
		WHILE I < 65+26 DO
				IF R IS NULL THEN
						SET R=CHAR(I);
				ELSE
						SET R=CONCAT_WS(',',R,CHAR(I));
				END IF;
				SET I=I+1;
		END WHILE;
		SELECT R;
END&&
CALL PROC_PRINTF;

#7.3
DROP PROCEDURE IF EXISTS PROC_NJ; 
CREATE PROCEDURE proc_nj(IN M INT)
BEGIN
		DECLARE i INT DEFAULT 1;
		DECLARE n INT DEFAULT 1;
		WHILE i<=M DO
						SET n=n*i;
						SET i=i+1;					
		END WHILE;
		SELECT i;
		SELECT n;
END;
CALL proc_nj(5)

#7.4
DROP PROCEDURE IF EXISTS PROC_SUMJ;
CREATE PROCEDURE PROC_SUMJ()
BEGIN
		DECLARE n INT DEFAULT 1;
		DECLARE s INT DEFAULT 1;
		DECLARE i INT DEFAULT 1;
		DECLARE k BIGINT DEFAULT 1;
		WHILE s < 10000 DO
				SET n=2*n+1;
				WHILE i<n DO
						SET @k = @k * @i;
						SET i=i+1;
				SET s=s+i;
				END WHILE;
		END WHILE;
		SELECT s;
		SELECT n;
END;
CALL PROC_SUMJ;

#7.5
DROP PROCEDURE IF EXISTS PROC_2J;
CREATE PROCEDURE PROC_2J(IN m INT)
BEGIN
		DECLARE i INT DEFAULT 1;
		DECLARE s BIGINT DEFAULT 0;
		DECLARE n BIGINT DEFAULT 2;
		WHILE i<=10 DO
				SET s=s+n;
				SET n=n*10+2;
				SET i=i+1;
		END WHILE;
		SELECT s;
END;
CALL PROC_2J(10);

#7.6
DROP PROCEDURE IF EXISTS PROC_FEN;
CREATE PROCEDURE PROC_FEN()
BEGIN
		DECLARE z INT DEFAULT 1;
		DECLARE m INT DEFAULT 1;
		DECLARE s FLOAT DEFAULT 0;
		DECLARE i INT DEFAULT 1;
		DECLARE T FLOAT;
		WHILE i<=20 DO
				SET T=z/m;
#				SELECT T;
				SET s=s+T;
				SET m=z+m;
				SET z=m-z;
				SET i=i+1;
		END WHILE;
		SELECT s;
END;
CALL PROC_FEN;

#7.7
DROP PROCEDURE IF EXISTS PROC_SSUM;
CREATE PROCEDURE PROC_SSUM(IN n INT)
BEGIN
		DECLARE i,j INT;
		DECLARE s1,s2 BIGINT;
		SET i=1,j=1,s1=0,s2=0;
		WHILE i<=n DO
				WHILE j<=i DO
						SET s2=s2+j;
						SET j=j+1;
				END WHILE;
#				SELECT s2;
				SET j=1;
				SET s1=s1+s2;
				SET i=i+1;
				SET s2=0;
		END WHILE;
		SELECT s1;
END;
CALL PROC_SSUM(20)

#7.8
DROP PROCEDURE IF EXISTS PROC_Fj;
CREATE PROCEDURE PROC_FJ(IN n INT)
BEGIN
		DECLARE i,j,k INT;
		DECLARE s1,T FLOAT;
		DECLARE z,m BIGINT;
		SET i=1,j=1,k=1,s1=0,z=1,m=1;
		WHILE i<=n DO
				SET z=2*i-1;
				SET m=2*i+1;
				WHILE j<=z DO
						SET @z=@z*@j;
						SET j=j+1;
				END WHILE;
				SET j=1;
				WHILE k<=m DO
						SET @m=@m*@k;
						SET k=k+1;
				END WHILE;
				SET k=1;
				SET T=z/m;
				SET s1=s1+T;
		END WHILE;
		SELECT s1;
END;
CALL PROC_FJ(10);

#############################################
#8.1-1
SELECT *
FROM studinfo
WHERE StudName LIKE '%丽';
#8.1-2
SELECT *
FROM studinfo
WHERE RIGHT(StudName,1) = '丽';

SELECT *
FROM studinfo
WHERE LEFT(StudName,1) = '刘';
#8.2
UPDATE studinfo
SET StudName=REPLACE(LEFT(StudName,1),'刘','牛')
#############################################
#9.1
CREATE PROCEDURE RrocGETA_Z
BEGIN
		DECLARE I INT DEFAULT 65;
		DECLARE R VARCHAR(100);
		WHILE I < 65+26 DO
				IF R IS NULL THEN
						SET R=CHAR(I);
				ELSE
						SET R=CONCAT_WS(',',R,CHAR(I));
				END IF;
				SET I=I+1;
		END WHILE;
		SELECT R;
END;
CALL ProcGETA_Z

#实例
DELIMITER //
 DROP PROCEDURE if exists P_Save_ClassInfo;
 Create Procedure P_Save_ClassInfo (in CID Varchar(10),in CName Varchar(50),in CDesc Varchar(100),out msg varchar(20))
begin
if Exists(Select * From ClassInfo Where ClassID=CID) then
Update ClassInfo Set ClassName=CName,ClassDesc=CDesc
 Where ClassID=CID;
 set msg='修改成功';
 Else
 Insert Into ClassInfo(ClassID,ClassName,ClassDesc) Values (CID,CName,CDesc);
 set msg='添加成功';
 End if;
 End //
 DELIMITER ;
 call P_Save_ClassInfo('20181152','computer2018','good',@msg);
 select @msg;
 
 select * from classinfo